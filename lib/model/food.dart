import 'package:transfer_learning_fruit_veggies/services/local_storage_service.dart';

class Food {
  // static int cpt = 0;
  int id = 0;
  String nameFood = '';
  String nutriscore = '';
  int volEstim = 0;
  int volumicMass = 0;
  int mass = 0;
  int kal = 0;
  int protein = 0;
  int carbohydrates = 0;
  int sugar = 0;
  int fat = 0;

  Food({required this.nameFood});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{DatabaseProvider.COLUMN_NAMEFOOD: nameFood};

    /// do not remove this line becasue the database cant autoincrement if
    /// we store it at 0
    map[DatabaseProvider.COLUMN_ID] = id;
    map[DatabaseProvider.COLUMN_NUTRISCORE] = nutriscore;
    map[DatabaseProvider.COLUMN_MASS] = mass;
    map[DatabaseProvider.COLUMN_KAL] = kal;
    map[DatabaseProvider.COLUMN_PROTEIN] = protein;
    map[DatabaseProvider.COLUMN_CARBOHYDRATES] = carbohydrates;
    map[DatabaseProvider.COLUMN_SUGAR] = sugar;
    map[DatabaseProvider.COLUMN_FAT] = fat;
    map[DatabaseProvider.COLUMN_VOLESTIM] = volEstim;
    map[DatabaseProvider.COLUMN_VOLUMICMASS] = volumicMass;
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

  String toString() {
    // String nameFood = 'nameFood : ' + this.nameFood + '\n';
    String volEstim = 'Volume : ' + this.volEstim.toString() + 'cm³' + '\n';
    String volumicMass =
        'Volumic mass : ' + (this.volumicMass).toString() + '\n';
    String mass = 'mass food : ' + this.mass.toString() + '\n';
    String kal = this.kal.toString() + 'kcal\n';
    String protein = 'protein : ' + this.protein.toString() + 'g' + '\n';
    String carbohydrates =
        'carbohydrates : ' + this.carbohydrates.toString() + 'g' + '\n';
    String sugar = 'sugar : ' + this.sugar.toString() + 'g' + '\n';
    String fat = 'fat : ' + this.fat.toString() + 'g' + '\n';
    String finalString =
        (kal + volEstim + protein + carbohydrates + sugar + fat);
    // pour moi pas de sens de mettre la masse volumique d'un repas
    // if (this.volumicMass != null) finalString += volumicMass;
    if (this.mass != null) finalString += mass;
    return finalString;
  }
}
