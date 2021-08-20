import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transfer_learning_fruit_veggies/events/set_food.dart';
import 'package:transfer_learning_fruit_veggies/services/local_storage_service.dart';
import 'package:transfer_learning_fruit_veggies/pages/FoodFormUpdateDatabase.dart';
import 'package:transfer_learning_fruit_veggies/bloc/food_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transfer_learning_fruit_veggies/model/food.dart';
import 'package:transfer_learning_fruit_veggies/events/delete_food.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryMeal extends StatefulWidget {
  const HistoryMeal({Key? key}) : super(key: key);

  @override
  _HistoryMealState createState() => _HistoryMealState();
}

class _HistoryMealState extends State<HistoryMeal> {
/* ****************************************************************************/
/* *********************  FUNCTIONS SIGNATURES  *******************************/
/* ****************************************************************************/
//   ==> PopupScreen
// dynamic showFoodDialog(BuildContext context, Food food, int index)
// AlertDialog displayPopup(Food food, int index)
// void deleteItem(Food food, int index)
// Widget displayDeleteButton(Food food, int index)
// Widget displayCancelButton()

// ==> General Design
// BlocConsumer<FoodBloc, List<Food>> getBlocConsummer()
// Card designItemDisplayed(List<Food> foodList, int index)
  @override
  void initState() {
    super.initState();
    retrieveDatabase();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // execute a query to retrieve database store in db variable
  void retrieveDatabase() {
    DatabaseProvider.db.getTodayFoods().then(
      (foodList) {
        print("la foodlist d'aujourdhui: \n" + foodList.toString());
        BlocProvider.of<FoodBloc>(context).add(
          SetFoods(foodList),
        );
      },
    );
  }

  /* **************************************************************************/
  /* *****************************  PopUp Screen  *****************************/
  /* **************************************************************************/

  //show the pop up by calling displayPopup
  dynamic showFoodDialog(BuildContext context, Food food, int index) {
    showDialog(
      // alert dialog comes with showdialog (need context and builder)
      context: context,
      barrierDismissible: false, //whether user can tap outside the aler dialog
      //Alert dialog are basically pop-ups with content and buttons
      builder: (context) => displayPopup(food, index),
    );
  }

  // BOUTON A FINIR : UPDATE

  // TextButton(
  //   onPressed: () => Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => Page2(),
  //     ),
  //   ),
  //   child: Text("Update"),
  // ),

  //Display a popup on which we can do actions on these items (update, delete..)
  AlertDialog displayPopup(Food food, int index) {
    return AlertDialog(
      title:
          food.nameUpdated == '' ? Text(food.nameFood) : Text(food.nameUpdated),
      content: Text("ID ${food.id}"), //main content, image easily integratable
      elevation: 24.0,
      actions: <Widget>[
        displayUpdateButton(food, index),
        displayDeleteButton(food, index),
        displayCancelButton(),
      ],
    );
  }

  void deleteItem(Food food, int index) {
    name = food.nameFood;
    users
        .add({'name': name})
        .then((value) => print('User Added'))
        .catchError((error) => print('Failed to Add a meal : $error'));
    DatabaseProvider.db.delete(food.id).then(
      (_) {
        BlocProvider.of<FoodBloc>(context).add(
          DeleteFood(index),
        );
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
  }

  Widget displayDeleteButton(Food food, int index) {
    return TextButton(
      onPressed: () => deleteItem(food, index),
      child: Text("Delete"),
    );
  }

  Widget displayCancelButton() {
    return TextButton(
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
      child: Text("Cancel"),
    );
  }

  Widget displayUpdateButton(Food food, int index) {
    return TextButton(
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoodForm(food: food, foodIndex: index),
          ),
        );
      },
      child: Text("Update"),
    );
  }
  /* **************************************************************************/
  /* ****************************  General Design  ****************************/
  /* **************************************************************************/

  BlocConsumer<FoodBloc, List<Food>> getBlocConsummer() {
    return BlocConsumer<FoodBloc, List<Food>>(
      builder: (context, foodList) {
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return designItemDisplayed(foodList, index);
          },
          itemCount: foodList.length,
        );
      },
      listener: (BuildContext context, foodList) {},
    );
  }

  Card designItemDisplayed(List<Food> foodList, int index) {
    Food food = foodList[index];
    return Card(
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Text(food.nameFood, style: TextStyle(fontSize: 26)),
        subtitle: Text(
          food.toString(),
          style: TextStyle(fontSize: 20),
        ),
        onTap: () => showFoodDialog(context, food, index),
      ),
    );
  }

  CollectionReference users = Firestore.instance.collection('users');
  var name = '';
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
}
