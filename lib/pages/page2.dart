import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class CameraView extends StatefulWidget {
  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  ArCoreController arCoreController = new ArCoreController();

  @override
  void dispose() {
    super.dispose();
    arCoreController.dispose();
  }

  /*onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    _addSphere(arCoreController);
  }*/

  _onArCoreViewCreated(ArCoreController _arCoreController) {
    arCoreController = _arCoreController;
    _addSphere(arCoreController);
    _addCube(arCoreController);
    _addCylinder(arCoreController);
  }

  _addSphere(ArCoreController controller) {
    final material = ArCoreMaterial(color: Colors.red, metallic: 1);
    final sphere = ArCoreSphere(materials: [material], radius: 0.2);
    final node = ArCoreNode(
      name: 'sphere',
      shape: sphere,
      position: vector.Vector3(0, -1, -1),
      rotation: vector.Vector4(0, 0, 0, 0),
    );
    controller.addArCoreNode(node);
    Transform.rotate(angle: 45);
  }

  _addCylinder(ArCoreController controller) {
    final material = ArCoreMaterial(color: Colors.deepPurple);
    final cylinder =
        ArCoreCylinder(materials: [material], radius: 0.01, height: 0.3);
    final node = ArCoreNode(
      name: 'cylinder',
      shape: cylinder,
      position: vector.Vector3(0, -0.5, -1),
      rotation: vector.Vector4(0, 0, 0, 0),
    );
    // controller.enableTapRecognizer;
    controller.addArCoreNode(node);
  }

  _addCube(ArCoreController controller) {
    final material = ArCoreMaterial(color: Colors.blue);
    final cube =
        ArCoreCube(materials: [material], size: vector.Vector3(1, 1, 1));
    final node = ArCoreNode(
      name: 'cube',
      shape: cube,
      position: vector.Vector3(
        -0.5,
        0.5,
        -4,
      ),
      rotation: vector.Vector4(
        0,
        0,
        0,
        0,
      ),
    );
    controller.addArCoreNode(node);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ArCoreView(
        onArCoreViewCreated: _onArCoreViewCreated,
        enableTapRecognizer: true,
        enableUpdateListener: true,
      ),
    );
  }
}


/*import 'dart:html';

import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart' show join;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transfer_learning_fruit_veggies/main.dart';

class CameraView extends StatefulWidget {
  final List<CameraDescription> cameras;

  CameraView(this.cameras);
  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  ArCoreFaceController arCoreFaceController = new ArCoreFaceController();

  int crownToShow = 0;

  ByteData textureBytes = new ByteData(2);

  late File imageFile;

  late CameraController controller;

  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    initController();

    setState(() {
      controller = CameraController(cameras[1], ResolutionPreset.ultraHigh);
      _initializeControllerFuture = controller.initialize();
    });
  }

  initController() async {
    textureBytes = await rootBundle.load('resources/images/black.png');

    arCoreFaceController.loadMesh(
      textureBytes: textureBytes.buffer.asUint8List(),
      skin3DModelFilename: "c.sfb",
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: FutureBuilder(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Stack(
                    children: <Widget>[
                      /*ArCoreFaceView(
                        onArCoreViewCreated: _onArCoreViewCreated,
                        enableAugmentedFaces: true,
                      ),
*/
                      CameraPreview(controller),
                      Positioned(
                        bottom: 0.0,
                        left: 10.0,
                        right: 10.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 50.0,
                              width: 50.0,
                              margin: EdgeInsets.symmetric(vertical: 5.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0)),
                              child: IconButton(
                                icon: Icon(
                                  Icons.camera,
                                  color: Colors.yellow,
                                  size: 40.0,
                                ),
                                onPressed: () async {
                                  try {
                                    await _initializeControllerFuture;

                                    final path = join(
                                      // Store the picture in the temp directory.
                                      // Find the temp directory using the `path_provider` plugin.
                                      (await getTemporaryDirectory()).path,
                                      '${DateTime.now()}.png',
                                    );
                                    // Attempt to take a picture and log where it's been saved.
                                    await controller.takePicture(path);

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DisplayPictureScreen(
                                                imagePath: path),
                                      ),
                                    );
                                  } catch (e) {
                                    // If an error occurs, log the error to the console.
                                    print(e);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              })),
    );
  }

  void _onArCoreViewCreated(ArCoreFaceController controller) {
    arCoreFaceController = controller;
    loadMesh();
  }

  loadMesh() async {
    final ByteData textureBytes =
        await rootBundle.load('resources/images/black.png');

    arCoreFaceController.loadMesh(
      textureBytes: textureBytes.buffer.asUint8List(),
      skin3DModelFilename: "tt.sfb",
    );
  }

  @override
  void dispose() {
    arCoreFaceController.dispose();
    super.dispose();
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({required Key key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: FileImage(
                  File(imagePath),
                ),
                fit: BoxFit.cover)),
      ),
    );
  }
}
*/