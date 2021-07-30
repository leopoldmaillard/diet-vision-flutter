import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:transfer_learning_fruit_veggies/src/screen/fhome.dart';

class VerifyScreen extends StatefulWidget {
  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final auth = FirebaseAuth.instance;
  //User user = auth.currentUser;

  Timer timer = Timer(Duration(seconds: 0), () {
    print('');
  });

  // waiting for the email to be verified
  @override
  void initState() {
    User user = auth.currentUser;
    //print(user);
    user.sendEmailVerification();

    //create a timer to verify each 5 seconds if the mail is verrified by the user
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      checkEmailVerified(user);
    });
    super.initState();
  }

  // in the case where the email is verified, the timer is delated and the user can go on the homepage
  Future<void> checkEmailVerified(User u) async {
    u = auth.currentUser;
    await u.reload();
    if (u.emailVerified) {
      timer.cancel();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => FHomeScreen()));
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User user = auth.currentUser;
    return Scaffold(
      body: Center(
        child: Text("""An e-mail has been sent to ${user.email}
                 please verify"""),
      ),
    );
  }
}
