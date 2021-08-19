import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:transfer_learning_fruit_veggies/home.dart';
import 'package:camera/camera.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingScreen extends StatelessWidget {
  final List<CameraDescription> cameras;
  OnBoardingScreen({required this.cameras});

  @override
  Widget build(BuildContext context) => IntroductionScreen(
        color: Theme.of(context).primaryColor,
        pages: [
          PageViewModel(
            title: 'Welcome to DietVision',
            image: buildImage('assets/images/dietvision.png'),
            bodyWidget: Column(
              children: [
                Text(
                  "DietVision uses AI to estimate nutritional values of your meal from images.",
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            decoration: getPageDecoration(true, context),
          ),
          PageViewModel(
            title: 'Take a first picture',
            body:
                'Place a coin between the plate and you and snap a top-view picture of your meal. Try to match the coin with the circle area drawn on the screen.',
            image: buildImage('assets/images/topView.png'),
            decoration: getPageDecoration(true, context),
          ),
          PageViewModel(
            title: 'Take a second picture',
            body:
                'Move your phone & match again the new area with your coin. This will reveal a 45° view of your dish. This second picture is required to estimate the volume of food in your plate.',
            image: buildImage('assets/images/45view.png'),
            decoration: getPageDecoration(true, context),
          ),
          PageViewModel(
            title: 'Feel free to adjust the results',
            body:
                'Estimated results are now displayed, but you can visually adjust the mean thickness of each food by tapping on an item and moving its slider. You can also modify or delete a misclassified food.',
            image: buildImage('assets/images/feedback.jpg'),
            decoration: getPageDecoration(true, context),
          ),
          PageViewModel(
            title: "You are all set to go",
            body:
                'Start tracking your food habits. You will find other cool features while navigating the app.',
            footer: ElevatedButton.icon(
              onPressed: () => goToHome(context),
              icon: Icon(Icons.fastfood),
              label: Text('Got it !'),
              style: ElevatedButton.styleFrom(
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(50.0),
                ),
                primary: Theme.of(context).primaryColor,
              ),
            ),
            decoration: getPageDecoration(false, context),
          ),
        ],
        done: Text('Next', style: TextStyle(fontWeight: FontWeight.w600)),
        onDone: () => goToHome(context),
        showSkipButton: true,
        skip: Text('Skip'),
        onSkip: () => goToHome(context),
        next: Icon(Icons.arrow_forward),
        dotsDecorator: getDotDecoration(context),
        onChange: (index) => print('Page $index selected'),
      );

  void goToHome(context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("firstLaunch", false);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => Home(cameras: cameras)),
    );
  }

  DotsDecorator getDotDecoration(BuildContext context) => DotsDecorator(
        color: Color(0xFFBDBDBD),
        activeColor: Theme.of(context).primaryColor,
        //activeColor: Colors.orange,
        size: Size(10, 10),
        activeSize: Size(22, 10),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      );
  Widget buildImage(String path) => Center(child: Image.asset(path));

  PageDecoration getPageDecoration(bool image, BuildContext context) =>
      PageDecoration(
        bodyAlignment: image ? Alignment.topCenter : Alignment.center,
        titleTextStyle: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor),
        bodyTextStyle: TextStyle(fontSize: 20),
        descriptionPadding: EdgeInsets.all(16).copyWith(bottom: 0),
        imagePadding: EdgeInsets.all(24),
        pageColor: Colors.white,
      );
}
