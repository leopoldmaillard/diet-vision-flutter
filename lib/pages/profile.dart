import 'package:flutter/material.dart';
import '../source/coinDiameter.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  Profile();

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String selectedCoin = "";
  String currency = "";
  List coins = [];
  double height = 170;
  double weight = 60;
  String country = "";
  String countryCode = "";
  String name = "Full Name";
  String mail = "Email";
  String pass = "Password";

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  void loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      print("${prefs.getString("countryCode")}");
      countryCode = prefs.getString("code") ?? "US";
      country = coinCountryJson
          .firstWhere((element) => element["code"] == countryCode)["country"];
      prefs.setString("country", country);
      // country = prefs.getString("country") ?? "FRANCE";
      print('This is my Country Code: $countryCode');
      print('this is my country: $country');
      // return the coin type based on the country of the user
      // eg. "euro", "us_dollar" etc.
      currency = coinCountryJson
          .firstWhere((element) => element["code"] == countryCode)["coin"];

      coins = coinDiameterJson
          .where((element) => element["coin"] == currency)
          .toList();

      selectedCoin = prefs.getString("selectedCoin") ?? coins.last["value"];

      //globals.coinDiameter = coins.last["diameter_mm"] / 10; // Diameter cm
      //globals.coinSurface = pi *
      //    (coins.last["diameter_mm"] / 2) *
      //    (coins.last["diameter_mm"] / 2);

      height = prefs.getDouble("height") ?? 170;
      weight = prefs.getDouble("weight") ?? 70;
      name = prefs.getString("name") ?? "Full Name";
      mail = prefs.getString("mail") ?? "Email";
    });
  }

  Widget textfield(
      {@required String hintText = "",
      required String field,
      required String fieldName}) {
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
                  onSubmitted: (value) async {
                    field = value;
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setString(fieldName, field);
                  },
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

  void selectNewCoin() async {}

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
      onChanged: (String? newValue) async {
        final prefs = await SharedPreferences.getInstance();
        setState(() {
          selectedCoin = newValue!;
          prefs.setString("selectedCoin", selectedCoin);
          double coinDiameter = coins.firstWhere((element) =>
                  element["value"] == selectedCoin)["diameter_mm"] /
              10;
          double coinSurface = pi * (coinDiameter * 5) * (coinDiameter * 5);
          prefs.setDouble("coinDiameterCm", coinDiameter);
          prefs.setDouble("coinSurfaceMm2", coinSurface);
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
        textfield(hintText: name, field: name, fieldName: "name"),
        textfield(hintText: mail, field: mail, fieldName: "mail"),
        textfield(hintText: "Password", field: pass, fieldName: "pass"),
        fancyText("How tall are you : " + height.toInt().toString() + " cm"),
        Slider(
          activeColor: Theme.of(context).primaryColor,
          value: height,
          min: 120,
          max: 230,
          onChanged: (double value) async {
            final prefs = await SharedPreferences.getInstance();
            setState(() {
              height = value;
              prefs.setDouble("height", height);
            });
          },
        ),
        fancyText("What's your weight : " + weight.toInt().toString() + " kg"),
        Slider(
          activeColor: Theme.of(context).primaryColor,
          value: weight,
          min: 30,
          max: 150,
          onChanged: (double value) async {
            final prefs = await SharedPreferences.getInstance();
            setState(() {
              weight = value;
              prefs.setDouble("weight", weight);
            });
          },
        ),
        fancyText("Your country : $country, $countryCode"),
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
