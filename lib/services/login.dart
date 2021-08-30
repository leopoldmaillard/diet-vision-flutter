import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transfer_learning_fruit_veggies/fhome.dart';
import 'package:transfer_learning_fruit_veggies/mainOriginal.dart';
import 'resetPassword.dart';
import 'verify.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:transfer_learning_fruit_veggies/mainOriginal.dart';
import 'package:transfer_learning_fruit_veggies/main.dart';

// This file is the design/screen part of the authentification part in an app

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // initialize mail+pwd = avoid null error
  Widget homePage = new Container();
  String _email = '', _password = '';
  final auth = FirebaseAuth.instance;
  var currentUser = FirebaseAuth.instance.currentUser();
  bool loadingState = false;

  CollectionReference users = Firestore.instance.collection('usersDietVision');
  void initState() {
    super.initState();
    initLoad();
  }

  Future<void> initLoad() async {
    final prefs = await SharedPreferences.getInstance();
    if (await FirebaseAuth.instance.currentUser() != null &&
        prefs.getString("emailUser") != null) {
      setState(
        () {
          if (prefs.getString("emailUser") != null) {
            mailUser = prefs.getString("emailUser")!;
            loadingState = true;
            homePage = loadingScreenApp2();
          }
        },
      );
      // var idToken = currentUser.getIdToken();
      var currentUser = await FirebaseAuth.instance.currentUser();
      var idToken = await currentUser.getIdToken();
      var password = idToken.signInProvider;
      _signin(mailUser, password);
    } else {
      setState(
        () {
          print("test 1");
          homePage = loadingScreenApp2();
          print("test 2");
        },
      );
      Timer(
        Duration(seconds: 2),
        () async {
          setState(() {
            print("test 3");
            homePage = authentificationScreen();
            print("test 4");
          });
        },
      );
    }
  }

  ElevatedButton signInButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Color(0xff8C33FF),
      ),
      child: Text('Signin', style: TextStyle(color: Colors.white)),
      onPressed: () async {
        final prefs = await SharedPreferences.getInstance();
        setState(() {
          mailUser = _email;
          prefs.setString("emailUser", _email);
        });
        _signin(_email, _password);
      },
    );
  }

  ElevatedButton signUpButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Color(0xff8C33FF),
        ),
        child: Text('Signup', style: TextStyle(color: Colors.white)),
        onPressed: () async {
          // await users.doc(_email).set({"meal": []});
          mailUser = _email;
          final prefs = await SharedPreferences.getInstance();
          setState(() {
            if (mailUser != '') {
              prefs.setString("emailUser", _email);
            }
          });
          _signup(_email, _password);
        });
  }

  Widget forgetPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
            child: Text('Forgot Password ?'),
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => ResetScreen())))
      ],
    );
  }

  // Center loadingScreenApp() {
  //   return Center(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: <Widget>[
  //         CircularProgressIndicator(color: Theme.of(context).primaryColor),
  //         SizedBox(height: 10),
  //         Text('need a real loading page, please wait ...'),
  //       ],
  //     ),
  //   );
  // }

  Widget loadingScreenApp2() {
    return MaterialApp(
      title: "DietVision",
      theme: new ThemeData(
        primaryColor: new Color(0xff8C33FF),
      ),
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
        ),
        backgroundColor: new Color(0xff8C33FF),
        body: new Container(
          child: new Image.asset('assets/images/logoDietVision.png'),
          alignment: Alignment.center,
        ),
      ),
    );
  }

  Widget authentificationScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Log in',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff8C33FF),
        brightness: Brightness.dark,
      ),
      body: Column(
        children: [
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
              signInButton(),
              signUpButton(),
              forgetPassword(),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // return Container(
    //     child: loadingState == false
    //         ? authentificationScreen()
    //         : loadingScreenApp2());
    return homePage;
  }

  _signin(String _email, String _password) async {
    try {
      setState(() {
        loadingState = true;
        homePage = loadingScreenApp2();
      });
      await auth.signInWithEmailAndPassword(email: _email, password: _password);
      Timer(Duration(seconds: 2), () async {
        //Success
        final prefs = await SharedPreferences.getInstance();
        setState(() {
          if (prefs.getString("emailUser") != null)
            mailUser = prefs.getString("emailUser")!;
        });

        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => MyApp()));
      });
    } on PlatformException catch (error) {
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
      Fluttertoast.showToast(msg: error.message!, gravity: ToastGravity.TOP);
    }
  }
}
