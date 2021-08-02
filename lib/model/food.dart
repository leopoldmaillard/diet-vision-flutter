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

    /// do not remove this line becasue the database cant autoincrement if
    /// we store it at 0
    if (id != 0) map[DatabaseProvider.COLUMN_ID] = id;
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

  String toString() {
    // String nameFood = 'nameFood : ' + this.nameFood + '\n';
    String volEstim = 'Volume : ' + this.volEstim.toString() + 'cm³' + '\n';
    String volumicMass =
        'Volumic mass : ' + (this.volumicMass / 10).toString() + '\n';
    String mass = 'mass food : ' + this.mass.toString() + '\n';
    String kal = this.kal.toString() + 'kcal\n';
    String protein = 'protein : ' + this.protein.toString() + 'g' + '\n';
    String carbohydrates =
        'carbohydrates : ' + this.carbohydrates.toString() + 'g' + '\n';
    String sugar = 'sugar : ' + this.sugar.toString() + 'g' + '\n';
    String fat = 'fat : ' + this.fat.toString() + 'g' + '\n';
    String finalString = (kal +
        volEstim +
        volumicMass +
        mass +
        protein +
        carbohydrates +
        sugar +
        fat);
    return finalString;
  }
}
