import 'package:firebase_core/firebase_core.dart'; // new
import 'package:firebase_auth/firebase_auth.dart'; // new
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:transfer_learning_fruit_veggies/fapp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/login.dart'; // new
import 'services/widgets.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  // await Firebase.initializeApp();
  runApp(FApp());
}
