import 'package:transfer_learning_fruit_veggies/model/food.dart';
import 'food_event.dart';

class UpdateFood extends FoodEvent {
  late Food newFood;
  late int foodIndex;

  UpdateFood(int index, Food food) {
    newFood = food;
    foodIndex = index;
  }
}
