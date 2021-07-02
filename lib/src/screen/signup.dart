import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transfer_learning_fruit_veggies/src/screen/AddUser.dart';
import 'package:transfer_learning_fruit_veggies/src/screen/fhome.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // instance Firestore (to initiate FlutterFire)
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  int _age = 0;
  String _email = '', _password = '', _FirstName = '', _Name = '';
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sign up'),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(hintText: 'First Name'),
                  onChanged: (value) {
                    setState(() {
                      _FirstName = value.trim();
                    });
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(hintText: 'Name'),
                  onChanged: (value) {
                    setState(() {
                      _Name = value.trim();
                    });
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: 'Age'),
                onChanged: (value) {
                  setState(() {
                    _age = int.parse(value.trim());
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
                    child: Text('Signup'),
                    onPressed: () => _signup(_email, _password)),
              ],
            ),
          ],
        ));
  }

  _signup(String _email, String _password) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: _email, password: _password);

      //Success
      AddUser(_FirstName, _Name, _age);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => FHomeScreen()));
    } on FirebaseAuthException catch (error) {
      // print(error.message);
      Fluttertoast.showToast(msg: error.message, gravity: ToastGravity.TOP);
    }
  }
}
