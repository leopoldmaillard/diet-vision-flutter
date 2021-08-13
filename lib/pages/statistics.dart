//import 'dart:html';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:quiver/core.dart';
import 'package:transfer_learning_fruit_veggies/bloc/food_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transfer_learning_fruit_veggies/model/food.dart';

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

  List<FlSpot> dataMean = [];

  /* Data used for the display of statistics */
  //points to add on chart
  List<FlSpot> data = [];
  int tailleData = 366;

  //List Botton (week(0)/Month(1)/Year(2))
  int valueBotton = 0;
  List<String> titleButtonRadio = ['Week', 'Month', 'Year'];
  late LineChartData dataXTitle;
  bool Graphdisplayed = false;

  @override
  void initState() {
    super.initState();
    // day of the week: 1:monday,...7:sunday
    weekDay = _Today.weekday;
    maxValue = 2000;
    Graphdisplayed = false;
  }

//get AVG from the data
  double getAvg(List<FlSpot> dataPoints) {
    double mean = 0;
    int i = 0;
    for (i = 0; i < dataPoints.length; i++) {
      mean = mean + dataPoints[i].y;
    }
    return mean / i;
  }

  // the avg of a food item in a list
  //add an integer to choose the category (protein, glucide..) ? Or made the avg for all categories
  int getAvgFoodItem(List<Food> food) {
    double mean = 0;
    for (int i = 0; i < food.length; i++) {
      mean += food[i].kal;
    }
    mean = mean / food.length;
    return mean.toInt();
  }

  /* -----------CREATE DATA TO DISPLAY----------------- */
  //give a size and inster plot (i,kal) , initialize/register data
  List<FlSpot> fillLineChartCal(List<Food> listFood) {
    List<FlSpot> dataPoints = [];
    for (int i = 0; i < listFood.length; i++) {
      addPoint(dataPoints, listFood[i].kal, i + 1);
    }
    return dataPoints;
  }

  //give a size and inster plot (i,meankal) , initialize/register mean data
  List<FlSpot> fillMeanLineChartCal(List<Food> listFood) {
    List<FlSpot> dataPoints = [];
    for (int i = 0; i < listFood.length; i++) {
      addPoint(dataPoints, getAvgFoodItem(listFood).toDouble(), i + 1);
    }
    return dataPoints;
  }

  //change the value at the index given
  void replaceLineSpot(List<FlSpot> dataPoints, int index, double value) {
    double x;
    x = dataPoints[index].x;
    dataPoints[index] = FlSpot(x, value);
  }

  //add a point in the list
  void addPoint(List<FlSpot> pointList, double value, int index) {
    pointList.add(FlSpot(index.toDouble(), value));
  }

  //remove a point
  void removePoint(List<FlSpot> dataPoints, int index) {
    dataPoints.removeAt(index);
  }

/* ____________Widget Part________________*/

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
              color: Color(0xffB059EF), //B059EF ou 0xff827daa
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
              color: Color(0xffB059EF),
              fontSize: 25,
              fontWeight: FontWeight.bold,
              letterSpacing: 2),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

// display radio Botton
  Widget displayRadioButton(List<Food> mylist) {
    List<Widget> radioButtonList = [];
    for (int i = 0; i < titleButtonRadio.length; i++) {
      radioButtonList.add(RadioListTile(
        value: i,
        groupValue: valueBotton,
        onChanged: (val) {
          changeRadio(i);
        },
        activeColor: Theme.of(context).primaryColor,
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(titleButtonRadio[i]),
      ));
    }
    Column column = Column(children: radioButtonList);

    return column;
  }

  //DISPLAY THE CHART WITH THE LINECHARTBAR
  Widget DisplayChart(List<Food> mylist) {
    return AspectRatio(
      aspectRatio: 0.8, //1.70 (ratio graphic between height and width),
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(18),
            ),
            color: Color(
                0xff5D2ECB)), //Theme.of(context).primaryColor ou 0xff232d37
        child: Padding(
          padding: const EdgeInsets.only(
              right: 18.0, left: 12.0, top: 30, bottom: 12),
          child: LineChart(
            showAvg
                ? mainAVGData(mylist)
                : mainData(mylist), //avgData(mylist, dataMean)
          ),
        ),
      ),
    );
  }

  //Display axis titles legends (X)
  SideTitles displayAxisTitles(int axis) {
    return SideTitles(
      showTitles: true,
      reservedSize: axis == 0 ? 22 : 28,
      getTextStyles: (value) => const TextStyle(
        color: Color(0xffB1B1D5), //B1B1D5 ou 67727d
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
      getTitles: (value) => (axis == 0 && valueBotton == 0)
          ? getTitlesXWeek(value)
          : (axis == 0 && valueBotton == 1)
              ? getTitlesXMonth(value)
              : (axis == 0 && valueBotton == 2)
                  ? getTitlesXYear(value)
                  : (axis == 1)
                      ? getTitlesY(value)
                      : getTitlesY(value),
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
            if (Graphdisplayed == true) {
              Graphdisplayed = false;
            }
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

// LineChartData ==> changer l'axe X affichage
  LineChartData displayXTitle(int dataType, double minX, double maxX,
      double minY, double maxY, List<Food> foodList) {
    List<FlSpot> listPoints = [];
    if (dataType == 0) {
      listPoints = data;
    } else
      listPoints = dataMean;
    dataXTitle = LineChartData(
        lineTouchData: LineTouchData(enabled: false),
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: true,
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

        // Size of the chart and display data
        borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xff37434d), width: 1)),
        minX: minX,
        maxX: maxX,
        minY: minY,
        maxY: maxY,
        lineBarsData: [
          displayMeanData(maxX, listPoints, foodList),
        ]);
    return dataXTitle;
  }

  // Display the first curve between X:(0,time) et Y:(0,kcal max +50)
  LineChartData mainData(List<Food> foodList) {
    data = fillLineChartCal(foodList);
    maxValue = maxCal(foodList) + 50; //max cal in the food list
    double maxX =
        getTiming(foodList); //return the number of item in the food list
    double minX = 1; //(chart display first element at 1 index)
    return displayXTitle(0, minX, maxX, 0, maxValue, foodList);
  }

  // Display avg in the second curve between X:(0,time) et Y:(0,kcal max +50)
  LineChartData mainAVGData(List<Food> foodList) {
    dataMean = fillMeanLineChartCal(foodList);
    maxValue = maxCal(foodList) + 50; //max cal in the food list
    double maxX =
        getTiming(foodList); //return the number of item in the food list
    double minX = 1; //(chart display first element at 1 index)
    return displayXTitle(1, minX, maxX, 0, maxValue, foodList);
  }

  // return the max kcal of a food list
  double maxCal(List<Food> foodList) {
    List<double> cal = [];
    for (int i = 0; i < foodList.length; i++) {
      cal.add(foodList[i].kal);
    }
    return cal.reduce(math.max);
  }

  //display mean data or data in the graph
  LineChartBarData displayMeanData(
      double maxX, List<FlSpot> listPoints, List<Food> listFood) {
    return LineChartBarData(
      spots: listPoints,
      isCurved: true,
      colors: gradientColors,
      barWidth: 5,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
      ),
      belowBarData: BarAreaData(
        show: true,
        colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
      ),
    );
  }

  // display the screen of statistics part
  Widget displayStatisticScreen(BuildContext context, List<Food> mylist) {
    print(mylist);
    print(mylist[0].datetoString()); //date: y-m-d
    if (Graphdisplayed == false) {
      Graphdisplayed = true;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          displayTitle(),
          displayRadioButton(mylist),
          DisplayChart(mylist),
          AVGButton(),
          //Statistics2(),
        ],
      );
    } else
      return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(8),
        color: Colors.grey,
        //quand change dans le foodbloc, le bloc consumer sera updated
        child: getBlocConsummer(),
      ),
    );
  }

  // widget mafonction(){
  //   mon camembert
  //   return lastack;
  // }
  BlocConsumer<FoodBloc, List<Food>> getBlocConsummer() {
    return BlocConsumer<FoodBloc, List<Food>>(
      builder: (context, foodList) {
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Stack(
              // mettre mafonction ici
              children: <Widget>[
                SingleChildScrollView(
                  child: displayStatisticScreen(context, foodList),
                ),
              ],
            );
          },
          itemCount: foodList.length,
        );
      },
      listener: (BuildContext context, foodList) {},
    );
  }

  /* --------------------------Affichage du graphique Axis ------------------------------- */
  // get title of the Y axe
  String getTitlesY(value) {
    //  return (value.toString() + ' kcal');
    switch (value.toInt()) {
      // case 50:
      //   return '50';
      case 100:
        return '100';
      case 200:
        return '200';
      // case 250:
      //   return '250';
      case 1000:
        return '1000';
      case 1500:
        return '1500';
      case 2000:
        return '2000';
      case 2500:
        return '2500';
      case 3000:
        return '3000';
    }
    return '';
  }

  //get Title of the X axe
  String getTitlesXWeek(value) {
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

  String getTitlesXMonth(double value) {
    switch (value.toInt()) {
      case 1:
        return 'We1';
      case 7:
        return 'We2';
      case 14:
        return 'We3';
      case 21:
        return 'We4';
    }
    return '';
  }

  String getTitlesXYear(double value) {
    switch (value.toInt()) {
      // case 1:
      //   return 'Jan';
      // case 31:
      //   return 'Feb';
      // case 60:
      //   return 'Mar';
      // case 90:
      //   return 'Apr';
      // case 120:
      //   return 'Mai';
      // case 150:
      //   return 'Jun';
      // case 180:
      //   return 'Jul';
      // case 210:
      //   return 'Aug';
      // case 240:
      //   return 'Sept';
      // case 270:
      //   return 'Oct';
      // case 300:
      //   return 'Nov';
      // case 330:
      //   return 'Dec';
      case 1:
        return 'Jan';
      case 21:
        return 'Apr';
      case 180:
        return 'Aug';
      case 260:
        return 'Nov';
    }
    return "";
  }

  //change the value of the RadioButton
  void changeRadio(int value) {
    setState(() {
      valueBotton = value;
      if (Graphdisplayed == true) {
        Graphdisplayed = false;
      }
    });
  }

  //thanks to valueBottom we get the xMax of the graphic
  double getTiming(List<Food> foodList) {
    double xMax;
    double maxItem = foodList.length.toDouble();
    if (valueBotton == 0) {
      if (maxItem < 7) {
        xMax = maxItem;
      } else
        xMax = 7;
    } else if (valueBotton == 1) {
      if (maxItem < 31) {
        xMax = maxItem;
      } else
        xMax = 31;
    } else {
      if (maxItem < 366) {
        xMax = maxItem;
      } else
        xMax = 366;
    }
    return maxItem; // for 3 meal ==> return 3
  }
}
