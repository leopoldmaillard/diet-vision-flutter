import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quiver/collection.dart';
import 'dart:io';
import 'package:tflite/tflite.dart';
import 'package:image/image.dart' as IMG;
import 'package:quiver/iterables.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Meal')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Segmentation(imagePath: this.imagePath),
      //AspectRatio(aspectRatio: 1, child: Image.file(File(imagePath))),
    );
  }
}

class Segmentation extends StatefulWidget {
  final String imagePath;
  Segmentation({required this.imagePath});

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
    '[0, 128, 0, 255]': 'stem_vegetables 🥦',
    '[128, 128, 0, 255]': 'non-starchy_roots 🍅',
    '[0, 0, 128, 255]': 'vegetables | other 🌽',
    '[128, 0, 128, 255]': 'fruits 🍓',
    '[0, 128, 128, 255]': 'protein | meat 🥩',
    '[128, 128, 128, 255]': 'protein | poultry 🍗',
    '[64, 0, 0, 255]': 'protein | seafood 🐟',
    '[192, 0, 0, 255]': 'protein | eggs 🍳',
    '[64, 128, 0, 255]': 'protein | beans/nuts 🥜',
    '[192, 128, 0, 255]': 'starches/grains | baked_goods 🥐',
    '[64, 0, 128, 255]': 'starches/grains | rice/grains/cereals 🍚',
    '[192, 0, 128, 255]': 'starches/grains | noodles/pasta 🍝',
    '[255, 64, 64, 255]': 'starches/grains | starchy_vegetables 🥔',
    '[192, 128, 128, 255]': 'starches/grains | other 🌾',
    '[0, 64, 0, 255]': 'soups/stews 🥣',
    '[128, 64, 0, 255]': 'herbs/spices 🌿',
    '[0, 192, 0, 255]': 'dairy 🥛',
    '[128, 192, 0, 255]': 'snacks 🍫',
    '[0, 64, 128, 255]': 'sweets/desserts 🍰',
    '[128, 64, 64, 255]': 'beverages 🥤',
    '[64, 64, 128, 255]': 'fats/oils/sauces 🥫',
    '[64, 64, 64, 255]': 'food_containers 🍽️',
    '[192, 192, 192, 255]': 'dining_tools 🍴',
    '[192, 64, 64, 255]': 'other_food ❓'
  };

  bool _loading = true;
  var _outputPNG;
  var _outputRAW;
  Map output_classes = Map();

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
    var output = await Tflite.runSegmentationOnImage(
      path: imagePath,
      imageMean: 0.0,
      imageStd: 255.0,
      labelColors: pascalVOCLabelColors,
      outputType: 'png',
    );
    //var outimg = await decodeImageFromList(Uint8List.fromList(output));
    setState(() {
      _outputPNG = output;
      _outputRAW = IMG.decodePng(output);
      if (_outputRAW != null)
        _outputRAW = _outputRAW.getBytes(format: IMG.Format.rgba);

      Iterable<List<int>> pixels = partition(_outputRAW, 4);
      var keys = classes.keys.toList();
      var values = classes.values.toList();

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
      print(output_classes);
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;

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
                Container(
                  height: size,
                  width: size,
                  child: Stack(
                    children: [
                      Image.memory(_outputPNG),
                      Opacity(
                          opacity: 0.3,
                          child: Image.file(File(widget.imagePath))),
                    ],
                  ),
                ),
                Expanded(
                    child: ListView(
                        children: output_classes.entries.map((e) {
                  return Container(
                      child: Text(e.key + " : " + e.value.toString()));
                }).toList())),
              ],
            ),
    );
  }
}
