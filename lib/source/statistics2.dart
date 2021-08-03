import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'indicator.dart';

class Statistics2 extends StatefulWidget {
  @override
  _StatisticsState2 createState() => _StatisticsState2();
}

class _StatisticsState2 extends State<Statistics2> {
  int touchedIndex = -1;
  int numberCategorie = 5;
/* ___________________Widget part _______________________*/

//create Piechart
  PieChart createPieChart() {
    return PieChart(
      PieChartData(
          pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
            setState(() {
              final desiredTouch =
                  pieTouchResponse.touchInput is! PointerExitEvent &&
                      pieTouchResponse.touchInput is! PointerUpEvent;
              if (desiredTouch && pieTouchResponse.touchedSection != null) {
                touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
              } else {
                touchedIndex = -1;
              }
            });
          }),
          borderData: FlBorderData(
            show: false,
          ),
          sectionsSpace: 0,
          centerSpaceRadius: 40,
          sections: showingSections()),
    );
  }

//display a Card to insert a graphe
  Card displayCard() {
    return Card(
      color: Colors.white,
      child: Row(
        children: <Widget>[
          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: createPieChart(),
            ),
          ),
          displayPieCHartColor(),
          const SizedBox(
            width: 28,
          ),
        ],
      ),
    );
  }

// widget to display the pie chart categories
  Widget displayPieCHartColor() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        displayEachCategories(Color(0xff0293ee), 'First', true, 4),
        displayEachCategories(Color(0xfff8b250), 'Second', true, 4),
        displayEachCategories(Color(0xff845bef), 'Third', true, 4),
        displayEachCategories(Color(0xff13d38e), 'Fourth', true, 18),
      ],
    );
  }

  //WIdget for each categories colors
  Widget displayEachCategories(
      Color color, String title, bool isSquare, double heightBox) {
    return Column(
      children: <Widget>[
        Indicator(
          color: color,
          text: title,
          isSquare: isSquare,
        ),
        SizedBox(
          height: heightBox,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: displayCard(),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff845bef),
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xff13d38e),
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        default:
          throw Error();
      }
    });
  }
}
