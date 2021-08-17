import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:transfer_learning_fruit_veggies/fhome.dart';
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
                  onPressed: () {
                    auth.signInWithEmailAndPassword(
                        email: _email, password: _password);
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => MyApp()));
                  }),
              RaisedButton(
                  color: Theme.of(context).accentColor,
                  child: Text('Signup'),
                  onPressed: () {
                    auth.createUserWithEmailAndPassword(
                        email: _email, password: _password);
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => MyApp()));
                  })
            ],
          ),
        ],
      ),
    );
  }
}
