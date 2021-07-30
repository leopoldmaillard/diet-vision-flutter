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

/** try to do a authentification automaticaly */
  // Future<User> getUser() async {
  //   return await auth.currentUser;
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   getUser().then(
  //     (user) {
  //       if (user != null) {
  //         FHomeScreen();
  //       }
  //     },
  //   );
  // }

  //signin the first time in the app with email/password
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

// connexion to the app when you are already registered
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

  //display text field for add e mail or pwd
  Widget displayTextField(int texte) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
          keyboardType:
              texte == 0 ? TextInputType.emailAddress : TextInputType.multiline,
          obscureText: texte == 1 ? true : false,
          decoration: texte == 0
              ? InputDecoration(hintText: 'Email')
              : InputDecoration(hintText: 'Password'),
          onChanged: (value) {
            setState(() {
              if (texte == 0) {
                _email = value.trim();
              }
              if (texte == 1) {
                _password = value.trim();
              }
            });
          }),
    );
  }

  //display button signin/signup
  Widget buttonSign(int sign) {
    return RaisedButton(
        color: Theme.of(context).accentColor,
        child: sign == 0 ? Text('Signin') : Text('Signup'),
        onPressed: () {
          setState(() {
            if (sign == 0) {
              _signin(_email, _password);
            }
            if (sign == 1) {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SignUpScreen()));
            }
          });
        });
  }

//display forgot password button and send a email to change the pwd
  Widget displayForgotPassword() {
    return TextButton(
        child: Text('Forgot Password ?'),
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => ResetScreen())));
  }

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
            displayTextField(0),
            // wirte the password
            displayTextField(1),
            // add button to sign in or sign up
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buttonSign(0),
                buttonSign(1),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                displayForgotPassword(),
              ],
            )
          ],
        ));
  }
}
