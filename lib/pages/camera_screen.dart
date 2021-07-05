import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'dart:io';
import 'package:image/image.dart' as IMG;
import 'dart:math';
import 'package:transfer_learning_fruit_veggies/pages/model_results.dart';
import 'package:image_picker/image_picker.dart';

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
  final picker = ImagePicker();

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

  pickGalleryImage() async {
    var image = await picker.getImage(source: ImageSource.gallery);
    if (image == null) return null;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DisplayPictureScreen(
          // Pass the automatically generated path to
          // the DisplayPictureScreen widget.
          imagePath: image.path,
        ),
      ),
    );
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
              pickGalleryImage();
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

            File croppedFile;

            if (width > heigth) {
              croppedFile = await FlutterNativeImage.cropImage(
                  image.path, (offset / 2).round(), 0, heigth, heigth);
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
