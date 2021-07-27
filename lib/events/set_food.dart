import 'package:transfer_learning_fruit_veggies/model/food.dart';
import 'food_event.dart';

class SetFoods extends FoodEvent {
  List<Food> foodList = [];

  SetFoods(List<Food> foods) {
    foodList = foods;
  }
}
