import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<Position> position = getLocation();

    return new Center(
      child: Text('Vous voulez la position?'),
      //position == null ? print('') : Text('position : $position'),
      // child: new RaisedButton(
      //   onPressed: () async {
      //     Position position = await Geolocator.getCurrentPosition(
      //         desiredAccuracy: LocationAccuracy.high);
      //     print('I write the position:');
      //     print(position);
      //   },
      // ),
    );
  }

  Future<Position> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print('I write the position:');
    print(position);
    return position;
  }

  /*void getValuePosition() async {
    final position = await getLocation();
  }*/

  /* Future<Position> _determinePosition() async {
    bool serviceEnabled = false;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }*/
}
