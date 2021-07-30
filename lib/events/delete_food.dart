import 'food_event.dart';

class DeleteFood extends FoodEvent {
  late int foodIndex;

  DeleteFood(int index) {
    foodIndex = index;
  }
}
