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

// signup finction to create an account
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

  //Fields to complete to add an account (e mail, name ...)
  Widget displayFields(int field) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
          keyboardType: field == 0
              ? TextInputType.emailAddress
              : field == 4
                  ? TextInputType.number
                  : TextInputType.multiline,
          obscureText: field == 1 ? true : false,
          decoration: (field == 0)
              ? InputDecoration(hintText: 'Email')
              : field == 1
                  ? InputDecoration(hintText: 'Password')
                  : field == 2
                      ? InputDecoration(hintText: 'First Name')
                      : field == 3
                          ? InputDecoration(hintText: 'Name')
                          : field == 4
                              ? InputDecoration(hintText: 'Age')
                              : InputDecoration(hintText: ''),
          onChanged: (value) {
            setState(() {
              if (field == 0)
                _email = value.trim();
              else if (field == 1)
                _password = value.trim();
              else if (field == 2)
                _FirstName = value.trim();
              else if (field == 3)
                _Name = value.trim();
              else if (field == 4) _age = int.parse(value.trim());
            });
          }),
    );
  }

  //display sign up button and create an account
  Widget displaySignUp() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        RaisedButton(
            color: Theme.of(context).accentColor,
            child: Text('Signup'),
            onPressed: () => _signup(_email, _password)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sign up'),
          backgroundColor: Colors.purple,
        ),
        body: Column(
          children: [
            displayFields(0),
            displayFields(1),
            displayFields(2),
            displayFields(3),
            displayFields(4),
            // add button to sign in or sign up
            displaySignUp(),
          ],
        ));
  }
}
