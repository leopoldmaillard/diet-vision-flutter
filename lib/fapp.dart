import 'package:flutter/material.dart';
import 'package:transfer_learning_fruit_veggies/services/login.dart';

class FApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(
          accentColor: Colors.deepPurpleAccent, primarySwatch: Colors.grey),
      home: LoginScreen(),
    );
  }
}
