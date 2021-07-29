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
import '../globals.dart' as globals;

// globals variables

const int OUTPUTSIZE = 513 * 513;
const double COINPIXELS = pi * (513 / 16) * (513 / 16); // 3230 pixels
double SURFACE2EUROS = globals.coinSurface; //pi * 12.875 * 12.875; // 521 mm2
const double COINDIAMETERPIXELS = 513 / 4;
double COINDIAMETERIRLCM = globals.coinDiameter;

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
      //AspectRatio(aspectRatio: 1, child: Image.file(File(imagePath))),
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
  var KEYS = classes.keys.toList();
  var VALUES = classes.values.toList();
  Map surfaceSaved = Map();

  bool _loading = true;
  var _outputPNG; // Mask
  var _outputRAW; // classic picture taken
  Map _output_classes = Map();

  List<List<List<int>>> _output_classes_Volume = [];
  List<List<List<int>>> _output_classes_Surface = [];
  Map _output_classes_height = Map();
  Map _output_classes_distance = Map();
  List<List<int>> minMax = [];
  int _selectedClass = 0;

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
    segmentImage(widget.imagePath);
  }

  @override
  void dispose() {
    print("TFlite is disposed");
    super.dispose();
    Tflite.close();
  }

  loadModel() async {
    await Tflite.loadModel(
        model: 'assets/segmenter.tflite', labels: 'assets/labels.txt');
  }

  segmentImage(String imagePath) async {
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

    Iterable<List<int>> pixels = partition(outputraw, 4);
    List<List<List<int>>> output_classes_Volume = [];
    List<List<List<int>>> output_classes_Surface = [];

    for (int k = 0; k < widget.surfaces.length; k++) {
      output_classes_Volume.add([]);
    }

    for (int k = 0; k < 26; k++) {
      output_classes_Surface.add([]);
    }

    Map output_classes = Map();
    int forEachCount = 0;
    String e;
    var i, c;
    pixels.forEach(
      (element) {
        //surface
        e = element.toString();
        i = KEYS.indexOf(e);
        c = VALUES[i];
        if (!output_classes.containsKey(c)) {
          output_classes[c] = 1;
        } else {
          output_classes[c] += 1;
        }
        if (!widget.volume) {
          output_classes_Surface[i].add(
              element + [(forEachCount / 513).round(), forEachCount % 513]);
        }

        if (widget.surfaces.containsKey(c)) {
          i = widget.surfaces.keys.toList().indexOf(c);

          //concatene list [jsaipaskwa, r,g,b] et [i,j]
          output_classes_Volume[i].add(
              element + [(forEachCount / 513).round(), forEachCount % 513]);
        }
        forEachCount++;
      },
    );

    Map output_classes_height = Map();
    Map output_classes_distance = Map();

    if (widget.volume) {
      output_classes_height =
          Compute_output_classes_height(output_classes_Volume);
    }
    if (!widget.volume) {
      output_classes_distance =
          Compute_output_classes_distance(output_classes_Surface);
    }

    setState(() {
      _outputPNG = output;
      _outputRAW = outputraw;
      _output_classes = output_classes;
      _output_classes_Surface = output_classes_Surface;
      _output_classes_Volume = output_classes_Volume;
      _output_classes_distance = output_classes_distance;
      _output_classes_height = output_classes_height;
      _loading = false;
    });
  }

  Map Compute_output_classes_height(
      List<List<List<int>>> output_classes_Volume) {
    Map output_classes_height = Map();
    List<int> elemHeight = [];
    String e;
    var i, c;
    for (int l = 0; l < widget.surfaces.length; l++) {
      if (output_classes_Volume[l].length != 0) {
        elemHeight = elemHeight + //du premier pixel de la classe d'indice l
            [output_classes_Volume[l][0][0]] + //transparence
            [output_classes_Volume[l][0][1]] + //r
            [output_classes_Volume[l][0][2]] + //g
            [output_classes_Volume[l][0][3]]; //b
        e = elemHeight.toString(); //[t,r,g,b] en string
        i = KEYS.indexOf(e);
        c = VALUES[i];

        output_classes_height[c] =
            getThicknessprecise(output_classes_Volume[l], c);
        elemHeight = [];
      }
    }
    return output_classes_height;
  }

//[indicede ouput_classes: distance en cm, ......]
  Map Compute_output_classes_distance(
      List<List<List<int>>> output_classes_Surface) {
    Map output_classes_distance = Map();
    List<int> elemDist = [];
    String e;
    var i, c;
    for (int l = 0; l < output_classes_Surface.length; l++) {
      if (output_classes_Surface[l].length != 0) {
        elemDist = elemDist + //du premier pixel de la classe d'indice l
            [output_classes_Surface[l][0][0]] + //transparence
            [output_classes_Surface[l][0][1]] + //r
            [output_classes_Surface[l][0][2]] + //g
            [output_classes_Surface[l][0][3]]; //b
        e = elemDist.toString(); //[t,r,g,b] en string
        i = KEYS.indexOf(e);
        c = VALUES[i];
        output_classes_distance[i] = getDistance(output_classes_Surface[l]);
        elemDist = [];
      }
    }
    return output_classes_distance;
  }

  // distance between the center of the coin and the food item (each class detected) in cm
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

  /// get an estimation of the thickness
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
    //we dont use xtop in the first coordonnate because we want to draw
    //a line between the point the hiwer and the lower of the food
    // and taking the x of the bottom of the thickness is quite better. (Ithink)
    minMax.add(
        [yTopThickness, xBottomThickness, yBottomThickness, xBottomThickness]);
    return (yBottomThickness - yTopThickness).round();
  }

//ywithperspective = le nb de pixels de lepaisseur de la deuxieme image (celle déformée)
//xDistCoinClass = distance en cm
  double getPixelConsideringPerspective(
      double yWithPerspective, double xDistCoinClass) {
    return yWithPerspective *
        (1 / (1.54 - 0.39 * log(0.94 * (xDistCoinClass) + 4.00)));
  }
  //thickdeformee = thickReel - 9.33*xdistance

/**************************Partie Widget *********************************** */
  Widget thick(int selectedClass) {
    var SIZEWIDTH = MediaQuery.of(context).size.width;
    final points = <Widget>[];

    points.add(
      Positioned(
        top: minMax[selectedClass][0].abs() / 513 * SIZEWIDTH - 5,
        left: minMax[selectedClass][1].abs() / 513 * SIZEWIDTH - 5,
        child: Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: Theme.of(context).primaryColor),
        ),
      ),
    );
    points.add(
      Positioned(
        top: minMax[selectedClass][2].abs() / 513 * SIZEWIDTH - 5,
        left: minMax[selectedClass][3].abs() / 513 * SIZEWIDTH - 5,
        child: Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: Theme.of(context).primaryColor),
        ),
      ),
    );
    points.add(
      Positioned(
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
      ),
    );
    return Stack(children: points);
  }

  // obtain a list of the volume and the thickness for each class segmented in the first/second picture
  Widget volumeList() {
    List<dynamic> widSurfKey = widget.surfaces.keys.toList();
    List<dynamic> widSurfVal = widget.surfaces.values.toList();
    final chips = <Widget>[];
    var categories = classes.values.toList();
    var mykeys = widget.distances.keys.toList();
    var dist = widget.distances.values.toList();

    double thickPixels, thickness, distCoinClass, thickPixelsReal;
    //idxClass: index in the output_classes of the current classe
    //idxClassDIst: index in the widget.distance of the current classe
    int idxClass, idxClassDist; //, index, color, item, surf, volume;

    /************************  INFO IMPORTANTE ****************************************
     * **  Si on cree ces variables en dehors de la boucle for:
     *  (sur la deuxieme photo) on peut changer une fois le curseur sur la classe backed cook
     *  et après on peut plus changer les classes pour ajuster la thickness*****/

    // obtain the volume for each class segmented in the first/second picture
    for (int i = 0; i < minMax.length; i++) {
      thickPixels = (minMax[i][2].abs() - minMax[i][0].abs()).toDouble();
      idxClass =
          categories.indexOf(widSurfKey[i]); // replace: classes.values.toList()
      idxClassDist =
          mykeys.indexOf(idxClass); // replace:widget.distances.keys.toList()
      distCoinClass = dist[idxClassDist]; // replace:widget.distances.values
      thickPixelsReal =
          getPixelConsideringPerspective(thickPixels, distCoinClass);
      thickness = (thickPixelsReal * COINDIAMETERIRLCM / COINDIAMETERPIXELS);

      int index = categories.indexOf(widSurfKey[i]);
      int color = pascalVOCLabelColors[index];

      int item = widSurfKey.indexOf(widSurfKey[i]);
      int surf = widSurfVal[item]; //replace: widget.surfaces.values.toList();
      int volume = (thickness * surf).round();

      chips.add(ActionChip(
        onPressed: () {
          setState(() {
            _selectedClass = item;
          });
        },
        backgroundColor: Color(color),
        shape: StadiumBorder(
          side: BorderSide(
            color: item == _selectedClass
                ? Theme.of(context).primaryColor
                : Color(color),
            width: 2.0,
          ),
        ),
        label: Text(
          widSurfKey[i] +
              '   ' +
              thickness.toStringAsFixed(1) +
              'cm | Vol. ' +
              volume.toString() +
              'cm³',
          style: const TextStyle(color: Colors.white),
        ),
      ));
    }
    return ListView(children: chips);
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
                    distances: _output_classes_distance,
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

  Widget displaySlider(bool volume) {
    return volume
        ? Column(
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).buttonColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                      "Feel free to adjust the average thickness of each food item"),
                ),
              ),
              RangeSlider(
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
                    setState(() {
                      minMax[_selectedClass][0] = value.end.toInt();
                      minMax[_selectedClass][2] = value.start.toInt();
                    });
                  })
            ],
          )
        : Container();
  }

  Widget displaySurfaceOrVolume(bool volume, List<String> categories) {
    return !volume
        ? ListView(
            children: _output_classes.entries.map(
              (e) {
                int percent = ((e.value / OUTPUTSIZE) * 100).round();
                if (percent >= 1) {
                  int surface =
                      (e.value * SURFACE2EUROS / COINPIXELS / 100).round();
                  int index = categories.indexOf(e.key);
                  int color = pascalVOCLabelColors[index];
                  surfaceSaved[e.key] = surface;
                  return ActionChip(
                      onPressed: () {},
                      avatar: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Text(percent.toString() + "%",
                            style:
                                TextStyle(color: Color(color), fontSize: 10)),
                      ),
                      backgroundColor: Color(color),
                      label: Text(
                        e.key + '   ' + surface.toString() + 'cm²',
                        style: const TextStyle(color: Colors.white),
                      ));
                } else {
                  return Container();
                }
              },
            ).toList(),
          )

        // If we display the volume
        : volumeList();
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
                child: thick(_selectedClass),
              )
            : Container(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var SIZEWIDTH = MediaQuery.of(context).size.width;

    var categories = classes.values.toList();

    return Container(
      child: _loading == true
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(
                      color: Theme.of(context).primaryColor),
                  SizedBox(height: 10),
                  Text('Cooking...'),
                ],
              ),
            )
          : Column(
              children: [
                displayPictureWithSegFilter(SIZEWIDTH),
                Expanded(
                  child: displaySurfaceOrVolume(widget.volume, categories),
                ),
                displaySlider(widget.volume),
                displayGetVolumeEstimationButton(widget.volume),
                SizedBox(height: 25),
              ],
            ),
    );
  }
}
