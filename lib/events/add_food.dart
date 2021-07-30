import 'package:transfer_learning_fruit_veggies/model/food.dart';
import 'food_event.dart';

class AddFood extends FoodEvent {
  late Food newFood;

  AddFood(Food food) {
    newFood = food;
  }
}
