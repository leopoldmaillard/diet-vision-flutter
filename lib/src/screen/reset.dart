import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'verify.dart';

import 'fhome.dart'; // new

// This file is the design/screen part of the reset password part in an app

class ResetScreen extends StatefulWidget {
  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  // initialize mail+pwd = avoid null error
  String _email = '';
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Reset Password'),
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
            // add button to sign in or sign up
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RaisedButton(
                    color: Theme.of(context).accentColor,
                    child: Text('Send Request'),
                    textColor: Colors.white,
                    onPressed: () {
                      auth.sendPasswordResetEmail(email: _email);
                      Navigator.of(context).pop();
                    }),
              ],
            ),
          ],
        ));
  }
}
