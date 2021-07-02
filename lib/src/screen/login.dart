import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:transfer_learning_fruit_veggies/src/screen/reset.dart';
import 'package:transfer_learning_fruit_veggies/src/screen/signup.dart';
import 'package:transfer_learning_fruit_veggies/src/screen/verify.dart';
import 'package:transfer_learning_fruit_veggies/src/screen/fhome.dart';
import 'verify.dart';

import 'package:fluttertoast/fluttertoast.dart';

// This file is the design/screen part of the authentification part in an app

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // initialize mail+pwd = avoid null error
  String _email = '', _password = '';
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Log in'),
          backgroundColor: Colors.purple,
        ),
        body: Column(
          children: [
            // add a part to write the mail
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(hintText: 'Email'),
                  onChanged: (value) {
                    setState(() {
                      _email = value.trim();
                    });
                  }),
            ),

            // add a part to write the mail
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(hintText: 'Password'),
                onChanged: (value) {
                  setState(() {
                    _password = value.trim();
                  });
                },
              ),
            ),
            // add button to sign in or sign up
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RaisedButton(
                    color: Theme.of(context).accentColor,
                    child: Text('Signin'),
                    onPressed: () => _signin(_email, _password)),
                RaisedButton(
                    color: Theme.of(context).accentColor,
                    child: Text('Signup'),
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => SignUpScreen())))
                //_signup(_email, _password)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    child: Text('Forgot Password ?'),
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ResetScreen())))
              ],
            )
          ],
        ));
  }

  _signin(String _email, String _password) async {
    try {
      await auth.signInWithEmailAndPassword(email: _email, password: _password);

      //Success
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => FHomeScreen()));
    } on FirebaseAuthException catch (error) {
      // print(error.message);
      Fluttertoast.showToast(msg: error.message, gravity: ToastGravity.TOP);
    }
  }

  _signup(String _email, String _password) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: _email, password: _password);

      //Success
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => FHomeScreen()));
    } on FirebaseAuthException catch (error) {
      // print(error.message);
      Fluttertoast.showToast(msg: error.message, gravity: ToastGravity.TOP);
    }
  }
}
