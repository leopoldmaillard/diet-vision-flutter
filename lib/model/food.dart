import 'package:transfer_learning_fruit_veggies/services/local_storage_service.dart';

class Food {
  // static int cpt = 0;
  int id = 0;
  String name = '';

  Food({required this.name}) {
    //incCpt();
    // this.id = cpt;
  }

  // static void incCpt() {
  //   cpt++;
  // }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{DatabaseProvider.COLUMN_NAME: name};

    if (id != 0) {
      map[DatabaseProvider.COLUMN_ID] = id;
    }

    return map;
  }

  Food.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProvider.COLUMN_ID];
    name = map[DatabaseProvider.COLUMN_NAME];
  }
}
