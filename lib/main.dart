import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:transfer_learning_fruit_veggies/home.dart';

List<CameraDescription> cameras = [];

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "DietVision",
      theme: new ThemeData(
        primaryColor: new Color(0xff590fD0),
      ),
      debugShowCheckedModeBanner: false,
      //home: new Home(),
      home: new Home(cameras: cameras),
    );
  }
}
