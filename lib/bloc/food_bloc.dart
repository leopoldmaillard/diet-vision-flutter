import 'package:transfer_learning_fruit_veggies/events/add_food.dart';
import 'package:transfer_learning_fruit_veggies/events/delete_food.dart';
import 'package:transfer_learning_fruit_veggies/events/food_event.dart';
import 'package:transfer_learning_fruit_veggies/events/set_food.dart';
import 'package:transfer_learning_fruit_veggies/events/update_food.dart';
import 'package:transfer_learning_fruit_veggies/model/food.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FoodBloc extends Bloc<FoodEvent, List<Food>> {
  @override
  List<Food> get initialState => [];

  FoodBloc() : super([]);

  ///index is the index of the item in the ListView.builder from HistoryMeal
  ///page (where it is displayed in the UI)

  @override
  Stream<List<Food>> mapEventToState(FoodEvent event) async* {
    if (event is SetFoods) {
      yield event.foodList;
    } else if (event is AddFood) {
      /// after added the food in the database, we create a new state and
      /// we add the new food to the state and return the state(foodlist)
      List<Food> newState = List.from(state);
      newState.add(event.newFood);
      yield newState;
    } else if (event is DeleteFood) {
      List<Food> newState = List.from(state);
      newState.removeAt(event.foodIndex);
      yield newState;
    } else if (event is UpdateFood) {
      List<Food> newState = List.from(state);
      newState[event.foodIndex] = event.newFood;
      yield newState;
    }
  }
}
