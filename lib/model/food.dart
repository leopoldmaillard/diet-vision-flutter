import 'package:transfer_learning_fruit_veggies/services/local_storage_service.dart';

class Food {
  // static int cpt = 0;
  int id = 0;
  String nameFood = '';
  String nutriscore = '';
  int volEstim = -1;
  int volumicMass = -1;
  int mass = -1;
  int kal = -1;
  int protein = -1;
  int carbohydrates = -1;
  int sugar = -1;
  int fat = -1;

  Food({required this.nameFood});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{DatabaseProvider.COLUMN_NAMEFOOD: nameFood};

    map[DatabaseProvider.COLUMN_ID] = id;
    map[DatabaseProvider.COLUMN_NUTRISCORE] = nutriscore;
    if (mass != -1) map[DatabaseProvider.COLUMN_MASS] = mass;
    if (kal != -1) map[DatabaseProvider.COLUMN_KAL] = kal;
    if (protein != -1) map[DatabaseProvider.COLUMN_PROTEIN] = protein;
    if (carbohydrates != -1)
      map[DatabaseProvider.COLUMN_CARBOHYDRATES] = carbohydrates;
    if (sugar != -1) map[DatabaseProvider.COLUMN_SUGAR] = sugar;
    if (fat != -1) map[DatabaseProvider.COLUMN_FAT] = fat;
    if (volEstim != -1) map[DatabaseProvider.COLUMN_VOLESTIM] = fat;

    if (volumicMass != -1) map[DatabaseProvider.COLUMN_VOLUMICMASS] = fat;
    return map;
  }

  Food.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProvider.COLUMN_ID];
    nameFood = map[DatabaseProvider.COLUMN_NAMEFOOD];
    volEstim = map[DatabaseProvider.COLUMN_VOLESTIM];
    volumicMass = map[DatabaseProvider.COLUMN_VOLUMICMASS];
    nutriscore = map[DatabaseProvider.COLUMN_NUTRISCORE];
    mass = map[DatabaseProvider.COLUMN_MASS];
    kal = map[DatabaseProvider.COLUMN_KAL];
    protein = map[DatabaseProvider.COLUMN_PROTEIN];
    carbohydrates = map[DatabaseProvider.COLUMN_CARBOHYDRATES];
    sugar = map[DatabaseProvider.COLUMN_SUGAR];
    fat = map[DatabaseProvider.COLUMN_FAT];
  }
}
