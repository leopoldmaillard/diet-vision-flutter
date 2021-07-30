import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';

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
  int weekDay = 0; //monday .. (1=mond, ... 7=sunday)
  double maxValue = 0;
  bool showAvg = false;
  // get AVG
  LineChartBarData curve = new LineChartBarData();
  //points to add on chart
  List<FlSpot> data = [];
  //data for a mounth
  List<double> dataCal = [];
  int tailleData = 7;

  // get title of the Y axe
  String getTitlesY(value) {
    //  return (value.toString() + ' kcal');
    switch (value.toInt()) {
      case 500:
        return '500 kcal';
      case 1000:
        return '1000 kcal';
      case 1500:
        return '1500 kcal ';
      case 2000:
        return '2000 kcal';
      case 2500:
        return '2500 kcal';
      case 3000:
        return '3000 kcal';
    }
    return '';
  }

  //get Title of the X axe
  String getTitlesX(value) {
    switch (value.toInt()) {
      case 1:
        return 'Mo';
      case 2:
        return 'Tu';
      case 3:
        return 'We';
      case 4:
        return 'Th';
      case 5:
        return 'Fr';
      case 6:
        return 'Sa';
      case 7:
        return 'Su';
    }
    return '';
  }

  double getAvg() {
    double mean = 0;
    return mean;
  }

  //give a size and inster plot (i,0) , initialize/register data
  void fillLineChart() {
    data = [];
    if (data.length == 0) {
      for (int i = 0; i < tailleData; i++) {
        data.add(FlSpot(i.toDouble() + 1, 1000));
      }
    }
    if (data[tailleData - 2].y == 1000) {
      replaceLineSpot(tailleData - 2, 1200);
      data.add(FlSpot(7, 500));
    }
    print(data);
  }

  //change the value at the index given
  void replaceLineSpot(int index, double value) {
    double x;
    x = data[index].x;
    data[index] = FlSpot(x, value);
  }

  //add a point in the list
  void addPoint(double value) {
    data.add(FlSpot(data.length.toDouble(), value));
  }

  //remove a point
  void removePoint(int index) {
    data.removeAt(index);
  }
  // //add points (y) in the dataCalories
  // void fillKCalData(List<double> Calories) {
  //   for (int i = 0; i < Calories.length; i++) {
  //     Calories.add(1000);
  //   }
  // }

  // ignore: slash_for_doc_comments
/******************Widget Part *********************/

  // display the top list above the chart
  Widget displayTitle() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        const Text(
          "Meal's result per week",
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
        Text(
          _Today.toString().substring(0, 10),
          style: TextStyle(
              color: Color(0xff827daa),
              fontSize: 25,
              fontWeight: FontWeight.bold,
              letterSpacing: 2),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  //dSPLAY THE CHART WITH THE LINECHARTBAR
  Widget DisplayChart() {
    return AspectRatio(
      aspectRatio: 0.8, //1.70 (ratio graphic between height and width),
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(18),
            ),
            color: Color(0xff232d37)), //Theme.of(context).primaryColor
        child: Padding(
          padding: const EdgeInsets.only(
              right: 18.0, left: 12.0, top: 24, bottom: 12),
          child: LineChart(
            showAvg ? avgData() : mainData(),
          ),
        ),
      ),
    );
  }

  //Display axis titles
  SideTitles displayAxisTitles(int axis) {
    return SideTitles(
      showTitles: true,
      reservedSize: axis == 0 ? 22 : 28,
      getTextStyles: (value) => const TextStyle(
        color: Color(0xff67727d),
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
      getTitles: (value) => axis == 0 ? getTitlesX(value) : getTitlesY(value),
      margin: axis == 0 ? 8 : 12,
    );
  }

  //Button for AVG of the linechartbar
  Widget AVGButton() {
    return SizedBox(
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
              color: showAvg ? Colors.purple.withOpacity(0.5) : Colors.purple),
        ),
      ),
    );
  }

// display the screen of statistics part
  Widget displayStatisticScreen(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        displayTitle(),
        DisplayChart(),
        AVGButton(),
        // Test for Dropdown Button
        /*     SizedBox(
          width: 80,
          height: 40,
          child: DropdownTiming(),
        ),
        Expanded(
          child: DropdownTiming(),
        ),*/
      ],
    );
  }

  //display data in the chart
  LineChartBarData displayData() {
    return LineChartBarData(
      spots: data,
      isCurved: true,
      colors: gradientColors,
      barWidth: 5,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: true,
        colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
      ),
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
        bottomTitles: displayAxisTitles(0),
        // Y Axis
        leftTitles: displayAxisTitles(1),
      ),

      // Chart Axis initialisation
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 1,
      maxX: 7,
      minY: 0,
      maxY: maxValue,
      // Data of the curve (add points (x,y))
      lineBarsData: [
        displayData(),
      ],
    );
  }

  //display mean data
  LineChartBarData displayMeanData() {
    return LineChartBarData(
      spots: data,
      isCurved: true,
      colors: gradientColors,
      barWidth: 5,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: true,
        colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
      ),
    );
  }

  // Output: average of the first curve
  LineChartData avgData() {
    double mean = getAvg();
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
          bottomTitles: displayAxisTitles(0),
          // Y Axis Legend
          leftTitles: displayAxisTitles(1),
        ),

        // Size of the chart and display average data
        borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xff37434d), width: 1)),
        minX: 1,
        maxX: 7,
        minY: 0,
        maxY: maxValue,
        lineBarsData: [
          displayMeanData(),
        ] /*
        LineChartBarData(
          spots: [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
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
      ],*/
        );
  }

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < tailleData; i++) {
      dataCal.add(0.0);
    }
    // fillKCalData(dataCal);
    fillLineChart();
    // day of the week: 1:monday,...7:sunday
    weekDay = _Today.weekday;
    print('the day: $weekDay');
    maxValue = 2000;
  }

  @override
  void dispose() {
    super.dispose();
    data = [];
    dataCal = [];
  }

  @override
  Widget build(BuildContext context) {
    fillLineChart();
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: displayStatisticScreen(context),
        ),
      ],
    );
  }
}

// class to choose in a list of name&icon (per day/per month/per week)
class Item {
  final String name;
  const Item(this.name);
}

class DropdownTiming extends StatefulWidget {
  const DropdownTiming({Key? key}) : super(key: key);

  @override
  State<DropdownTiming> createState() => DropdownTimingState();
}

class DropdownTimingState extends State<DropdownTiming> {
  String SelectedUser = "week";

  //List for the button
  List<String> timing = <String>['day', 'week', 'month'];

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      hint: Text('Select timing'),
      value: SelectedUser,
      onChanged: (String? newValue) {
        setState(() {
          SelectedUser = newValue!;
        });
      },
      items: timing.map((String time) {
        return DropdownMenuItem(
          value: time,
          child: Row(
            children: [
              Text(
                time,
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
