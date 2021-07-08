import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'dart:io';
import 'package:image/image.dart' as IMG;
import 'dart:math';
import 'package:transfer_learning_fruit_veggies/pages/model_results.dart';
import 'package:image_picker/image_picker.dart';
import 'package:exif/exif.dart';

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

/* Json Format variable for the drop down List button of beverage */
List<Map> _myJson = [
  {
    "id": '1',
    "image": "assets/images/beverage.png",
    "name": "Select your drink"
  },
  {"id": '2', "image": "assets/images/coke.jpg", "name": "Coke"},
  {"id": '3', "image": "assets/images/IcedTea.png", "name": "IcedTea"},
  {"id": '4', "image": "assets/images/water.jpg", "name": "Water"},
  {"id": '5', "image": "assets/images/beer.png", "name": "Beer"},
  {"id": '6', "image": "assets/images/wine.png", "name": "Wine"},
  {"id": '7', "image": "assets/images/whiskey.png", "name": "Whiskey"},
  {"id": '8', "image": "assets/images/vodka.jpg", "name": "Vodka"},
];
String dropdownValue = "1";

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
          isSamsung: false,
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
    bool isSamsung = false;
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
                width: size / 7.5,
                height: size / 7.5,
                alignment: Alignment.topLeft,
                child: Container(
                  width: size / 8,
                  height: size / 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor.withOpacity(0.4),
                  ),
                ),
              ),
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
          // Drinks
          Expanded(child: MyStatefulWidget()),
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
            int height = properties.height as int;
            var offset = (height - width).abs();

            /******* Correction bug for mobile that force rotation of picture */
            // final originalFile = File(image.path);
            // List<int> imageBytes = await originalFile.readAsBytes();

            // final originalImage = IMG.decodeImage(imageBytes);
            // final Originalheight = originalImage!.height;
            // final Originalwidth = originalImage.width;

            // final exifData = await readExifFromBytes(imageBytes);

            // IMG.Image fixedImage = IMG.copyRotate(originalImage, 45);

            // if (height < width) {
            //   print("height : ");
            //   print(height);
            //   print("width : ");
            //   print(width);

            //   // rotate
            //   if (exifData['Image Orientation']!
            //       .printable
            //       .contains('Horizontal')) {
            //     print("000000000000000");
            //     fixedImage = IMG.copyRotate(originalImage, 90);
            //   } else if (exifData['Image Orientation']!
            //       .printable
            //       .contains('180')) {
            //     print("1111111111111111");
            //     fixedImage = IMG.copyRotate(originalImage, -90);
            //   } else if (exifData['Image Orientation']!
            //       .printable
            //       .contains('CCW')) {
            //     print("2222222222222");
            //     fixedImage = IMG.copyRotate(originalImage, 180);
            //   } else {
            //     print("3333333333333333");
            //     fixedImage = IMG.copyRotate(originalImage, 0);
            //   }
            // }
            // final fixedFile =
            //     await originalFile.writeAsBytes(IMG.encodeJpg(fixedImage));
            /********************************************************** */

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

/* Class for the Beverage Button, It's a child in the main page of camera */
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

/* This is the private State class that goes with MyStatefulWidget. */
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: _myJson.map((Map map) {
        return new DropdownMenuItem<String>(
          value: map["id"].toString(),
          // value: _mySelection,
          child: Row(
            children: <Widget>[
              Image.asset(
                map["image"],
                width: 25,
                height: 25,
              ),
              Container(
                  margin: EdgeInsets.only(left: 10), child: Text(map["name"])),
            ],
          ),
        );
      }).toList(),
    );
  }
}
