// import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:transfer_learning_fruit_veggies/home.dart';

import 'package:transfer_learning_fruit_veggies/bloc/food_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transfer_learning_fruit_veggies/pages/HistoryMeal.dart';
import 'package:transfer_learning_fruit_veggies/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transfer_learning_fruit_veggies/pages/onboarding_screen.dart';

// List<CameraDescription> cameras = [];

// Future<Null> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   cameras = await availableCameras();
//   runApp(new MyApp());
// }
List<CameraDescription> cameras2 = cameras;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool loading = true;
  bool firstLaunch = true;

  void getFirstLaunch() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      firstLaunch = prefs.getBool("firstLaunch") ?? true;
      loading = false;
    });
  }

  @override
  void initState() {
    getFirstLaunch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Container()
        : BlocProvider<FoodBloc>(
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
                  ? OnBoardingScreen(cameras: cameras2)
                  : Home(cameras: cameras2),
            ),
          );
  }
}
