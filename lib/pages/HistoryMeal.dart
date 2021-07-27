import 'package:flutter/material.dart';
import 'package:transfer_learning_fruit_veggies/events/set_food.dart';
import 'package:transfer_learning_fruit_veggies/services/local_storage_service.dart';

import 'package:transfer_learning_fruit_veggies/bloc/food_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transfer_learning_fruit_veggies/model/food.dart';
import 'package:transfer_learning_fruit_veggies/pages/page2.dart';

class HistoryMeal extends StatefulWidget {
  const HistoryMeal({Key? key}) : super(key: key);

  @override
  _HistoryMealState createState() => _HistoryMealState();
}

class _HistoryMealState extends State<HistoryMeal> {
  @override
  void initState() {
    super.initState();
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(food.name),
        content: Text("ID ${food.id}"),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Page2(),
              ),
            ),
            child: Text("Update"),
          ),
          // TextButton(
          //   onPressed: () => DatabaseProvider.db.delete(food.id).then((_) {
          //     BlocProvider.of<FoodBloc>(context).add(
          //       DeleteFood(index),
          //     );
          //     Navigator.pop(context);
          //   }),
          //   child: Text("Delete"),
          // ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
        ],
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
                      "Name : ${food.name}${food.id}:\n id: ${food.id}",
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) => Page2()),
        ),
      ),
    );
  }
}
