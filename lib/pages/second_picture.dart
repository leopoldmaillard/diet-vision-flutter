import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'dart:io';
import 'package:image/image.dart' as IMG;
import 'dart:math';
import 'package:transfer_learning_fruit_veggies/pages/model_results.dart';

import 'package:camera/camera.dart';

class SecondPictureScreen extends StatefulWidget {
  final CameraController controller;
  final Map surfaces;
  final Map distances;
  //final TabController tabController;

  SecondPictureScreen({
    required this.controller,
    required this.surfaces,
    required this.distances,
    //required this.tabController,
  });

  @override
  _SecondPictureScreenState createState() => _SecondPictureScreenState();
}

class _SecondPictureScreenState extends State<SecondPictureScreen> {
  //late TabController tabController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    //controller.dispose();
    super.dispose();
  }

  Widget getDisplaySecondPisctureScreen(size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            Container(
              width: size,
              height: size,
              child: ClipRect(
                child: OverflowBox(
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Container(
                      width: size / widget.controller.value.aspectRatio,
                      height: size,
                      child: new CameraPreview(
                          widget.controller), // this is my CameraPreview
                    ),
                  ),
                ),
              ),
            ),
            Align(
              child: Container(
                width: size / 4,
                height: (size / 4) * sin(pi / 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.elliptical(
                      size / 4,
                      (size / 4) * sin(pi / 4),
                    ),
                  ),
                  color: Theme.of(context).primaryColor.withOpacity(0.4),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
        Container(
          child: Text(
            "??????? Center your meal & put the fiducial marker in the area ???????",
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 40),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.controller.value.isInitialized) {
      return new Container();
    }

    var size = MediaQuery.of(context).size.width;
    bool isSamsung = false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Picture'),
        brightness: Brightness.dark,
      ),
      body: getDisplaySecondPisctureScreen(size),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.circle_outlined),
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await widget.controller;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await widget.controller.takePicture();

            ImageProperties properties =
                await FlutterNativeImage.getImageProperties(image.path);

            int width = properties.width as int;
            int height = properties.height as int;
            var offset = (height - width).abs();

            File croppedFile;

            if (width > height) {
              croppedFile = await FlutterNativeImage.cropImage(
                  image.path, (offset / 2).round(), 0, height, height);
              isSamsung = true;
            } else {
              croppedFile = await FlutterNativeImage.cropImage(
                  image.path, 0, (offset / 2).round(), width, width);
            }

            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: croppedFile.path,
                  isSamsung: isSamsung,
                  controller: widget.controller,
                  volume: true,
                  surfaces: widget.surfaces,
                  distances: widget.distances,
                  //tabController: tabController,
                ),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
