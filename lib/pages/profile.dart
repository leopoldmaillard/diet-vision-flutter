import 'package:flutter/material.dart';
import '../source/coinDiameter.dart';
import '../globals.dart' as globals;
import 'dart:math';

class Profile extends StatefulWidget {
  final String country;

  Profile(this.country);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String selectedCoin = "";
  String currency = "";
  List coins = [];
  double height = 170;
  double weight = 70;

  @override
  void initState() {
    super.initState();
    // return the coin type based on the country of the user
    // eg. "euro", "us_dollar" etc.
    currency = coinCountryJson.firstWhere(
        (element) => element["country"] == this.widget.country)["coin"];

    // return a list with the jsons entries of all the coins of this category
    // eg. "euro" have the 50 centimes, 1 euro, 2 euros etc coins.
    coins = coinDiameterJson
        .where((element) => element["coin"] == currency)
        .toList();

    //Set the default coin to the last available (usually the bigger one)
    setState(() {
      selectedCoin = coins.last["value"];
      globals.coinDiameter = coins.last["diameter_mm"] / 10; // Diameter cm
      globals.coinSurface = pi *
          (coins.last["diameter_mm"] / 2) *
          (coins.last["diameter_mm"] / 2);
    });
  }

  Widget textfield({@required String hintText = ""}) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Material(
              elevation: 2,
              shadowColor: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                  decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: TextStyle(
                        letterSpacing: 2,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                      fillColor: Colors.white30,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ))),
            ),
          ],
        ));
  }

  Widget availableCoinsList() {
    return DropdownButton<String>(
      underline: Container(
        height: 0,
        color: Theme.of(context).primaryColor,
      ),
      items: coins.map((e) {
        return DropdownMenuItem<String>(
          child: Text(e["value"]),
          value: e["value"],
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedCoin = newValue!;
          globals.coinDiameter = coins.firstWhere((element) =>
                  element["value"] == selectedCoin)["diameter_mm"] /
              10;
          globals.coinSurface =
              pi * (globals.coinDiameter * 5) * (globals.coinDiameter * 5);
        });
      },
      value: selectedCoin,
    );
  }

  Widget fancyText(String text) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          text,
          style: TextStyle(
            letterSpacing: 2,
            color: Colors.black54,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        SizedBox(
          height: 10.0,
        ),
        Container(
          padding: EdgeInsets.all(10.0),
          width: MediaQuery.of(context).size.width / 3,
          height: MediaQuery.of(context).size.width / 3,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 5),
            shape: BoxShape.circle,
            color: Theme.of(context).primaryColor.withOpacity(0.4),
            image: DecorationImage(
                fit: BoxFit.scaleDown,
                image: AssetImage('assets/images/iconeProfile.jpg')),
          ),
        ),
        textfield(hintText: "Full Name"),
        textfield(hintText: "Email"),
        textfield(hintText: "Password"),
        fancyText("How tall are you : " + height.toInt().toString() + " cm"),
        Slider(
          activeColor: Theme.of(context).primaryColor,
          value: height,
          min: 120,
          max: 230,
          onChanged: (double value) {
            setState(() {
              height = value;
            });
          },
        ),
        fancyText("What's your weight : " + weight.toInt().toString() + " kg"),
        Slider(
          activeColor: Theme.of(context).primaryColor,
          value: weight,
          min: 30,
          max: 150,
          onChanged: (double value) {
            setState(() {
              weight = value;
            });
          },
        ),
        fancyText("Your country : " + widget.country),
        Row(
          children: [
            fancyText("Chose your Fiducial Marker"),
            availableCoinsList(),
          ],
        ),
      ],
    ));
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Color(0xff555555);
    Path path = Path()
      ..relativeLineTo(0, 150)
      ..quadraticBezierTo(size.width / 2, 225, size.width, 150)
      ..relativeLineTo(0, -150)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
