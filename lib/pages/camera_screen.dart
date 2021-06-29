import 'package:flutter/material.dart';
import 'dart:io';
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
      body: Stack(
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

            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: image.path,
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

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: AspectRatio(aspectRatio: 1, child: Image.file(File(imagePath))),
    );
  }
}
