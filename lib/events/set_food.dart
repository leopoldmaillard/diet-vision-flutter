import 'package:transfer_learning_fruit_veggies/model/food.dart';
import 'food_event.dart';

class SetFoods extends FoodEvent {
  //global variable that contain the database
  List<Food> foodList = [];

  SetFoods(List<Food> foods) {
    foodList = foods;
  }
}
