import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:developer';
//import 'dart:html';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../source/coinDiameter.dart';

class Geoloc extends StatefulWidget {
  @override
  GeolocState createState() {
    return new GeolocState();
  }
  /*@override
  _GeolocState createState() => _GeolocState();*/
}

class GeolocState extends State<Geoloc> {
  String latitude = '';
  String longitude = '';
  String positionUser = '';
  String addressUser = '';
  var locationMessage = '';
  late Address userAddress;
  String country = '';

  // obtain the address from coordinates
  /*Position _position = new Position(
      longitude: 0.0,
      latitude: 0.0,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0);
  StreamSubscription<Position> streamSubscription = new StreamSubscription() ;*/
  Address _address = Address();

  //Function for getting the current location
  // Before, we need the permission

  void getCurrentLocation() async {
    // TO DEBUG LOCAL STORAGE
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    final prefsMap = Map<String, dynamic>();
    for (String key in keys) {
      prefsMap[key] = prefs.get(key);
    }

    print(prefsMap);
    // TO DEBUG LOCAL STORAGE

    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    //get latitude and longitude
    var lat = position.latitude;
    var long = position.longitude;

    // north or south of france ?
    if (lat <= 52 && lat >= 47) {
      if (long < 10 && long >= 4)
        positionUser = 'Vous êtes dans le nord de la france';
    }
    if (lat < 47 && lat >= 42) {
      if (long <= 10 && long >= 1)
        positionUser = 'Vous êtes dans le sud de la france';
    }

    // create coordinates from lat and long
    final coordinates = new Coordinates(lat, long);
    convertCoordinatesToAddress(coordinates).then((value) {
      _address = value;
      country = value.countryName.toString();
    });
    //passing this to the lat/long variable (string)
    // country = _address.toString();
    var a = longitude = "$long";
    latitude = "$lat";
  }

// function to obtain an address from coordinates
  Future<Address> convertCoordinatesToAddress(Coordinates coordinates) async {
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    addressUser = addresses.first.toString();
    return addresses.first;
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
        positionUser = 'Vous êtes dans le nord de la france';
    }
    if (lati < 47 && lati >= 42) {
      if (longi <= 10 && longi >= 1)
        positionUser = 'Vous êtes dans le sud de la france';
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  Column displayLocation() {
    return Column(
      children: [
        Text(
          "Voici la latitude: $latitude et la longitude: $longitude",
          style: TextStyle(fontSize: 27),
        ),
        Text('Donc : $positionUser'),
        SizedBox(
          height: 20,
        ),
        Text("Ou alors: ${_address.addressLine ?? '-'}"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    getCurrentLocation();
    return new Center(
      child: Column(
        children: [
          Text('Vous voulez la position?'),
          TextButton(
              onPressed: () async {
                setState(() {
                  getCurrentLocation();
                });
              },
              child: Text("C'est partiii!")),
          Text(
            "Voici la latitude: $latitude et la longitude: $longitude",
            style: TextStyle(fontSize: 27),
          ),
          //Text("Ou alors: ${_address.addressLine ?? '-'}"),
          SizedBox(
            height: 20,
          ),
          Text(
            "vous êtes donc dans le pays: $country",
            style: TextStyle(
              fontSize: 20,
              fontStyle: FontStyle.italic,
              color: Colors.purple,
            ),
          ),
        ],
      ),
    );
  }
}
