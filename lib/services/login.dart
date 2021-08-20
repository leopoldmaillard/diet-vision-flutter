import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:transfer_learning_fruit_veggies/fhome.dart';
import 'package:transfer_learning_fruit_veggies/mainOriginal.dart';
import 'resetPassword.dart';
import 'verify.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:transfer_learning_fruit_veggies/mainOriginal.dart';

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
          backgroundColor: Color(0xff8C33FF),
          brightness: Brightness.dark,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RaisedButton(
                    color: Color(0xff8C33FF),
                    child: Text('Signin'),
                    onPressed: () => _signin(_email, _password)),
                RaisedButton(
                    color: Color(0xff8C33FF),
                    child: Text('Signup'),
                    onPressed: () => _signup(_email, _password)),
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
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => MyApp()));
    } on PlatformException catch (error) {
      // print(error.message);
      Fluttertoast.showToast(msg: error.message!, gravity: ToastGravity.TOP);
    }
  }

  _signup(String _email, String _password) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: _email, password: _password);

      //Success
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => MyApp()));
    } on PlatformException catch (error) {
      // print(error.message);
      Fluttertoast.showToast(msg: error.message!, gravity: ToastGravity.TOP);
    }
  }
}
