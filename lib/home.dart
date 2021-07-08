// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_point_tab_bar/pointTabIndicator.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:transfer_learning_fruit_veggies/pages/camera_screen.dart';
import 'package:transfer_learning_fruit_veggies/pages/page2.dart';
import 'package:transfer_learning_fruit_veggies/pages/page3.dart';
import 'package:transfer_learning_fruit_veggies/pages/statistics.dart';
import 'package:transfer_learning_fruit_veggies/pages/page5.dart';

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

    _tabController = TabController(vsync: this, initialIndex: 1, length: 5);
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
        brightness: Brightness.dark,
      ),
      bottomNavigationBar: BottomAppBar(
        child: TabBar(
          controller: _tabController,
          indicator: PointTabIndicator(
            position: PointTabIndicatorPosition.bottom,
            color: Colors.white,
            insets: EdgeInsets.only(bottom: 6),
          ),
          tabs: <Widget>[
            /* Icone  sur la barre de nav*/
            Tab(icon: Icon(Icons.menu_book)),
            Tab(icon: Icon(Icons.restaurant)),
            Tab(icon: Icon(Icons.camera_alt)),
            Tab(icon: Icon(Icons.query_stats)),
            Tab(icon: Icon(Icons.account_circle)),
          ],
        ),
        color: Theme.of(context).primaryColor,
        elevation: 0.0,
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          /* Navigation au sein de l'appli*/
          //CameraScreen(),
          Page2(),
          Page3(),
          CameraScreen(widget.cameras),
          Statistics(),
          Page5(),
        ],
      ),
    );
  }
}
