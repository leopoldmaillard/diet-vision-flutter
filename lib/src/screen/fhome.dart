import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:transfer_learning_fruit_veggies/src/screen/login.dart';

class FHomeScreen extends StatelessWidget {
  final auth = FirebaseAuth.instance;

//First page after the authetification
  Widget displayFirstPage(BuildContext context) {
    return Center(
      child: FlatButton(
          child: Text('Logout'),
          onPressed: () {
            auth.signOut();
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginScreen()));
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: displayFirstPage(context),
    );
  }
}
