import 'package:flutter/material.dart';
import '../source/coinDiameter.dart';

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
    });
  }

  Widget textfield({@required String hintText = ""}) {
    return Material(
      elevation: 4,
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
    );
  }

  Widget availableCoinsList() {
    return DropdownButton<String>(
      items: coins.map((e) {
        return DropdownMenuItem<String>(
          child: Text(e["value"]),
          value: e["value"],
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedCoin = newValue!;
        });
      },
      value: selectedCoin,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            Container(
              height: 450,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  textfield(
                    hintText: 'Username ' + this.widget.country,
                  ),
                  textfield(
                    hintText: 'Email',
                  ),
                  textfield(
                    hintText: 'Password',
                  ),
                  availableCoinsList(),
                  Container(
                    height: 55,
                    width: double.infinity,
                    child: RaisedButton(
                      onPressed: () {},
                      color: Colors.black54,
                      child: Center(
                        child: Text(
                          "Update",
                          style: TextStyle(
                            fontSize: 23,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ]),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Profile",
                  style: TextStyle(
                    fontSize: 35,
                    letterSpacing: 1.5,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              /* Round with the profile picture inside */
              Container(
                padding: EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 5),
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor.withOpacity(0.4),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/iconeProfile.jpg')),
                ),
              ),
            ],
          ),
          /* Here is the button to edit the profile picture */
          Padding(
            padding: EdgeInsets.only(bottom: 270, left: 184),
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
            ),
          )
        ],
      ),
    );
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
