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

  @override
  Stream<List<Food>> mapEventToState(FoodEvent event) async* {
    if (event is SetFoods) {
      yield event.foodList;
    } else if (event is AddFood) {
      List<Food> newState = List.from(state);
      if (event.newFood != null) {
        newState.add(event.newFood);
      }
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
