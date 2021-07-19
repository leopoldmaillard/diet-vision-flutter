import 'dart:math';
import 'dart:typed_data';
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

/*** globals variables */

int OUTPUTSIZE = 513 * 513;
double COINPIXELS = pi * (513 / 16) * (513 / 16); // 3230 pixels
const double SURFACE2EUROS = pi * 12.875 * 12.875; // 521 mm2
double COINDIAMETERPIXELS = (513 / 16) * 2;
double COINDIAMETERIRLCM = 1.2875 * 2;

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final bool isSamsung;
  final List<CameraDescription> cameras;
  final bool volume;
  final Map surfaces;

  const DisplayPictureScreen({
    Key? key,
    required this.imagePath,
    required this.isSamsung,
    required this.cameras,
    required this.volume,
    required this.surfaces,
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
        cameras: this.cameras,
        volume: this.volume,
        surfaces: this.surfaces,
      ),
      //AspectRatio(aspectRatio: 1, child: Image.file(File(imagePath))),
    );
  }
}

class Segmentation extends StatefulWidget {
  final String imagePath;
  final bool isSamsung;
  final List<CameraDescription> cameras;
  final bool volume;
  final Map surfaces;
  Segmentation({
    required this.imagePath,
    required this.isSamsung,
    required this.cameras,
    required this.volume,
    required this.surfaces,
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
  Map output_classes = Map();

  List<List<List<int>>> output_classes_Volume = [];
  Map output_classes_height = Map();
  List<List<int>> minMax = [];
  int selectedClass = 0;

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
    super.dispose();
    Tflite.close();
  }

  loadModel() async {
    await Tflite.loadModel(
        model: 'assets/segmenter.tflite', labels: 'assets/labels.txt');
  }

  segmentImage(String imagePath) async {
    var output;
    var outputFixed;
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

      outputFixed = await Tflite.runSegmentationOnImage(
        path: fixedFile.path,
        imageMean: 0.0,
        imageStd: 255.0,
        labelColors: pascalVOCLabelColors,
        outputType: 'png',
      );
    } else {
      output = await Tflite.runSegmentationOnImage(
        // Segmentation for regular Mobile Phone
        path: imagePath,
        imageMean: 0.0,
        imageStd: 255.0,
        labelColors: pascalVOCLabelColors,
        outputType: 'png',
      );
    }
    setState(() {
      if (widget.isSamsung) {
        _outputPNG = outputFixed;
        _outputRAW = IMG.decodePng(outputFixed);
      } else {
        _outputPNG = output;
        _outputRAW = IMG.decodePng(output);
      }
      if (_outputRAW != null)
        _outputRAW = _outputRAW.getBytes(format: IMG.Format.rgba);

      /* separate each pixel in the format of 4 value rgb+jesaispluquoi */
      Iterable<List<int>> pixels = partition(_outputRAW, 4);
      for (int k = 0; k < widget.surfaces.length; k++) {
        output_classes_Volume.add([]);
      }

      int forEachCount = 0;
      pixels.forEach(
        (element) {
          //surface
          String e = element.toString();
          var i = KEYS.indexOf(e);
          var c = VALUES[i];
          if (!output_classes.containsKey(c)) {
            output_classes[c] = 1;
          } else {
            output_classes[c] += 1;
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
      if (widget.volume) {
        output_classes_height =
            Compute_output_classes_height(output_classes_Volume);
      }
      _loading = false;
    });
  }

  Map Compute_output_classes_height(
      List<List<List<int>>> output_classes_Volume) {
    Map output_classes_height = Map();
    List<int> elemHeight = [];
    for (int l = 0; l < widget.surfaces.length; l++) {
      if (output_classes_Volume[l].length != 0) {
        elemHeight = elemHeight + //du premier pixel de la classe d'indice l
            [output_classes_Volume[l][0][0]] + //transparence
            [output_classes_Volume[l][0][1]] + //r
            [output_classes_Volume[l][0][2]] + //g
            [output_classes_Volume[l][0][3]]; //b
        String e = elemHeight.toString(); //[t,r,g,b] en string
        var i = KEYS.indexOf(e);
        var c = VALUES[i];

        output_classes_height[c] =
            getAvgHeightOneClass(output_classes_Volume[l]);
        elemHeight = [];
      }
    }
    return output_classes_height;
  }

  int getAvgHeightOneClass(List<List<int>> typeOfClassPixels) {
    if (typeOfClassPixels.length == 0) {
      return 0;
    }

    List<int> listX = []; // correspond aux i cad lignes
    List<int> listY = []; // correspond aux j cad colonnes
    for (int k = 0; k < typeOfClassPixels.length; k++) {
      listX.add(typeOfClassPixels[k][4]); //[t,r,g,b,i,j] donc i
      listY.add(typeOfClassPixels[k][5]); //[t,r,g,b,i,j] donc j
    }
    int xmin = listX.reduce(math.min);
    int idxmin = listX.indexOf(xmin);
    int ymin = listY[idxmin];

    int xmax = listX.reduce(math.max);
    int idxmax = listX.indexOf(xmax);
    int ymax = ymin;

    minMax.add([xmin, ymin, xmax, ymax]);

    return (xmax - xmin).round();
  }

  /*
  Placing the thickness dots and dashline between them function.
  has to be called after getAvgHeightOneClass
  minmax = [xmin, ymin, xmax, ymax]
  */
  Widget thick(int selectedClass) {
    var SIZEWIDTH = MediaQuery.of(context).size.width;
    final points = <Widget>[];

    points.add(
      Positioned(
        top: minMax[selectedClass][0] / 513 * SIZEWIDTH - 5,
        left: minMax[selectedClass][1] / 513 * SIZEWIDTH - 5,
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
        top: minMax[selectedClass][2] / 513 * SIZEWIDTH - 5,
        left: minMax[selectedClass][3] / 513 * SIZEWIDTH - 5,
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
        top: minMax[selectedClass][0] / 513 * SIZEWIDTH + 5,
        left: minMax[selectedClass][1] / 513 * SIZEWIDTH,
        child: Dash(
          direction: Axis.vertical,
          length: (minMax[selectedClass][2] / 513 * SIZEWIDTH - 10) -
              (minMax[selectedClass][0] / 513 * SIZEWIDTH),
          dashColor: Theme.of(context).primaryColor,
          dashLength: 4,
          dashBorderRadius: 8,
          dashGap: 5,
        ),
      ),
    );
    return Stack(children: points);
  }

  Widget volumeList() {
    List<dynamic> widSurfKey = widget.surfaces.keys.toList();
    final chips = <Widget>[];
    var categories = classes.values.toList();

    for (int i = 0; i < widget.surfaces.length; i++) {
      int thickpixels = minMax[i][2] - minMax[i][0];
      int thickness =
          (thickpixels * COINDIAMETERIRLCM / COINDIAMETERPIXELS).round();

      int index = categories.indexOf(widSurfKey[i]);
      int color = pascalVOCLabelColors[index];

      int item = widSurfKey.indexOf(widSurfKey[i]);
      int surf = widget.surfaces.values.toList()[item];
      int volume = thickness * surf;

      chips.add(ActionChip(
        onPressed: () {
          setState(() {
            selectedClass = item;
          });
        },
        backgroundColor: Color(color),
        shape: StadiumBorder(
          side: BorderSide(
            color: item == selectedClass
                ? Theme.of(context).primaryColor
                : Color(color),
            width: 2.0,
          ),
        ),
        label: Text(
          widSurfKey[i] +
              '   ' +
              thickness.toString() +
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
                    cameras: widget.cameras,
                    surfaces: surfaceSaved,
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
        ? Slider(
            value: minMax[selectedClass][0].toDouble(),
            min: 0,
            max: 513,
            activeColor: Theme.of(context).primaryColor,
            onChanged: (double value) {
              setState(() {
                minMax[selectedClass][0] = value.toInt();
              });
            },
          )
        : Container();
  }

  Widget displaySurfaceOrVolume(bool volume, List<String> categories) {
    return !volume
        ? ListView(
            children: output_classes.entries.map(
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
                child: thick(selectedClass),
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
