import 'package:flutter/material.dart';

class Page5 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Text(
        "User's profile. He will be able to manage his account, set up his informations (height, age, weight, tastes etc.) as well as some preferences such as the fiducial marker or the metric used in the app.",
        style: new TextStyle(fontSize: 20.0),
      ),
    );
  }
}
