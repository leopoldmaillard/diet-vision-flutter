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
  //pie chart properties
  double fontSize = 0;
  double radius = 0;
  List<Color> colorPie = [
    Color(0xff0293ee),
    Color(0xfff8b250),
    Color(0xff845bef),
    Color(0xff13d38e)
  ];

  List<String> listNutritionLabel = [
    'cal',
    'protein',
    'carbohydrates',
    'sugar',
    'fat'
  ];

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
        displayEachCategoriesLegend(
            colorPie[0], listNutritionLabel[4], true, 4),
        displayEachCategoriesLegend(
            colorPie[1], listNutritionLabel[1], true, 4),
        displayEachCategoriesLegend(
            colorPie[2], listNutritionLabel[2], true, 4),
        displayEachCategoriesLegend(
            colorPie[3], listNutritionLabel[3], true, 18),
      ],
    );
  }

  //Legend for each categories colors
  Widget displayEachCategoriesLegend(
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

  //display the part of the pie chart
  PieChartSectionData displayEachCategories(
      Color color, double value, String title) {
    return PieChartSectionData(
      color: color,
      value: value,
      title: title,
      radius: radius,
      titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff)),
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
      fontSize = isTouched ? 25.0 : 16.0;
      radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return displayEachCategories(colorPie[i], 40, '40%');
        case 1:
          return displayEachCategories(colorPie[i], 30, '30%');
        case 2:
          return displayEachCategories(colorPie[i], 15, '15%');
        case 3:
          return displayEachCategories(colorPie[i], 15, '15%');
        default:
          throw Error();
      }
    });
  }
}
