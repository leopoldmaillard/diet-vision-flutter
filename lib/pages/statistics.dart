import 'dart:math';
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

  // get AVG
  LineChartBarData curve = new LineChartBarData();
  //points to add on chart
  List<FlSpot> data = [];
  List<FlSpot> dataMean = [];
  //data for a mounth
  List<double> dataCal = [];
  int tailleData = 366;

  //List Botton (week(0)/Month(1)/Year(2))
  int valueBotton = 0;
  List<String> titleButtonRadio = ['Week', 'Month', 'Year'];
  late LineChartData dataXTitle;

  //Use of a Food list
  List<Food> itemListDay = [];
  // Food finalMeal = Food(nameFood: "");
  // finalMeal.volEstim = 15;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < tailleData; i++) {
      addPoint(0.0);
    }
    //fillKCalData(dataCal);
    fillLineChart();
    // day of the week: 1:monday,...7:sunday
    weekDay = _Today.weekday;
    maxValue = 2000;
    //test food avg
    //fillItemFood(itemListDay, 9);
    //print('avg food item for a day is: ${getAvgFoodItem(itemListDay)}');
  }

  @override
  void dispose() {
    super.dispose();
    data = [];
    dataCal = [];
    itemListDay = [];
  }

//get AVG from the data
  double getAvg() {
    double mean = 0;
    int i = 0;
    for (i = 0; i < data.length; i++) {
      mean = mean + data[i].y;
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

  //give a size and inster plot (i,0) , initialize/register data
  void fillLineChart() {
    var r = new Random();
    for (int i = 0; i < tailleData; i++) {
      if (data.length < 0) {
        data.add(FlSpot(i.toDouble() + 1, 1000));
      } else {
        replaceLineSpot(data, i, r.nextDouble() * 2000);
      }
    }
    dataMean = data;
  }

  //change the value at the index given
  void replaceLineSpot(List<FlSpot> da, int index, double value) {
    double x;
    x = da[index].x;
    da[index] = FlSpot(x, value);
  }

  //add a point in the list
  void addPoint(double value) {
    data.add(FlSpot(data.length.toDouble() + 1, value));
  }

  //remove a point
  void removePoint(int index) {
    data.removeAt(index);
  }

  //add points (y) in the dataCalories
  void fillKCalData(List<double> Calories) {
    var rng = new Random();
    double minVal = 200;
    for (int i = 0; i < Calories.length; i++) {
      Calories.add((rng.nextDouble() + 200) * (maxValue - minVal));
    }
  }

//fill a list of Food for a day
  void fillItemFood(List<Food> food, int taille) {
    double kal = -1, protein = -1, carbohydrates = -1, sugar = -1, fat = -1;
    var r = new Random();
    for (int i = 0; i < taille; i++) {
      kal = ((r.nextDouble()) * 200 + 10);
      protein = ((r.nextDouble()) * 200 + 10);
      carbohydrates = ((r.nextDouble()) * 200 + 10);
      sugar = ((r.nextDouble()) * 200 + 10);
      fat = ((r.nextDouble()) * 200 + 10);
      Food myfood = Food(nameFood: 'numero $i');
      myfood.id = i;
      myfood.kal = kal;
      myfood.protein = protein;
      food.add(myfood);
    }
    print('voici la liste de food item: $food');
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
  Widget displayRadioButton() {
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
  Widget DisplayChart() {
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
            showAvg ? avgData() : mainData(),
          ),
        ),
      ),
    );
  }

  //Display axis titles legends (X)
  SideTitles displayAxisTitles(int axis) {
    return SideTitles(
      showTitles: true,
      reservedSize: axis == 0 ? 22 : 28, //22
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
                  : getTitlesY(value),
      margin: axis == 0 ? 8 : 12, //8
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

// LineChartData ==> changer l'axe X affichage
  LineChartData displayXTitle(
      int dataType, double minX, double maxX, double minY, double maxY) {
    dataXTitle = LineChartData(
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

        // Size of the chart and display data
        borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xff37434d), width: 1)),
        minX: minX,
        maxX: maxX,
        minY: minY,
        maxY: maxY,
        lineBarsData: [
          displayMeanData(dataType, maxX),
        ]);
    return dataXTitle;
  }

  // Display the first curve between X:(0,11) et Y:(0,6)
  LineChartData mainData() {
    return displayXTitle(0, 1, getTiming(), 0, maxValue);
  }

  //display mean data
  LineChartBarData displayMeanData(int dataType, double maxX) {
    return LineChartBarData(
      spots: (dataType == 0)
          ? data.sublist(0, maxX.toInt())
          : dataMean.sublist(0, maxX.toInt()),
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

  // Output: average of the first curve
  LineChartData avgData() {
    double mean = getAvg();
    for (int i = 0; i < dataMean.length; i++) {
      replaceLineSpot(dataMean, i, mean);
    }
    return displayXTitle(1, 1, getTiming(), 0, maxValue);
  }

  // display the screen of statistics part
  Widget displayStatisticScreen(BuildContext context, List<Food> mylist) {
    print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
    print(mylist);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        displayTitle(),
        displayRadioButton(),
        DisplayChart(),
        AVGButton(),
        //Statistics2(),
      ],
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   fillLineChart();
  //   return Stack(
  //     children: <Widget>[
  //       SingleChildScrollView(
  //         child: displayStatisticScreen(context),
  //       ),
  //     ],
  //   );
  // }

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
    });
  }

  //thanks to valueBottom we get the xMax of the graphic
  double getTiming() {
    double xMax;
    if (valueBotton == 0) {
      xMax = 7;
    } else if (valueBotton == 1) {
      xMax = 31;
    } else
      xMax = 366;
    return xMax;
  }
}

// //class Food
// class Food {
//   // static int cpt = 0;
//   int id = 0;
//   String nameFood = '';
//   String nutriscore = '';
//   int volEstim = -1;
//   int volumicMass = -1;
//   int mass = -1;
//   int kal = -1;
//   int protein = -1;
//   int carbohydrates = -1;
//   int sugar = -1;
//   int fat = -1;

//   Food({
//     required this.nameFood,
//     required this.id,
//     required this.kal,
//     required this.protein,
//     required this.carbohydrates,
//     required this.sugar,
//     required this.fat,
//   });

//   String toString() {
//     String nameFood = 'nameFood : ' + this.nameFood + '\n';
//     // String volEstim = 'Volume : ' + this.volEstim.toString() + 'cm³' + '\n';
//     // String volumicMass =
//     //     'Volumic mass : ' + (this.volumicMass).toString() + '\n';
//     // String mass = 'mass food : ' + this.mass.toString() + '\n';
//     String kal = this.kal.toString() + 'kcal\n';
//     // String protein = 'protein : ' + this.protein.toString() + 'g' + '\n';
//     // String carbohydrates =
//     //     'carbohydrates : ' + this.carbohydrates.toString() + 'g' + '\n';
//     // String sugar = 'sugar : ' + this.sugar.toString() + 'g' + '\n';
//     // String fat = 'fat : ' + this.fat.toString() + 'g' + '\n';
//     String finalString =
//         (nameFood + kal); //+ volEstim + protein + carbohydrates + sugar + fat);
//     // pour moi pas de sens de mettre la masse volumique d'un repas
//     // if (this.volumicMass != null) finalString += volumicMass;
//     // if (this.mass != null) finalString += mass;
//     return finalString;
//   }
// }
