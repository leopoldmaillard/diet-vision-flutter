// ignore: import_of_legacy_library_into_null_safe
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:transfer_learning_fruit_veggies/pages/camera_screen.dart';
import 'package:transfer_learning_fruit_veggies/pages/page2.dart';
import 'package:transfer_learning_fruit_veggies/pages/page3.dart';
import 'package:transfer_learning_fruit_veggies/pages/page4.dart';

class Home extends StatefulWidget {
  final List<CameraDescription> cameras;
  Home({required this.cameras});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool showFab = true;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, initialIndex: 1, length: 4);
    _tabController.addListener(() {
      if (_tabController.index == 1) {
        showFab = true;
      } else {
        showFab = false;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Diet Vision"),
        elevation: 0.7,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: <Widget>[
            /* Icone  sur la barre de nav*/
            Tab(icon: Icon(Icons.camera_alt)),
            Tab(text: "Icone2"),
            Tab(
              text: "Icon3",
            ),
            Tab(
              text: "Icon4",
            ),
          ],
        ),
        // actions: <Widget>[
        //   /* Icone au bout à droite de la barre de nav*/
        //   Icon(Icons.search),
        //   Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 5.0),
        //   ),
        //   Icon(Icons.more_vert)
        // ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          /* Navigation au sein de l'appli*/
          CameraScreen(widget.cameras),
          //CameraScreen(),
          Page2(),
          Page3(),
          Page4(),
        ],
      ),
    );
  }
}
