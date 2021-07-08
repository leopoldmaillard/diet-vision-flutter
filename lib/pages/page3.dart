import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Geoloc extends StatefulWidget {
  @override
  _GeolocState createState() => _GeolocState();
}

class _GeolocState extends State<Geoloc> {
  String latitude = '';
  String longitude = '';
  String position = '';
  var locationMessage = '';

  //Function for getting the current location
  // Before, we need the permission

  void getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    //get latitude and longitude
    var lat = position.latitude;
    var long = position.longitude;
    //passing this to the lat/long variable (string)
    longitude = "$long";
    latitude = "$lat";
  }

  // France sud/Nord
  void getFrancePosition() async {
    getCurrentLocation();
    int lati = int.parse(latitude.split(".")[0]);
    int longi = int.parse(longitude.split(".")[0]);
    print(lati);
    print(longi);
    if (lati <= 52 && lati >= 47) {
      if (longi < 10 && longi >= 4)
        position = 'Vous êtes dans le nord de la france';
    }
    if (lati < 47 && lati >= 42) {
      if (longi <= 10 && longi >= 1)
        position = 'Vous êtes dans le sud de la france';
    }
  }

  @override
  Widget build(BuildContext context) {
    // getCurrentLocation();
    getFrancePosition();
    return new Center(
      child: Column(
        children: [
          Text('Vous voulez la position?'),
          Text(
            "Voici la latitude: $latitude et la longitude: $longitude",
            style: TextStyle(fontSize: 27),
          ),
          Text('Donc : $position'),
        ],
      ),
    );
  }
}
