import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'dart:io';
import 'package:transfer_learning_fruit_veggies/pages/model_results.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:transfer_learning_fruit_veggies/model/drink.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool isSamsung = false;
  String selectedCoin = "";
/* ****************************************************************************/
/* *********************  FUNCTIONS SIGNATURES  *******************************/
/* ****************************************************************************/

// ==> Picture functionnalities
// 	dynamic pickGalleryImage() async ;
// 	Future<File> takePictureAndgetCroppedFile() async
// 	MaterialPageRoute sendFirstPicture(croppedFile)

// ==> WIDGET

// 	Widget instructionToTakePictureOfMeal()
// 	Widget choseFromGalleryButton()
// 	Widget getCameraScreenPreview(size)
// 	Widget getRoundPurlpleArea(size)
// 	Widget cameraAndPurpleArea(size)
// 	Widget getDisplayedCameraScreen(size)

  @override
  void initState() {
    super.initState();
    controller =
        new CameraController(widget.cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        getSelectedCoin();
      });
    });
  }

  @override
  void dispose() {
    print("Camera 1 is disposed");
    controller.dispose();
    super.dispose();
  }

  void getSelectedCoin() async {
    final prefs = await SharedPreferences.getInstance();
    selectedCoin = prefs.getString("selectedCoin")!;
  }

  /* **************************************************************************/
  /* ******************  PICTURE FUNCTIONNALITIES  ****************************/
  /* **************************************************************************/

  /// Enable the user to do the segmentation on a picture taken from gallery
  dynamic pickGalleryImage() async {
    var image = await picker.getImage(source: ImageSource.gallery);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DisplayPictureScreen(
          imagePath: image.path,
          isSamsung: false,
          controller: controller,
          volume: false,
          surfaces: new Map(),
          distances: new Map(),
        ),
      ),
    );
  }

  ///Take the picture and return the croppedFile depending
  /// if it is a samsung or not
  Future<File> takePictureAndgetCroppedFile() async {
    final image = await controller.takePicture();
    ImageProperties properties =
        await FlutterNativeImage.getImageProperties(image.path);
    int width = properties.width as int;
    int height = properties.height as int;
    int offset = (height - width).abs();
    File croppedFile;
    if (width > height) {
      croppedFile = await FlutterNativeImage.cropImage(
          image.path, (offset / 2).round(), 0, height, height);
      isSamsung = true;
    } else {
      croppedFile = await FlutterNativeImage.cropImage(
          image.path, 0, (offset / 2).round(), width, width);
    }
    return croppedFile;
  }

  MaterialPageRoute sendFirstPicture(croppedFile) {
    return MaterialPageRoute(
      builder: (context) => DisplayPictureScreen(
        imagePath: croppedFile.path,
        isSamsung: isSamsung,
        controller: controller,
        volume: false,
        surfaces: new Map(),
        distances: new Map(),
      ),
    );
  }

  /* **************************************************************************/
  /* ********************************  WIDGET  ********************************/
  /* **************************************************************************/

  Widget instructionToTakePictureOfMeal() {
    return Container(
      child: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: <TextSpan>[
            TextSpan(text: "🍽️ Center your meal & put a "),
            TextSpan(
                text: selectedCoin,
                style: TextStyle(color: Theme.of(context).primaryColor)),
            TextSpan(text: " coin in the area 🍽️")
          ],
        ),
      ),
      //textAlign: TextAlign.center,
    );
  }

  Widget choseFromGalleryButton() {
    return ElevatedButton.icon(
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
    );
  }

  Widget getCameraScreenPreview(size) {
    return Container(
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
              child: CameraPreview(controller),
            ),
          ),
        ),
      ),
    );
  }

  Widget getRoundPurlpleArea(size) {
    return Align(
      child: Container(
        width: size / 8,
        height: size / 8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).primaryColor.withOpacity(0.4),
        ),
      ),
    );
  }

  Widget cameraAndPurpleArea(size) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: <Widget>[
        getCameraScreenPreview(size),
        getRoundPurlpleArea(size),
      ],
    );
  }

  Widget getDisplayedCameraScreen(size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        cameraAndPurpleArea(size),
        SizedBox(height: 5),
        instructionToTakePictureOfMeal(),
        SizedBox(height: 40),
        choseFromGalleryButton(),
        DrinksButton(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return new Container();
    }
    var size = MediaQuery.of(context).size.width;

    return Scaffold(
      body: getDisplayedCameraScreen(size),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.circle_outlined),
        onPressed: () async {
          try {
            await controller; // Ensure that the camera is initialized.
            File croppedFile = await takePictureAndgetCroppedFile();
            await Navigator.of(context).push(
              sendFirstPicture(croppedFile),
            );
          } catch (e) {
            print(e);
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
