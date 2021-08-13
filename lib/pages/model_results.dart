import 'dart:math';
import 'package:camera/camera.dart';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quiver/collection.dart';
import 'dart:io';
import 'package:tflite/tflite.dart';
import 'package:image/image.dart' as IMG;
import 'package:quiver/iterables.dart';
import 'package:transfer_learning_fruit_veggies/pages/second_picture.dart';
import 'package:flutter_dash/flutter_dash.dart';

import 'package:transfer_learning_fruit_veggies/model/food.dart';
import 'package:transfer_learning_fruit_veggies/services/local_storage_service.dart';
import 'package:transfer_learning_fruit_veggies/bloc/food_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transfer_learning_fruit_veggies/events/add_food.dart';
import 'package:shared_preferences/shared_preferences.dart';

//JSON
import 'package:transfer_learning_fruit_veggies/source/nutrition_table.dart';

const int OUTPUTSIZE = 513 * 513;
const double COINPIXELS = pi * (513 / 16) * (513 / 16); // 3230 pixels
const double COINDIAMETERPIXELS = 513 / 4;

double COINDIAMETERIRLCM = 1.2875 * 2;
double SURFACE2EUROS = pi * 12.875 * 12.875; // 521 mm2

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final bool isSamsung;
  final CameraController controller;
  final bool volume;
  final Map surfaces;
  final Map distances;

  const DisplayPictureScreen({
    Key? key,
    required this.imagePath,
    required this.isSamsung,
    required this.controller,
    required this.volume,
    required this.surfaces,
    required this.distances,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Meal'),
        brightness: Brightness.dark,
      ),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Segmentation(
        imagePath: this.imagePath,
        isSamsung: this.isSamsung,
        controller: this.controller,
        volume: this.volume,
        surfaces: this.surfaces,
        distances: this.distances,
      ),
    );
  }
}

class Segmentation extends StatefulWidget {
  final String imagePath;
  final bool isSamsung;
  final CameraController controller;
  final bool volume;
  final Map surfaces;
  final Map distances;
  Segmentation({
    required this.imagePath,
    required this.isSamsung,
    required this.controller,
    required this.volume,
    required this.surfaces,
    required this.distances,
  });

  @override
  _SegmentationState createState() => _SegmentationState();
}

class _SegmentationState extends State<Segmentation> {
/* ****************************************************************************/
/* *********************  FUNCTIONS SIGNATURES  *******************************/
/* ****************************************************************************/

  // SOMMAIRE :
  //   ==> Segmentation Image
  //    dynamic segmentImage(String imagePath);

  // ==> estimation algorith
  //  Map<dynamic, dynamic> computeThicknessIfVolume(outputClassesVolume)
  //  Map<dynamic, dynamic> computeDistanceifNoVolume(outputClassesSurface)
  //  List computeSurfaceAndAddPixelsCoordinates(dynamic outputraw)
  //  Map computeOutputClassesHeight(List<List<List<int>>> outputClassesVolume)
  //   Map computeOutputClassesDistance(List<List<List<int>>> outputClassesSurface)
  //  double getDistance(List<List<int>> typeOfClassPixels)
  //  int getThicknessprecise(List<List<int>> typeOfClassPixels, String classe)
  //  List maxClasse()
  //  void addElementToDatabase(List keyValue)

  // ==> WIDGET
  //  Positioned placeTopThicknessPoint(int selectedClass, var SIZEWIDTH)
  //  Positioned placeBotThicknessPoint(int selectedClass, var SIZEWIDTH)
  //  Positioned placeLineBetweenTopAndBotThickness(
  //  int selectedClass, var SIZEWIDTH)
  //  Widget drawThick(int selectedClass)
  //  Widget volumeList()
  //  ActionChip displayVolumeInfo(item, color, widSurfKey, thickness, volume, i)
  //  Widget displayGetVolumeEstimationButton(bool volume) Widget helpMessageUtilisationSlider()
  //  Widget sliderThickness()
  //   Widget displaySlider(bool volume)
  //   ActionChip displaySurfaceInfo(percent, surface, color, e)
  //  ListView surfaceList(categories)
  //  Widget displaySurfaceOrVolume(bool volume, List<String> categories)
  //  Widget displayPictureWithSegFilter(var SIZEWIDTH)
  //  Center displayLoadingScreen()
  //  Column displaySurfaceAndVolumeInfos(SIZEWIDTH, categories)

  /* **************************************************************************/
  /* *********************  Classes and COlors  *******************************/
  /* **************************************************************************/
  static List<int> pascalVOCLabelColors = [
    Color.fromARGB(255, 0, 0, 0).value, // background
    Color.fromARGB(255, 128, 0, 0).value, // leafy_greens
    Color.fromARGB(255, 0, 128, 0).value, // stem_vegetables
    Color.fromARGB(255, 128, 128, 0).value, // non-starchy_roots
    Color.fromARGB(255, 0, 0, 128).value, // vegetables | other
    Color.fromARGB(255, 128, 0, 128).value, // fruits
    Color.fromARGB(255, 0, 128, 128).value, // protein | meat
    Color.fromARGB(255, 128, 128, 128).value, // protein | poultry
    Color.fromARGB(255, 64, 0, 0).value, // protein | seafood
    Color.fromARGB(255, 192, 0, 0).value, // protein | eggs
    Color.fromARGB(255, 64, 128, 0).value, // protein | beans/nuts
    Color.fromARGB(255, 192, 128, 0).value, // starches/grains | baked_goods
    Color.fromARGB(255, 64, 0, 128)
        .value, // starches/grains | rice/grains/cereals
    Color.fromARGB(255, 192, 0, 128).value, // starches/grains | noodles/pasta
    Color.fromARGB(255, 255, 64, 64)
        .value, // starches/grains | starchy_vegetables
    Color.fromARGB(255, 192, 128, 128).value, // starches/grains | other
    Color.fromARGB(255, 0, 64, 0).value, // soups/stews
    Color.fromARGB(255, 128, 64, 0).value, // herbs/spices
    Color.fromARGB(255, 0, 192, 0).value, // dairy
    Color.fromARGB(255, 128, 192, 0).value, // snacks
    Color.fromARGB(255, 0, 64, 128).value, // sweets/desserts
    Color.fromARGB(255, 128, 64, 64).value, // beverages
    Color.fromARGB(255, 64, 64, 128).value, // fats/oils/sauces
    Color.fromARGB(255, 64, 64, 64).value, // food_containers
    Color.fromARGB(255, 192, 192, 192).value, // dining_tools
    Color.fromARGB(255, 192, 64, 64).value, // other_food
  ];
  static var classes = {
    '[0, 0, 0, 255]': 'Background 🏞️',
    '[128, 0, 0, 255]': 'Leafy Greens 🥬',
    '[0, 128, 0, 255]': 'Stem Vegetables 🥦',
    '[128, 128, 0, 255]': 'Non-starchy Roots 🍅',
    '[0, 0, 128, 255]': 'Vegetables | Other 🌽',
    '[128, 0, 128, 255]': 'Fruits 🍓',
    '[0, 128, 128, 255]': 'Protein | Meat 🥩',
    '[128, 128, 128, 255]': 'Protein | Poultry 🍗',
    '[64, 0, 0, 255]': 'Protein | Seafood 🐟',
    '[192, 0, 0, 255]': 'Protein | Eggs 🍳',
    '[64, 128, 0, 255]': 'Protein | Beans/nuts 🥜',
    '[192, 128, 0, 255]': 'Starches/grains | Baked Goods 🥐',
    '[64, 0, 128, 255]': 'Starches/grains | rice/grains/cereals 🍚',
    '[192, 0, 128, 255]': 'Starches/grains | Noodles/pasta 🍝',
    '[255, 64, 64, 255]': 'Starches/grains | Starchy Vegetables 🥔',
    '[192, 128, 128, 255]': 'Starches/grains | Other 🌾',
    '[0, 64, 0, 255]': 'Soups/stews 🥣',
    '[128, 64, 0, 255]': 'Herbs/spices 🌿',
    '[0, 192, 0, 255]': 'Dairy 🥛',
    '[128, 192, 0, 255]': 'Snacks 🍫',
    '[0, 64, 128, 255]': 'Sweets/desserts 🍰',
    '[128, 64, 64, 255]': 'Beverages 🥤',
    '[64, 64, 128, 255]': 'Fats/oils/sauces 🥫',
    '[64, 64, 64, 255]': 'Food Containers 🍽️',
    '[192, 192, 192, 255]': 'Dining Tools 🍴',
    '[192, 64, 64, 255]': 'Other Food ❓'
  };

  /* **************************************************************************/
  /* *********************  Globals VARIABLE  *********************************/
  /* **************************************************************************/
  var KEYS = classes.keys.toList();
  var VALUES = classes.values.toList();
  Map surfaceSaved = Map();

  bool _loading = true;
  var _outputPNG; // Mask
  var _outputRAW; // classic picture taken
  Map _outputClasses = Map();
  Map classVolumeDistance = Map();

  List<List<List<int>>> _outputClassesVolume = [];
  List<List<List<int>>> _outputClassesSurface = [];
  List<String> classVolumeName = [];
  Map _outputClassesHeight = Map();
  Map _outputClassesDistance = Map();
  List<List<int>> minMax = [];
  int _selectedClass = -1;
  Food finalMeal = Food(nameFood: "");

  @override
  void initState() {
    super.initState();
    setState(() {
      loadDimensions();
    });
    segmentImage(widget.imagePath);
  }

  void loadDimensions() async {
    final prefs = await SharedPreferences.getInstance();
    COINDIAMETERIRLCM = prefs.getDouble("coinDiameterCm")!;
    SURFACE2EUROS = prefs.getDouble("coinSurfaceMm2")!;
  }

  /* **************************************************************************/
  /* *********************  SEGMENTATION IMAGE  *******************************/
  /* **************************************************************************/

  dynamic segmentImage(String imagePath) async {
    var output;
    var outputraw;

    if (widget.isSamsung) {
      final originalFile = File(imagePath);
      List<int> imageBytes = await originalFile.readAsBytes();

      final originalImage = IMG.decodeImage(imageBytes);
      final height = originalImage!.height; // if we delete this we have errors
      final width = originalImage.width;

      IMG.Image fixedImage =
          IMG.copyRotate(originalImage, 90); // turn 90° the image for samsung
      final fixedFile =
          await originalFile.writeAsBytes(IMG.encodePng(fixedImage));

      output = await Tflite.runSegmentationOnImage(
        path: fixedFile.path,
        imageMean: 0.0,
        imageStd: 255.0,
        labelColors: pascalVOCLabelColors,
        outputType: 'png',
      );
      outputraw = IMG.decodePng(output);
    } else {
      output = await Tflite.runSegmentationOnImage(
        // Segmentation for regular Mobile Phone
        path: imagePath,
        imageMean: 0.0,
        imageStd: 255.0,
        labelColors: pascalVOCLabelColors,
        outputType: 'png',
      );
      outputraw = IMG.decodePng(output);
    }

    if (outputraw != null)
      outputraw = outputraw.getBytes(format: IMG.Format.rgba);

    //Here we go through all pixels
    List pixelIterate = computeSurfaceAndAddPixelsCoordinates(outputraw);
    Map outputClasses = pixelIterate[0];
    List<List<List<int>>> outputClassesSurface = pixelIterate[1];
    List<List<List<int>>> outputClassesVolume = pixelIterate[2];

    Map outputClassesHeight = Map();
    Map outputClassesDistance = Map();

    outputClassesHeight = computeThicknessIfVolume(outputClassesVolume);
    outputClassesDistance = computeDistanceifNoVolume(outputClassesSurface);

    setState(() {
      _outputPNG = output;
      _outputRAW = outputraw;
      _outputClasses = outputClasses;
      _outputClassesSurface = outputClassesSurface;
      _outputClassesVolume = outputClassesVolume;
      _outputClassesDistance = outputClassesDistance;
      _outputClassesHeight = outputClassesHeight;

      var categories = classes.values.toList();
      if (!widget.volume) {
        _outputClasses.entries.forEach((e) {
          int percent = ((e.value / OUTPUTSIZE) * 100).round();
          if (percent > 1) {
            int surface = (e.value * SURFACE2EUROS / COINPIXELS / 100).round();
            int index = categories.indexOf(e.key);
            int color = pascalVOCLabelColors[index];

            if (!(e.key == 'Background 🏞️' ||
                e.key == 'Food Containers 🍽️' ||
                e.key == 'Dining Tools 🍴')) {
              surfaceSaved[e.key] = [surface, percent, color];
            }
          }
        });
      } else
        surfaceSaved = widget.surfaces;

      classVolumeName.forEach((element) {
        classVolumeDistance[element] = [
          widget.distances[VALUES.indexOf(element)], // distance
          surfaceSaved[element][0]
        ];
      });
      print(surfaceSaved);
      print(classVolumeDistance);
      _loading = false;
    });

    // List keyValue = maxClasse();
    // addElementToDatabase(keyValue);
  }

  /* **************************************************************************/
  /* ********************  ESTIMATION ALGORITHM   *****************************/
  /* **************************************************************************/

  /// return a Map : [idx general of the class (from map) : thicknessClass, ...]

  Map<dynamic, dynamic> computeThicknessIfVolume(outputClassesVolume) {
    return widget.volume
        ? computeOutputClassesHeight(outputClassesVolume)
        : Map();
  }

  /// return a Map : [idx general of the class (from map) : Dist coinClass, ...]

  Map<dynamic, dynamic> computeDistanceifNoVolume(outputClassesSurface) {
    return !widget.volume
        ? computeOutputClassesDistance(outputClassesSurface)
        : Map();
  }

  ///return 3 Lists :
  ///-outputClass List : [[r,g,b] : 'labelClasse' , .....]
  ///-outputClasseSurface List : [ [r,g,b,i,j], .....]
  ///-outputClasseVolume List : [ [r,g,b,i,j], .....]

  List computeSurfaceAndAddPixelsCoordinates(dynamic outputraw) {
    Iterable<List<int>> pixels = partition(outputraw, 4);
    List<List<List<int>>> outputClassesVolume = [];
    List<List<List<int>>> outputClassesSurface = [];

    for (int k = 0; k < widget.surfaces.length; k++) {
      outputClassesVolume.add([]);
    }

    for (int k = 0; k < 26; k++) {
      outputClassesSurface.add([]);
    }
    Map outputClasses = Map();
    int forEachCount = 0;
    String e;
    var i, c;
    pixels.forEach(
      (element) {
        //surface
        e = element.toString();
        i = KEYS.indexOf(e);
        c = VALUES[i];
        if (!outputClasses.containsKey(c)) {
          outputClasses[c] = 1;
        } else {
          outputClasses[c] += 1;
        }
        if (!widget.volume) {
          outputClassesSurface[i].add(
              element + [(forEachCount / 513).round(), forEachCount % 513]);
        }

        if (widget.surfaces.containsKey(c)) {
          i = widget.surfaces.keys.toList().indexOf(c);

          //concatene list [jsaipaskwa, r,g,b] et [i,j]
          outputClassesVolume[i].add(
              element + [(forEachCount / 513).round(), forEachCount % 513]);
        }
        forEachCount++;
      },
    );
    return [outputClasses, outputClassesSurface, outputClassesVolume];
  }

  /// param : a List (for each class) of a List of pixels [r,g,b,i,j].
  /// Return a Map of the distances between coin and the differentes classes
  /// Detected
  /// return a Map : [idx general of the class (from general map) : thickness, ...]

  Map computeOutputClassesHeight(List<List<List<int>>> outputClassesVolume) {
    Map outputClassesHeight = Map();
    List<int> elemHeight = [];
    String e;
    var i, c;
    for (int l = 0; l < widget.surfaces.length; l++) {
      if (outputClassesVolume[l].length != 0) {
        elemHeight = elemHeight + //du premier pixel de la classe d'indice l
            [outputClassesVolume[l][0][0]] + //transparence
            [outputClassesVolume[l][0][1]] + //r
            [outputClassesVolume[l][0][2]] + //g
            [outputClassesVolume[l][0][3]]; //b
        e = elemHeight.toString(); //[t,r,g,b] en string
        i = KEYS.indexOf(e);
        c = VALUES[i];

        outputClassesHeight[c] = getThicknessprecise(outputClassesVolume[l], c);
        elemHeight = [];
      }
    }
    return outputClassesHeight;
  }

  /// param : a List (for each class) of a List of pixels [r,g,b,i,j].
  /// Return a Map of the distances between coin and the differentes classes
  /// Detected
  /// return a Map : [idx general of the class (from general map) : Dist coinClass, ...]

  Map computeOutputClassesDistance(List<List<List<int>>> outputClassesSurface) {
    Map outputClassesDistance = Map();
    List<int> elemDist = [];
    String e;
    var i, c;
    for (int l = 0; l < outputClassesSurface.length; l++) {
      if (outputClassesSurface[l].length != 0) {
        elemDist = elemDist + //du premier pixel de la classe d'indice l
            [outputClassesSurface[l][0][0]] + //transparence
            [outputClassesSurface[l][0][1]] + //r
            [outputClassesSurface[l][0][2]] + //g
            [outputClassesSurface[l][0][3]]; //b
        e = elemDist.toString(); //[t,r,g,b] en string
        i = KEYS.indexOf(e);
        c = VALUES[i];
        outputClassesDistance[i] = getDistance(outputClassesSurface[l]);
        elemDist = [];
      }
    }
    return outputClassesDistance;
  }

  // param : Lists of pixels [ [r,g,b], [r,g,b2], ....]
  // return a double : distance between coin center and  food item in cm
  // for one class

  double getDistance(List<List<int>> typeOfClassPixels) {
    if (typeOfClassPixels.length == 0) {
      return 0;
    }
    int xmax = 0;
    double distancePixel, distanceCoinFood;
    List<int> listX = []; // correspond aux i cad lignes

    for (int k = 0; k < typeOfClassPixels.length; k++) {
      listX.add(typeOfClassPixels[k][4]); //[t,r,g,b,i,j] donc i
    }
    xmax = listX.reduce(math.max);
    distancePixel =
        (513 - 513 / 16 - xmax); // /16 because the middle of the coin
    distanceCoinFood =
        (distancePixel * COINDIAMETERIRLCM / (COINDIAMETERPIXELS / 2));
    if (distanceCoinFood < 0) {
      return distanceCoinFood.abs();
    } else
      return distanceCoinFood;
  }

  /// Get an estimation of the thickness
  /// Check the comment inside the function to understand it.
  /// Store in minMax global variable the coordonates of the thickness
  /// [yTopThickness, xBottomThickness, yBottomThickness, xBottomThickness]
  /// and return the value in pixel of the thickness

  int getThicknessprecise(List<List<int>> typeOfClassPixels, String classe) {
    if (typeOfClassPixels.length == 0) {
      return 0;
    }
    var SIZEWIDTH = MediaQuery.of(context).size.width;
    List<int> listX = []; // correspond aux i cad lignes
    List<int> listY = []; // correspond aux j cad colonnes
    for (int k = 0; k < typeOfClassPixels.length; k++) {
      listY.add(typeOfClassPixels[k][4]); //[t,r,g,b,i,j] donc i
      listX.add(typeOfClassPixels[k][5]); //[t,r,g,b,i,j] donc j
    }
    double limitDownPlate = (SIZEWIDTH / 4); // big axe of the ellipse
    /// ymax represent the y at the bottom of the food piece without considering
    /// the area where the coin is in term of height
    int yBottomThickness =
        listY.lastWhere((element) => (element < (513 - limitDownPlate)));

    int idxBottomThickness = listY.indexOf(yBottomThickness);
    int xBottomThickness = listX[idxBottomThickness];

    int Xmin = listX.reduce(math.min);
    int idxmin = listX.indexOf(Xmin);

    // y of the point that is at the total left
    //ie  where the x is the lower
    int Ymin = listY[idxmin];

    List<int> pixelPossible = [];
    for (int i = 0; i < typeOfClassPixels.length; i++) {
      // at the top of the bottom of the thickness
      // and "not too far" from the X which is at the left limit
      if (listY[i] < yBottomThickness && (listX[i] - Xmin).abs() < 5) {
        pixelPossible.add(listY[i]);
      }
    }

    int yTopThickness = listY.reduce(math.min);
    if (pixelPossible.length != 0) {
      // y at the top of the thickness
      yTopThickness = pixelPossible.reduce(math.min);
    }

    // (ytop, xbot)  and (ybot xbot)
    // we dont use xtop in the first coordonnate because we want to draw
    // a line between the point the hiwer and the lower of the food
    // and taking the x of the bottom of the thickness is quite better. (Ithink)
    minMax.add(
        [yTopThickness, xBottomThickness, yBottomThickness, xBottomThickness]);
    classVolumeName.add(classe);
    return (yBottomThickness - yTopThickness).round();
  }

  /// return real value in pixel of the perspective thickness
  /// ywithperspective = thickness number of pixels of the 2nd picture (deformed)
  /// xDistCoinClass = distance in cm
  ///

  double getPixelConsideringPerspective(
      double yWithPerspective, double xDistCoinClass) {
    return yWithPerspective *
        (1 / (1.54 - 0.39 * log(0.94 * (xDistCoinClass) + 4.00)));
  }
  //thickdeformee = thickReel - 9.33*xdistance

  /* **************************************************************************/
  /* **************************  DATABASE  ************************************/
  /* **************************************************************************/

  /// some function to change
  // List maxClasse(Map outputFinal) {
  //   var thevalue = 0;
  //   var thekey = 'Background 🏞️';
  //   //k != 'Food Containers 🍽️' && k != 'Background 🏞️' &&
  //   outputFinal.forEach((k, v) {
  //     if (k != 'Food Containers 🍽️' && k != 'Background 🏞️' && v > thevalue) {
  //       thevalue = v;
  //       thekey = k;
  //     }
  //   });

  //   return [thekey, thevalue];
  // }

  /// return a list of parsed item base on a MAP which contain
  ///  {nameClass: volume, ...}
  List<Food> parseAllIngredients(Map outputFinal) {
    Map<dynamic, dynamic> dataJson;
    List<Food> listAllIngredient = [];
    outputFinal.forEach((k, v) {
      if (k != 'Food Containers 🍽️' &&
          k != 'Background 🏞️' &&
          k != 'Dining Tools 🍴' &&
          k != 'Other Food ❓') {
        listAllIngredient.add(parseFoodData(k, v));
      }
    });
    return listAllIngredient;
  }

  /// parse a single Food item
  Food parseFoodData(String nameF, int volume) {
    Food food = new Food(nameFood: nameF);
    Map<dynamic, dynamic> dataJson;
    dataJson =
        foodNutritionJson.firstWhere((element) => element["name"] == nameF);

    Random myrand = Random();
    food.volEstim = volume;
    food.volumicMass = roundDouble((dataJson["vm"] * 100), 2);
    food.mass = roundDouble(
        ((food.volEstim.toDouble() * food.volumicMass) ~/ 100).toDouble(), 2);
    food.nutriscore = dataJson["nutriscore"].toString();
    food.kal = roundDouble((dataJson["cal"] * food.mass / 100), 2);
    food.carbohydrates = roundDouble(myrand.nextDouble() * 100, 2);
    food.protein = roundDouble(myrand.nextDouble() * 100, 2);
    food.sugar = roundDouble(myrand.nextDouble() * 25, 2);
    food.fat = roundDouble(myrand.nextDouble() * 30, 2);
    String blabla = food.toString();
    return food;
  }

  Food computeMealStats(List<Food> listAllIngredient) {
    Food mealResults = new Food(nameFood: "");
    mealResults.nameFood = "Meal " + mealResults.id.toString();
    for (int i = 0; i < listAllIngredient.length; i++) {
      mealResults.volEstim += listAllIngredient[i].volEstim;
      //mealResults.mass = listAllIngredient[i].volEstim;
      //mealResults.nutriscore = 'A';
      mealResults.kal += listAllIngredient[i].kal;
      mealResults.carbohydrates += listAllIngredient[i].carbohydrates;
      mealResults.protein += listAllIngredient[i].protein;
      mealResults.sugar += listAllIngredient[i].sugar;
      mealResults.fat += listAllIngredient[i].fat;
      mealResults.mass += listAllIngredient[i].mass;
      mealResults.volumicMass += listAllIngredient[i].volumicMass;
    }
    return mealResults;
  }

// 2 significatif numbers after dots
  double roundDouble(double value, int places) {
    double mod = pow(10.0, places).toDouble();
    return ((value * mod).round().toDouble() / mod);
  }
  /*
  double roundDouble(double value, int places){ 
   double mod = pow(10.0, places); 
   return ((value * mod).round().toDouble() / mod); 
}

main() {
  double num1 = roundDouble(12.3412, 2);
  // 12.34*/

  /// some function to change
  // void addElementToDatabase(List keyValue) {
  //   int valuecm2 = (keyValue[1] * SURFACE2EUROS / COINPIXELS / 100).round();
  //   String nameFood1 = keyValue[0] + ' : ' + valuecm2.toString() + 'cm²';
  //   Food food = parseFoodData(nameFood1, valuecm2);
  //   DatabaseProvider.db.insert(food).then(
  //         (storedFood) => BlocProvider.of<FoodBloc>(context).add(
  //           AddFood(storedFood),
  //         ),
  //       );
  // }

  //keyvalue[0] = foodNAme
  //keyvalue[1] = volum in cm3
  void addElementToDatabaseAfterVolume(List<Food> allIngredient) {
    finalMeal = computeMealStats(allIngredient);
    String leresult = finalMeal.toString();
  }

  /* **************************************************************************/
  /* ***************************  WIDGET  *************************************/
  /* **************************************************************************/

  Positioned placeTopThicknessPoint(int selectedClass, var SIZEWIDTH) {
    return Positioned(
      top: minMax[selectedClass][0].abs() / 513 * SIZEWIDTH - 5,
      left: minMax[selectedClass][1].abs() / 513 * SIZEWIDTH - 5,
      child: Container(
        height: 10,
        width: 10,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: Theme.of(context).primaryColor),
      ),
    );
  }

  Positioned placeBotThicknessPoint(int selectedClass, var SIZEWIDTH) {
    return Positioned(
      top: minMax[selectedClass][2].abs() / 513 * SIZEWIDTH - 5,
      left: minMax[selectedClass][3].abs() / 513 * SIZEWIDTH - 5,
      child: Container(
        height: 10,
        width: 10,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: Theme.of(context).primaryColor),
      ),
    );
  }

  Positioned placeLineBetweenTopAndBotThickness(
      int selectedClass, var SIZEWIDTH) {
    return Positioned(
      top: minMax[selectedClass][0].abs() / 513 * SIZEWIDTH + 5,
      left: minMax[selectedClass][1].abs() / 513 * SIZEWIDTH,
      child: Dash(
        direction: Axis.vertical,
        length: (minMax[selectedClass][2].abs() / 513 * SIZEWIDTH - 10) -
            (minMax[selectedClass][0].abs() / 513 * SIZEWIDTH),
        dashColor: Theme.of(context).primaryColor,
        dashLength: 4,
        dashBorderRadius: 8,
        dashGap: 5,
      ),
    );
  }

  /// return a Stack where points for drawing thickness is inside.
// yTopThickness, xBottomThickness, yBottomThickness, xBottomThickness
  Widget drawThick(int selectedClass) {
    var SIZEWIDTH = MediaQuery.of(context).size.width;
    final points = <Widget>[];

    points.add(placeTopThicknessPoint(selectedClass, SIZEWIDTH));
    points.add(placeBotThicknessPoint(selectedClass, SIZEWIDTH));
    points.add(
      placeLineBetweenTopAndBotThickness(selectedClass, SIZEWIDTH),
    );
    return Stack(children: points);
  }

  // obtain a list of the volume and the thickness for each class segmented in the first/second picture
  Widget volumeList() {
    Map outputFinal = Map(); // ['nameclass', volumeincm3, .....]
    List<dynamic> widSurfKey = widget.surfaces.keys.toList();
    List<dynamic> widSurfVal = widget.surfaces.values.toList();
    var categories = classes.values.toList();
    var mykeys = widget.distances.keys.toList();
    var dist = widget.distances.values.toList();
    double thickPixels, thickness, distCoinClass, thickPixelsReal;
    int idxClass, idxClassDist; //, index, color, item, surf, volume;
    int index, color, item, surf = 0, volume;

    Widget hey = ListView(
        children: classVolumeDistance.entries.map((e) {
      int i = classVolumeDistance.keys.toList().indexOf(e.key);
      thickPixels = (minMax[i][2].abs() - minMax[i][0].abs()).toDouble();
      idxClass = categories.indexOf(e.key); // replace: classes.values.toList()

      distCoinClass = e.value[0]; // replace:widget.distances.values

      thickPixelsReal =
          getPixelConsideringPerspective(thickPixels, distCoinClass);
      thickness = (thickPixelsReal * COINDIAMETERIRLCM / COINDIAMETERPIXELS);

      color = pascalVOCLabelColors[idxClass];

      item = widSurfKey.indexOf(e.key);

      surf = e.value[1]; //replace: widget.surfaces.values.toList();
      volume = (thickness * surf).round();
      //widSurfkey[i] cest le nameFood
      outputFinal[e.key] = volume;

      return displayVolumeInfo(color, thickness, volume, i);
    }).toList());
    List<Food> allIngredientParsed = parseAllIngredients(outputFinal);
    addElementToDatabaseAfterVolume(allIngredientParsed);

    return hey;
  }

  ActionChip displayVolumeInfo(color, thickness, volume, i) {
    return ActionChip(
      onPressed: () {
        setState(() {
          _selectedClass = i;
        });
      },
      backgroundColor: Color(color),
      shape: StadiumBorder(
        side: BorderSide(
          color: i == _selectedClass
              ? Theme.of(context).primaryColor
              : Color(color),
          width: 2.0,
        ),
      ),
      label: Text(
        classVolumeDistance.keys.elementAt(i) +
            '   ' +
            thickness.toStringAsFixed(1) +
            'cm | Vol. ' +
            volume.toString() +
            'cm³',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget displayGetVolumeEstimationButton(bool volume) {
    return !volume
        ? ElevatedButton.icon(
            icon: Icon(Icons.panorama_photosphere),
            label: Text('Get Volume Estimation'),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SecondPictureScreen(
                    controller: widget.controller,
                    surfaces: surfaceSaved,
                    distances: _outputClassesDistance,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(50.0),
              ),
              primary: Theme.of(context).primaryColor,
            ),
          )
        : Container();
  }

  Widget getDisplayValidateMenuButton() {
    return ElevatedButton.icon(
      icon: Icon(Icons.panorama_photosphere),
      label: Text('Validate Menu'),
      onPressed: () async {
        await DatabaseProvider.db.insert(finalMeal).then(
              (storedFood) => BlocProvider.of<FoodBloc>(context).add(
                AddFood(storedFood),
              ),
            );
        Navigator.pop(
            context, 'retour à prendre la photo de volume estimation');
        Navigator.pop(
            context, 'retour aux resultats de segmentation de limage');
        Navigator.pop(context, 'retour à prendre la photo de limage');
        //tabController.animateTo(4, curve: ElasticInCurve());
        //await Navigator.popAndPushNamed(context, 'mealHistory');
        // await Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => HistoryMeal(),
        //   ),
        // );
      },
      style: ElevatedButton.styleFrom(
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(50.0),
        ),
        primary: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget helpMessageUtilisationSlider() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Theme.of(context).buttonColor,
          borderRadius: BorderRadius.circular(50),
        ),
        child: getDisplayValidateMenuButton(),
      ),
    );
  }

  Widget sliderThickness() {
    return RangeSlider(
      activeColor: Theme.of(context).primaryColor,
      values: RangeValues(
          minMax[_selectedClass][2].toDouble() > 0
              ? -minMax[_selectedClass][2].toDouble()
              : minMax[_selectedClass][2].toDouble(),
          minMax[_selectedClass][0].toDouble() > 0
              ? -minMax[_selectedClass][0].toDouble()
              : minMax[_selectedClass][0].toDouble()),
      min: -513.0,
      max: 0.0,
      onChanged: (RangeValues value) {
        setState(
          () {
            minMax[_selectedClass][0] = value.end.toInt();
            minMax[_selectedClass][2] = value.start.toInt();
          },
        );
      },
    );
  }

  Widget displaySlider(bool volume) {
    return volume
        ? Column(
            children: [
              _selectedClass != -1 ? sliderThickness() : Container(),
              helpMessageUtilisationSlider(),
            ],
          )
        : Container();
  }

  ActionChip displaySurfaceInfo(percent, surface, color, e) {
    int i = surfaceSaved.keys.toList().indexOf(e.key);
    return ActionChip(
      onPressed: () {},
      shape: StadiumBorder(
        side: BorderSide(
          color: i == _selectedClass
              ? Theme.of(context).primaryColor
              : Color(color),
          width: 2.0,
        ),
      ),
      avatar: CircleAvatar(
        backgroundColor: Colors.white,
        child: Text(percent.toString() + "%",
            style: TextStyle(color: Color(color), fontSize: 10)),
      ),
      backgroundColor: Color(color),
      label: Text(
        e.key + '   ' + surface.toString() + 'cm²',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  ListView surfaceList(categories) {
    return ListView(
      children: surfaceSaved.entries.map(
        (e) {
          return displaySurfaceInfo(e.value[1], e.value[0], e.value[2], e);
        },
      ).toList(),
    );
  }

  Widget displaySurfaceOrVolume(bool volume, List<String> categories) {
    return !volume ? surfaceList(categories) : volumeList();
  }

  Widget displayPictureWithSegFilter(var SIZEWIDTH) {
    return Stack(
      children: [
        Container(
          height: SIZEWIDTH,
          width: SIZEWIDTH,
          child: Opacity(
              opacity: 0.3,
              child: Image.file(
                File(widget.imagePath),
                fit: BoxFit.fill,
              )),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: MemoryImage(_outputPNG),
              fit: BoxFit.fill,
            ),
          ),
        ),
        widget.volume
            ? Container(
                height: SIZEWIDTH,
                width: SIZEWIDTH,
                child: _selectedClass != -1
                    ? drawThick(_selectedClass)
                    : Container(),
              )
            : Container(),
      ],
    );
  }

  Center displayLoadingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(color: Theme.of(context).primaryColor),
          SizedBox(height: 10),
          Text('Cooking...'),
        ],
      ),
    );
  }

  Column displaySurfaceAndVolumeInfos(SIZEWIDTH, categories) {
    return Column(
      children: [
        displayPictureWithSegFilter(SIZEWIDTH),
        Expanded(
          child: displaySurfaceOrVolume(widget.volume, categories),
        ),
        _selectedClass != -1 ? dislayEditButtons(widget.volume) : Container(),
        displaySlider(widget.volume),
        displayGetVolumeEstimationButton(widget.volume),
        SizedBox(height: 25),
      ],
    );
  }

  Widget dislayEditButtons(bool volume) {
    var categories = classes.values.toList();
    var allClassesSet = Set.from(this.VALUES);
    var representedSet = Set.from(classVolumeDistance.keys);
    List<String> intersection =
        List.from(allClassesSet.difference(representedSet));

    return !volume
        ? Container()
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ActionChip(
                label: Text('Delete'),
                avatar: Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    String elem =
                        classVolumeDistance.keys.elementAt(_selectedClass);
                    classVolumeDistance.remove(elem);
                    //surfaceSaved.remove(elem);
                    _selectedClass = -1;
                  });
                },
              ),
              SizedBox(width: 15.0),
              DropdownButton<String>(
                value: classVolumeDistance.keys.elementAt(_selectedClass),
                icon: const Icon(Icons.edit),
                onChanged: (String? newValue) {
                  setState(() {
                    // seems that we are obliged to create a new map
                    Map newMap = Map();
                    String elem =
                        classVolumeDistance.keys.elementAt(_selectedClass);
                    classVolumeDistance.forEach((key, value) {
                      if (key == elem) {
                        newMap[newValue!] = value;
                      } else {
                        newMap[key] = value;
                      }
                    });
                    classVolumeDistance = newMap;
                  });
                },
                items: (intersection +
                        [classVolumeDistance.keys.elementAt(_selectedClass)])
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              )
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    var SIZEWIDTH = MediaQuery.of(context).size.width;
    var categories = classes.values.toList();

    return Container(
      child: _loading == true
          ? displayLoadingScreen()
          : displaySurfaceAndVolumeInfos(SIZEWIDTH, categories),
    );
  }
}
