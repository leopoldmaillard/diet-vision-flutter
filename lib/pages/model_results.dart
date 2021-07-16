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

  bool _loading = true;
  var _outputPNG;
  var _outputRAW;
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
      final height = originalImage!.height;
      final width = originalImage.width;

      IMG.Image fixedImage = IMG.copyRotate(originalImage, 90);
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
        path: imagePath,
        imageMean: 0.0,
        imageStd: 255.0,
        labelColors: pascalVOCLabelColors,
        outputType: 'png',
      );
    }

    //var outimg = await decodeImageFromList(Uint8List.fromList(output));
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

      Iterable<List<int>> pixels = partition(_outputRAW, 4);
      var keys = classes.keys.toList();
      var values = classes.values.toList();

      if (!widget.volume) {
        pixels.forEach((element) {
          String e = element.toString();
          var i = keys.indexOf(e);
          var c = values[i];
          if (!output_classes.containsKey(c)) {
            output_classes[c] = 1;
          } else {
            output_classes[c] += 1;
          }
        });

        // WE COMPUTE THE THICKNESS HERE
      } else {
        for (int k = 0; k < widget.surfaces.length; k++) {
          output_classes_Volume.add([]);
        }
        int forEachCount = 0;
        pixels.forEach(
          (element) {
            //surface
            String e = element.toString();
            var i = keys.indexOf(e);
            var c = values[i];
            if (widget.surfaces.containsKey(c)) {
              i = widget.surfaces.keys.toList().indexOf(c);
              if (!output_classes.containsKey(c)) {
                output_classes[c] = 1;
              } else {
                output_classes[c] += 1;
              }

              //concatene list [jsaipaskwa, r,g,b] et [i,j]
              output_classes_Volume[i].add(
                  element + [(forEachCount / 513).round(), forEachCount % 513]);
              forEachCount++;
            }
          },
        );
        List<int> elemHeight = [];
        for (int l = 0; l < widget.surfaces.length; l++) {
          if (output_classes_Volume[l].length != 0) {
            elemHeight = elemHeight + //du premier pixel de la classe d'indice l
                [output_classes_Volume[l][0][0]] + //transparence
                [output_classes_Volume[l][0][1]] + //r
                [output_classes_Volume[l][0][2]] + //g
                [output_classes_Volume[l][0][3]]; //b
            String e = elemHeight.toString(); //[t,r,g,b] en string
            var i = keys.indexOf(e);
            var c = values[i];

            output_classes_height[c] =
                getAvgHeightOneClass(output_classes_Volume[l]);
            elemHeight = [];
          }
        }
      }
      _loading = false;
    });
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

    //listX.sort();
    //listY.sort();
    //int firstEtimationX = (listX.last - listX.first).round();
    //int firstEtimationY = (listY.last - listY.first).round();

    minMax.add([xmin, ymin, xmax, ymax]);

    return (xmax - xmin).round();
  }

  // This widget return a stack of all the min and max  point of each class
  Widget thickness() {
    var size = MediaQuery.of(context).size.width;
    final points = <Widget>[];
    minMax.forEach((element) {
      // random color to distinguish classes
      Color col = Colors.primaries[Random().nextInt(Colors.primaries.length)];
      points.add(
        Positioned(
          top: element[0] / 513 * size - 5,
          left: element[1] / 513 * size - 5,
          child: Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(shape: BoxShape.circle, color: col),
          ),
        ),
      );
      points.add(
        Positioned(
          top: element[2] / 513 * size - 5,
          left: element[3] / 513 * size - 5,
          child: Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(shape: BoxShape.circle, color: col),
          ),
        ),
      );
    });
    return Stack(children: points);
  }

  Widget thick(int selectedClass) {
    var size = MediaQuery.of(context).size.width;
    final points = <Widget>[];

    points.add(
      Positioned(
        top: minMax[selectedClass][0] / 513 * size - 5,
        left: minMax[selectedClass][1] / 513 * size - 5,
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
        top: minMax[selectedClass][2] / 513 * size - 5,
        left: minMax[selectedClass][3] / 513 * size - 5,
        child: Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: Theme.of(context).primaryColor),
        ),
      ),
    );
    return Stack(children: points);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    int outputSize = 513 * 513;
    double coinPixels = pi * (513 / 16) * (513 / 16); // 3230 pixels
    const double surface2euros = pi * 12.875 * 12.875; // 521 mm2
    double coinDiameterPixels = (513 / 16) * 2;
    double coinDiameterIRLCM = 1.2875 * 2;

    var categories = classes.values.toList();
    Map surfaceSaved = Map();

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
                Stack(
                  children: [
                    Container(
                      height: size,
                      width: size,
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
                            height: size,
                            width: size,
                            child: thick(selectedClass),
                          )
                        : Container(),
                  ],
                ),
                Expanded(
                  child: !widget.volume
                      ? ListView(
                          children: output_classes.entries.map((e) {
                          int percent = ((e.value / outputSize) * 100).round();
                          if (percent >= 1) {
                            int surface =
                                (e.value * surface2euros / coinPixels / 100)
                                    .round();
                            int index = categories.indexOf(e.key);
                            int color = pascalVOCLabelColors[index];
                            surfaceSaved[e.key] = surface;
                            return ActionChip(
                                onPressed: () {},
                                avatar: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Text(percent.toString() + "%",
                                      style: TextStyle(
                                          color: Color(color), fontSize: 10)),
                                ),
                                backgroundColor: Color(color),
                                label: Text(
                                  e.key + '   ' + surface.toString() + 'cm²',
                                  style: const TextStyle(color: Colors.white),
                                ));
                          } else {
                            return Container();
                          }
                        }).toList())

                      // If we display the volume
                      : ListView(
                          children: output_classes_height.entries.map(
                            (e) {
                              int thickness = (e.value *
                                      coinDiameterIRLCM /
                                      coinDiameterPixels)
                                  .round();
                              int index = categories.indexOf(e.key);
                              int color = pascalVOCLabelColors[index];

                              int item =
                                  widget.surfaces.keys.toList().indexOf(e.key);
                              int surf = widget.surfaces.values.toList()[item];
                              int volume = thickness * surf;

                              return ActionChip(
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
                                  e.key +
                                      '   ' +
                                      thickness.toString() +
                                      'cm | Vol. ' +
                                      volume.toString() +
                                      'cm³',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                ),
                widget.volume
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
                    : Container(),
                !widget.volume
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
                    : Container(),
                SizedBox(height: 25),
              ],
            ),
    );
  }
}
