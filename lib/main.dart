import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:transfer_learning_fruit_veggies/home.dart';
import 'package:transfer_learning_fruit_veggies/pages/onboarding_screen.dart';
import 'package:transfer_learning_fruit_veggies/bloc/food_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transfer_learning_fruit_veggies/pages/HistoryMeal.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<CameraDescription> cameras = [];
bool firstLaunch = true;

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  getFirstLaunch();
  print("FIRST LAUNCH ??" + firstLaunch.toString());
  runApp(new MyApp());
}

void getFirstLaunch() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  firstLaunch = prefs.getBool("firstLaunch") ?? true;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<FoodBloc>(
      create: (context) => FoodBloc(),
      child: MaterialApp(
        routes: {
          'mealHistory': (context) => HistoryMeal(),
        },
        title: "DietVision",
        theme: new ThemeData(
          primaryColor: new Color(0xff8C33FF),
        ),
        debugShowCheckedModeBanner: false,
        home: firstLaunch
            ? OnBoardingScreen(cameras: cameras)
            : Home(cameras: cameras),
      ),
    );
  }
}
