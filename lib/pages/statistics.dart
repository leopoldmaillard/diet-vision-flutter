//import 'dart:html';
import 'dart:math' as math;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:transfer_learning_fruit_veggies/bloc/food_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transfer_learning_fruit_veggies/model/food.dart';
import 'package:transfer_learning_fruit_veggies/services/local_storage_service.dart';
import 'package:transfer_learning_fruit_veggies/events/set_food.dart';

/**
 * Fonctions potentielles à enlever:
 * filllinechart
 * fillmeanlinechart
 * maxcal
 * getavgfooditem
 * getTiming
 */

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
  int epoch = new DateTime.now().millisecondsSinceEpoch;
  int weekDay = 0; //monday .. (1=mond, ... 7=sunday)
  double maxValue = 0;
  double minValue = 0;
  bool showAvg = false;

  List<FlSpot> dataMean = [];

  /* Data used for the display of statistics */
  //points to add on chart
  List<FlSpot> data = [];
  int tailleData = 366;

  //List Botton (week(0)/Month(1)/Year(2))
  int valueBotton = 0;
  List<String> titleButtonRadio = ['Week', 'Month', 'Day'];
  late LineChartData dataXTitle;
  bool Graphdisplayed = false;
  List<double> Calories = [];
  //know which first day of a week we have in the database
  int firstDay = 0;
  List<String> WeekDays = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
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

  // the avg of a food item in a list
  //add an integer to choose the category (protein, glucide..) ? Or made the avg for all categories
  int getAvgFoodItemCal(List<FlSpot> listPoints) {
    double mean = 0;
    for (int i = 0; i < listPoints.length; i++) {
      mean += listPoints[i].y;
    }
    mean = mean / listPoints.length;
    return mean.toInt();
  }

  /* -----------CREATE DATA TO DISPLAY----------------- */
  // give a size and inster plot (i,kal) , initialize/register data
  // List<FlSpot> fillLineChartCal(List<Food> listFood) {
  //   List<FlSpot> dataPoints = [];
  //   for (int i = 0; i < listFood.length; i++) {
  //     addPoint(dataPoints, listFood[i].kal, i + 1);
  //   }
  //   return dataPoints;
  // }

  List<FlSpot> fillLineChartCal(List<Food> listFood) {
    List<double> liste = [];
    List<FlSpot> dataPoints = [];
    print('ca passe ici ligne 84');
    if (valueBotton == 0 || valueBotton == 1) {
      liste = SumKcal(listFood);
      for (int i = 0; i < liste.length; i++) {
        addPoint(dataPoints, liste[i], i + 1);
      }
    } else {
      for (int i = 0; i < listFood.length; i++) {
        addPoint(dataPoints, listFood[i].kal, i + 1);
      }
    }
    print('ca passe ligne 95');
    return dataPoints;
  }

  //give a size and inster plot (i,meankal) , initialize/register mean data
  List<FlSpot> fillMeanLineChart(List<Food> listFood) {
    List<FlSpot> dataPoints = [];
    for (int i = 0; i < listFood.length; i++) {
      addPoint(dataPoints, getAvgFoodItem(listFood).toDouble(), i + 1);
    }
    return dataPoints;
  }

  //give a size and inster plot (i,meankal) , initialize/register mean data
  List<FlSpot> fillMeanLineChartCal(List<FlSpot> listPoints) {
    List<FlSpot> dataPoints = [];
    for (int i = 0; i < data.length; i++) {
      addPoint(dataPoints, getAvgFoodItemCal(listPoints).toDouble(), i + 1);
    }
    return dataPoints;
  }

  List<double> SumKcal(List<Food> mylist) {
    List<double> listCal = [];
    print('ca passe ligne 110');
    if (valueBotton == 0) {
      listCal = getSumWeek(mylist);
    } else if (valueBotton == 1) {
      listCal = getSumMonth(mylist);
    }
    print('ca passe ligne 116: LIST DE KAL SUMMED: $listCal');
    return listCal;
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
          Database();
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
  SideTitles displayAxisTitles(int axis, List<Food> mylist) {
    int indexDay = 0;
    if (mylist.length != 0) {
      indexDay = getWeekDay(mylist[0]);
    }
    return SideTitles(
      showTitles: true,
      reservedSize: axis == 0 ? 22 : 28,
      getTextStyles: (value) => const TextStyle(
        color: Color(0xffB1B1D5), //B1B1D5 ou 67727d
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
      getTitles: (value) => (axis == 0 && valueBotton == 0)
          ? getTitlesXWeek(value, indexDay)
          : (axis == 0 && valueBotton == 1)
              ? getTitlesXMonth(value)
              : (axis == 0 && valueBotton == 2)
                  ? getTitlesXDay(value)
                  : (axis == 1)
                      ? getTitlesY(4 * value)
                      : getTitlesY(4 * value),
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
      double minY, double maxY, mylist) {
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
          bottomTitles: displayAxisTitles(0, mylist),
          // Y Axis Legend
          leftTitles: displayAxisTitles(1, mylist),
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
          displayMeanData(maxX, listPoints),
        ]);
    return dataXTitle;
  }

  // Display the first curve between X:(0,time) et Y:(0,kcal max +50)
  LineChartData mainData(List<Food> foodList) {
    data = fillLineChartCal(foodList);
    //max cal in the food list
    maxValue = maxCalSum(data) + 50;
    minValue = minCalSum(data);
    double maxX = getTimingCal(data);
    // double maxX =
    //     getTiming(foodList); //return the number of item in the food list
    double minX = 1; //(chart display first element at 1 index)
    return displayXTitle(0, minX, maxX, minValue, maxValue, foodList);
  }

  // Display avg in the second curve between X:(0,time) et Y:(0,kcal max +50)
  LineChartData mainAVGData(List<Food> foodList) {
    dataMean = fillMeanLineChartCal(data);
    maxValue = maxCalSum(data) + 50; //max cal in the food list
    minValue = minCalSum(data);
    double maxX = getTimingCal(data);
    // double maxX =
    //getTiming(foodList); //return the number of item in the food list
    double minX = 1; //(chart display first element at 1 index)
    return displayXTitle(1, minX, maxX, minValue, maxValue, foodList);
  }

  // return the max kcal of a food list
  double maxCal(List<Food> foodList) {
    List<double> cal = [];
    for (int i = 0; i < foodList.length; i++) {
      cal.add(foodList[i].kal);
    }
    return cal.reduce(math.max);
  }

  //return the max of sum of kcal for a day
  double maxCalSum(List<FlSpot> listPoints) {
    List<double> cal = [];
    for (int i = 0; i < listPoints.length; i++) {
      cal.add(listPoints[i].y);
    }
    return cal.reduce(math.max);
  }

  //return the min value of the sum of meal per day
  double minCalSum(List<FlSpot> listPoints) {
    List<double> cal = [];
    for (int i = 0; i < listPoints.length; i++) {
      cal.add(listPoints[i].y);
    }
    return cal.reduce(math.min);
  }

  //display mean data or data in the graph
  LineChartBarData displayMeanData(double maxX, List<FlSpot> listPoints) {
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
    //date: y-m-d
    if (Graphdisplayed == false) {
      Graphdisplayed = true;
      if (mylist.length == 0) {
        return Text(
            'You can go on the camera screen and take pictures of your meal');
      } else
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
      case 0:
        return '0';
      case 100:
        return '100';
      case 200:
        return '200';
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

  String getTitlesXWeek(value, int indexDay) {
    switch (value.toInt()) {
      case 1:
        return indexDayWeek(1, indexDay);
      case 2:
        return indexDayWeek(2, indexDay);
      case 3:
        return indexDayWeek(3, indexDay);
      case 4:
        return indexDayWeek(4, indexDay);
      case 5:
        return indexDayWeek(5, indexDay);
      case 6:
        return indexDayWeek(6, indexDay);
      case 7:
        return indexDayWeek(7, indexDay);
    }
    return '';
  }

  //give the right day in function of the index of the day in a week
  String indexDayWeek(int casei, int index) {
    if ((index + casei) < 9) {
      return WeekDays[index + casei - 2];
    } else {
      int reste = index + casei - 9;
      return WeekDays[reste];
    }
  }

  //Display the number of the week in case of the index of the food
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

  //Display the number of the week in case of the index of the food
  String getTitlesXDay(double value) {
    // String first = getTime(myList[0]);
    switch (value.toInt()) {
      case 1:
        return 'morning';
      case 3:
        return 'afternoon';
    }
    return '';
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
    double xMax = 0;
    double maxItem = foodList.length.toDouble();
    if (valueBotton == 2) {
      if (maxItem < 10) {
        xMax = maxItem + 1;
      } else
        xMax = 4;
    } else if (valueBotton == 0) {
      if (maxItem < 7) {
        xMax = maxItem + 1;
      } else
        xMax = 7;
    } else if (valueBotton == 1) {
      if (maxItem < 30) {
        xMax = maxItem + 1;
      } else
        xMax = 31;
    }
    return xMax; // for 3 meal ==> return 3
  }

  double getTimingCal(List<FlSpot> listPoints) {
    double maxItem = listPoints.length.toDouble();
    return maxItem; // for 3 meal ==> return 3
  }

  /* _________________DATABASE AND FOOD LIST_____________ */
  // List<FlSpot> getFoodListTiming(List<Food> foodList) {
  //   List<FlSpot> listPoints = [];
  //   int size = 0;
  //   if (valueBotton == 0) {
  //     size = 7;
  //   }
  //   if (valueBotton == 1) {
  //     size = 30;
  //   }
  //   if (valueBotton == 2) {
  //     size = 365;
  //   }

  //   return listPoints;
  // }

  //request to use the day list of meal
  void DayDatabase() {
    DatabaseProvider.db.getTodayFoods().then((foodList) {
      BlocProvider.of<FoodBloc>(context).add(
        SetFoods(foodList),
      );
    });
  }

  //request to use the week list of meal
  void Database() {
    switch (valueBotton) {
      case 0:
        DatabaseProvider.db.getWeekFoods().then((foodList) {
          BlocProvider.of<FoodBloc>(context).add(
            SetFoods(foodList),
          );
        });
        break;
      case 1:
        DatabaseProvider.db.getMonthFoods().then((foodList) {
          BlocProvider.of<FoodBloc>(context).add(
            SetFoods(foodList),
          );
        });
        break;
      case 2:
        DatabaseProvider.db.getTodayFoods().then((foodList) {
          BlocProvider.of<FoodBloc>(context).add(
            SetFoods(foodList),
          );
        });
        break;
    }
  }

// get a list of calories for the week
  List<double> getSumWeek(List<Food> myList) {
    int size = myList.length;
    List<double> SumKcal = [];
    int day = 0;
    int dayselected = getDay(myList[day]);
    firstDay = getWeekDay(myList[day]);
    print('dayselected: $dayselected');
    SumKcal = filled(0, 7);
    for (int i = 0; i < size; i++) {
      if (getDay(myList[i]) == dayselected) {
        SumKcal[day] += myList[i].kal;
      } else {
        day += 1;
        if (getDay(myList[i]) == (dayselected + 1)) {
          dayselected = getDay(myList[i]);
          SumKcal[day] += myList[i].kal;
        } else
          dayselected += 1;
        // if (i + 1 < size) dayselected = getDay(myList[i + 1]);
      }
    }
    print(SumKcal);
    return SumKcal;
  }

//create a List of null
  List<double> filled(double value, int size) {
    List<double> liste = [];
    for (int i = 0; i < size; i++) {
      liste.add(value);
    }
    return liste;
  }

// get a list of calories for the month
  List<double> getSumMonth(List<Food> myList) {
    int size = myList.length;
    List<double> SumKcal = [];
    int month = 0;
    int monthselected = getMonth(myList[month]);
    print('AAAAAAAAAAA month selected:  $monthselected');
    SumKcal = filled(0, 31);
    for (int i = 0; i < size; i++) {
      if (getMonth(myList[i]) == monthselected) {
        SumKcal[month] += myList[i].kal;
      } else {
        if (month < 12) {
          month += 1;
        } else
          month = 1;
        if (i + 1 < size) monthselected = getMonth(myList[i + 1]);
      }
    }
    return SumKcal;
  }

  int getDay(Food myFood) {
    return DateTime.fromMillisecondsSinceEpoch(myFood.dateSinceEpoch).day;
  }

  int getMonth(Food myFood) {
    return DateTime.fromMillisecondsSinceEpoch(myFood.dateSinceEpoch).month;
  }

  int getYear(Food myFood) {
    return DateTime.fromMillisecondsSinceEpoch(myFood.dateSinceEpoch).year;
  }

  int getWeekDay(Food myFood) {
    return DateTime.fromMillisecondsSinceEpoch(myFood.dateSinceEpoch).weekday;
  }

  // String getTime(Food myFood) {
  //   return '${DateTime.fromMillisecondsSinceEpoch(myFood.dateSinceEpoch).hour} h ' +
  //       '${DateTime.fromMillisecondsSinceEpoch(myFood.dateSinceEpoch).minute} min';
  // }
}
