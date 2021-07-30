import 'package:flutter/material.dart';
import 'package:transfer_learning_fruit_veggies/events/set_food.dart';
import 'package:transfer_learning_fruit_veggies/services/local_storage_service.dart';

import 'package:transfer_learning_fruit_veggies/bloc/food_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transfer_learning_fruit_veggies/model/food.dart';
import 'package:transfer_learning_fruit_veggies/pages/page2.dart';
import 'package:transfer_learning_fruit_veggies/events/delete_food.dart';

class HistoryMeal extends StatefulWidget {
  const HistoryMeal({Key? key}) : super(key: key);

  @override
  _HistoryMealState createState() => _HistoryMealState();
}

class _HistoryMealState extends State<HistoryMeal> {
  @override
  void initState() {
    super.initState();
    retrieveDatabase();
  }

  // execute a query to retrieve database store in db variable
  void retrieveDatabase() {
    DatabaseProvider.db.getFoods().then(
      (foodList) {
        print(foodList);
        BlocProvider.of<FoodBloc>(context).add(
          SetFoods(foodList),
        );
      },
    );
  }

  showFoodDialog(BuildContext context, Food food, int index) {
    // alert dialog come with showdialog (need context and builder)
    showDialog(
      context: context,
      barrierDismissible: false, //whether user can tap outside the alerdialog
      //Alert dialog are basically pop-ups with content and buttons
      builder: (context) => AlertDialog(
        title: Text(food.name),
        content:
            Text("ID ${food.id}"), //main content, image easily integratable
        actions: <Widget>[
          // TextButton(
          //   onPressed: () => Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => Page2(),
          //     ),
          //   ),
          //   child: Text("Update"),
          // ),

          ///after we delete the food from ouf database, then we delete the
          ///food from our foodbloc (and the dialog)
          TextButton(
            onPressed: () => DatabaseProvider.db.delete(food.id).then(
              (_) {
                BlocProvider.of<FoodBloc>(context).add(
                  DeleteFood(index),
                );
                Navigator.pop(context);
              },
            ),
            child: Text("Delete"),
          ),

          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
        ],
        elevation: 24.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Building entire food list scaffold");
    return Scaffold(
      appBar: AppBar(
        title: Text("Persistent storage"),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        color: Colors.grey,

        ///a tout moment ou qqchose change dans le foodbloc, le bloc consumer
        /// sera updated
        child: BlocConsumer<FoodBloc, List<Food>>(
          builder: (context, foodList) {
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                print("foodList: $foodList");

                Food food = foodList[index];
                return Card(
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(food.name, style: TextStyle(fontSize: 26)),
                    subtitle: Text(
                      "id: ${food.id}",
                      style: TextStyle(fontSize: 20),
                    ),
                    onTap: () => showFoodDialog(context, food, index),
                  ),
                );
              },
              itemCount: foodList.length,
            );
          },
          listener: (BuildContext context, foodList) {},
        ),
      ),
    );
  }
}


/***
 *  BlocConsumer is analogous to a nested BlocListener and BlocBuilder
 *  BlocConsumer should only be used when it is necessary to both rebuild UI and
 *  execute other reactions to state changes in the bloc.
 *  -required BlocWidgetBuilder and BlocWidgetListener
 */