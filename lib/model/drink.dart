import 'package:flutter/material.dart';

/* Json Format variable for the drop down List button of beverage */
List<Map> myJson = [
  {
    "id": '1',
    "image": "assets/images/beverage.png",
    "name": "Select your drink  "
  },
  {"id": '2', "image": "assets/images/coke.png", "name": "Soda"},
  {"id": '3', "image": "assets/images/IcedTea.png", "name": "Iced Tea"},
  {"id": '4', "image": "assets/images/water.png", "name": "Water"},
  {"id": '5', "image": "assets/images/juice.png", "name": "Juice"},
  {"id": '6', "image": "assets/images/beer.png", "name": "Beer"},
  {"id": '7', "image": "assets/images/wine.png", "name": "Wine"},
  {"id": '8', "image": "assets/images/whiskey.png", "name": "Whiskey"},
  {"id": '9', "image": "assets/images/hard.png", "name": "Vodka"},
];
enum drinkEnum {
  EMPTY,
  NODRINK,
  SODA,
  ICEDTEAD,
  WATER,
  JUICE,
  BEER,
  WINE,
  WHISKEY,
  VODKA
}

//initial value for beverage button
String dropdownValue = "1";

/* Class for the Beverage Button, It's a child in the main page of camera */
class DrinksButton extends StatefulWidget {
  const DrinksButton({Key? key}) : super(key: key);

  @override
  State<DrinksButton> createState() => _DrinksButtonState();
}

/* This is the private State class that goes with MyStatefulWidget. */
class _DrinksButtonState extends State<DrinksButton> {
  DropdownMenuItem<String> displayImagesAndLabels(Map map) {
    return new DropdownMenuItem<String>(
      value: map["id"].toString(),
      // value: _mySelection,
      child: Row(
        children: <Widget>[
          Image.asset(
            map["image"],
            width: 25,
            height: 25,
          ),
          Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(map["name"] + " 25cl")),
        ],
      ),
    );
  }

  Widget drinkButton(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(
        Icons.arrow_downward,
        color: Theme.of(context).primaryColor,
      ),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Theme.of(context).primaryColor),
      underline: Container(
        height: 0,
        color: Theme.of(context).primaryColor,
      ),
      onChanged: (String? newValue) {
        setState(
          () {
            dropdownValue = newValue!;
          },
        );
      },
      items: myJson.map(
        (Map map) {
          return displayImagesAndLabels(map);
        },
      ).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return drinkButton(context);
  }
}
