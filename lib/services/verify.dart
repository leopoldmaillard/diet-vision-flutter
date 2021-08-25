import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:transfer_learning_fruit_veggies/fhome.dart';
import 'package:transfer_learning_fruit_veggies/mainOriginal.dart';

class VerifyScreen extends StatefulWidget {
  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final auth = FirebaseAuth.instance;

  Timer timer = Timer(Duration(seconds: 0), () {
    print('');
  });

  // waiting for the email to be verified
  @override
  void initState() {
    // FirebaseUser user = auth.currentUser;
    //print(user);
    getUserCurrent();

    super.initState();
  }

  Future<void> getUserCurrent() async {
    FirebaseUser user =
        await auth.currentUser(); //User user = auth.currentUser;
    user.sendEmailVerification();

    Future(() async {
      timer = Timer.periodic(Duration(seconds: 3), (timer) async {
        await FirebaseAuth.instance.currentUser()
          ..reload();
        var user = await FirebaseAuth.instance.currentUser();
        if (user.isEmailVerified) {
          Navigator.of(context).pushReplacement(
              // MaterialPageRoute(builder: (context) => FHomeScreen()));
              MaterialPageRoute(builder: (context) => MyApp()));

          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var user = auth.currentUser;
    return Scaffold(
      body: Center(
        child: Text("""An e-mail has been sent,
                 please verify"""),
      ),
    );
  }
}
