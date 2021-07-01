import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'dart:io';
import 'package:image/image.dart' as IMG;
import 'dart:math';
import 'package:transfer_learning_fruit_veggies/pages/model_results.dart';
import 'package:opencv/opencv.dart';

// class CameraScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return new Center(
//       child: new Text(
//         "Camera_Screen",
//         style: new TextStyle(fontSize: 20.0),
//       ),
//     );
//   }
// }

import 'package:camera/camera.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  CameraScreen(this.cameras);

  @override
  CameraScreenState createState() {
    return new CameraScreenState();
  }
}

class CameraScreenState extends State<CameraScreen> {
  late CameraController controller;
  Image imageNew = Image.asset('assets/temp.png');
  dynamic res;

  @override
  void initState() {
    super.initState();
    controller =
        new CameraController(widget.cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        //not in the tree
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return new Container();
    }

    var size = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
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
                        width: size / controller.value.aspectRatio,
                        height: size,
                        child: new CameraPreview(
                            controller), // this is my CameraPreview
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: size / 5,
                height: size / 5,
                color: Theme.of(context).primaryColor.withOpacity(0.4),
              )
            ],
          ),
          SizedBox(height: 5),
          Container(
            child: Text(
              "🍽️ Center your meal & put the fiducial marker in the area 🍽️",
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 40),
          ElevatedButton.icon(
            icon: Icon(Icons.image),
            label: Text('Chose from Gallery'),
            onPressed: () {
              print('Pressed');
            },
            style: ElevatedButton.styleFrom(
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(50.0),
              ),
              primary: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.circle_outlined),
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await controller;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await controller.takePicture();

            ImageProperties properties =
                await FlutterNativeImage.getImageProperties(image.path);

            int width = properties.width as int;
            int heigth = properties.height as int;
            var offset = (heigth - width).abs();

            File croppedFileCoin;
            File croppedFile;
            if (width > heigth) {
              // croppedFile = await FlutterNativeImage.cropImage(
              //     image.path, (offset / 2).round(), 0, heigth, heigth);
              croppedFileCoin = await FlutterNativeImage.cropImage(
                  image.path,
                  (heigth * (4 / 5)).toInt() - (offset / 3).round() + 3,
                  (width * (4 / 5)).toInt(),
                  heigth ~/ 5,
                  heigth ~/ 5);

              croppedFile = await FlutterNativeImage.cropImage(
                  image.path, (offset / 2).round(), 0, heigth, heigth);
            } else {
              /* FOR CLASSIC MOBILE PHONE IT'S HERE */
              // croppedFile = await FlutterNativeImage.cropImage(
              //     image.path, 0, (offset / 2).round(), width, width);
              croppedFileCoin = await FlutterNativeImage.cropImage(
                  image.path,
                  (width * (4 / 5)).toInt(),
                  (heigth * (4 / 5)).toInt() - (offset / 3).round() + 3,
                  width ~/ 5,
                  width ~/ 5);

              croppedFile = await FlutterNativeImage.cropImage(
                  image.path, 0, (offset / 2).round(), width, width);
            }
            File file2 = await dOHoughCircle(croppedFileCoin);
            print("hello");
            print(file2.path);
            print("hello");
            print("hello");
            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                // builder: (context) => DisplayPictureScreen(
                //   // Pass the automatically generated path to
                //   // the DisplayPictureScreen widget.
                //   //imagePath: croppedFileCoin.path,
                //   imagePath: file2.path,
                // ),
                builder: (context) => DisplayPictureScreenCoin(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  //imagePath: croppedFileCoin.path,
                  myImg: imageNew,
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

  Future<File> dOHoughCircle(File file) async {
    res = await ImgProc.cvtColor(await file.readAsBytes(), 6);
    res = await ImgProc.houghCircles(await res,
        method: 3,
        dp: 2.1,
        minDist: 0.1,
        param1: 150,
        param2: 100,
        minRadius: 0,
        maxRadius: 0);

    setState(() {
      imageNew = Image.memory(res);
    });
    return File.fromRawPath(res);
  }
}
