import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui' show Color;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

  bool _loading = true;
  File _image;
  var _output;
  final picker = ImagePicker(); //allows us to pick image from gallery or camera

  @override
  void initState() {
    //initS is the first function that is executed by default when this class is called
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    //dis function disposes and clears our memory
    super.dispose();
    Tflite.close();
  }

  classifyImage(File image) async {
    //this function runs the model on the image
    var output = await Tflite.runSegmentationOnImage(
      path: image.path,
      imageMean: 0.0,
      imageStd: 255.0,
      labelColors: pascalVOCLabelColors,
    );
    setState(() {
      _output = output;
      _loading = false;
      print(_output.length);
    });
  }

  loadModel() async {
    //this function loads our model
    await Tflite.loadModel(
        model: 'assets/segmenter.tflite', labels: 'assets/labels.txt');
  }

  pickImage() async {
    //this function to grab the image from camera
    var image = await picker.getImage(source: ImageSource.camera);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image);
  }

  pickGalleryImage() async {
    //this function to grab the image from gallery
    var image = await picker.getImage(source: ImageSource.gallery);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'NYU Diet Vision App',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w200,
              fontSize: 20,
              letterSpacing: 0.8),
        ),
      ),
      body: Container(
        color: Colors.black.withOpacity(0.9),
        padding: EdgeInsets.symmetric(horizontal: 35, vertical: 50),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Color(0xFF2A363B),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Center(
                  child: _loading == true
                      ? null //show nothing if no picture selected
                      : Container(
                          child: Column(
                            children: [
                              Container(
                                  height: 250,
                                  width: 250,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      image: DecorationImage(
                                          image: MemoryImage(_output),
                                          fit: BoxFit.fill)),
                                  child: Opacity(
                                      opacity: 0.3,
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          child: Image.file(
                                            _image,
                                            fit: BoxFit.fill,
                                          )))),
                              Divider(
                                height: 25,
                                thickness: 1,
                              ),
                              _output != null
                                  ? Text(
                                      'Here is your segmentation mask !',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400),
                                    )
                                  : Container(),
                              Divider(
                                height: 25,
                                thickness: 1,
                              ),
                            ],
                          ),
                        ),
                ),
              ),
              Container(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        width: MediaQuery.of(context).size.width - 200,
                        alignment: Alignment.center,
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 17),
                        decoration: BoxDecoration(
                            color: Colors.blueGrey[600],
                            borderRadius: BorderRadius.circular(15)),
                        child: Text(
                          'Take A Photo',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: pickGalleryImage,
                      child: Container(
                        width: MediaQuery.of(context).size.width - 200,
                        alignment: Alignment.center,
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 17),
                        decoration: BoxDecoration(
                            color: Colors.blueGrey[600],
                            borderRadius: BorderRadius.circular(15)),
                        child: Text(
                          'Pick From Gallery',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
