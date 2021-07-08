import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Statistics extends StatefulWidget {
  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  DateTime _Today = new DateTime.now();
  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
            children: [
              // Display the text on top of the chart
              Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Meal's result",
                      style: TextStyle(
                          color: Color(0xff827daa),
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ]),
              Text(
                _Today.toString().substring(0, 10),
                style: TextStyle(
                    color: Color(0xff827daa),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2),
                textAlign: TextAlign.center,
              ),

              /*SizedBox(
                width: 80,
                height: 40,
                child: DropdownTiming(),
              ),

              Expanded(
                child: DropdownTiming(),
              ),*/
              // Display the chart
              AspectRatio(
                aspectRatio:
                    0.8, //1.70 (ratio graphic between height and width),
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(18),
                      ),
                      color: Color(0xff232d37)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 18.0, left: 12.0, top: 24, bottom: 12),
                    child: LineChart(
                      showAvg ? avgData() : mainData(),
                    ),
                  ),
                ),
              ),

              // Button to display the average of the first curve
              SizedBox(
                width: 80,
                height: 40,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      showAvg = !showAvg;
                    });
                  },
                  child: Text(
                    'AVG',
                    style: TextStyle(
                        fontSize: 25,
                        color: showAvg
                            ? Colors.purple.withOpacity(0.5)
                            : Colors.purple),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Display the first curve between X:(0,11) et Y:(0,6)
  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,

        // lines in background
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),

      // Legends (X, Y, title)
      // X Axis
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'JUN';
              case 5:
                return 'JUL';
              case 8:
                return 'AUG';
            }
            return '';
          },
          margin: 8,
        ),

        // Y Axis
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '1000 kcal';
              case 3:
                return '1500 kcal';
              case 5:
                return '2000 kcal';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),

      // Chart Axis initialisation
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      // Data of the curve (add points (x,y))
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
          ],
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

  // Output: average of the first curve
  LineChartData avgData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'JUN';
              case 5:
                return 'JUL';
              case 8:
                return 'AUG';
            }
            return '';
          },
          margin: 8,
        ),

        // Y Axis Legend
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '1000 kcal';
              case 3:
                return '1500 kcal ';
              case 5:
                return '2000 kcal';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),

      // Size of the chart and display average data
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          colors: [
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2)!,
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2)!,
          ],
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(show: true, colors: [
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2)!
                .withOpacity(0.1),
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2)!
                .withOpacity(0.1),
          ]),
        ),
      ],
    );
  }
}

// class to choose in a list of name&icon (per day/per month/per week)
class Item {
  const Item(this.name);
  final String name;
}

class DropdownTiming extends StatefulWidget {
  const DropdownTiming({Key? key}) : super(key: key);

  @override
  State<DropdownTiming> createState() => DropdownTimingState();
}

class DropdownTimingState extends State<DropdownTiming> {
  Item SelectedUser = new Item('day');

  //List for the button
  List<Item> timing = <Item>[
    const Item(
      'day',
    ),
    const Item(
      'week',
    ),
    const Item(
      'month',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Item>(
      hint: Text('Select timing'),
      value: SelectedUser,
      onChanged: (Item? value) {
        setState(() {
          SelectedUser = value!;
        });
      },
      items: timing.map((Item time) {
        return DropdownMenuItem(
          value: time,
          child: Row(
            children: [
              Text(
                time.name,
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
