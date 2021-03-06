import 'package:transfer_learning_fruit_veggies/services/local_storage_service.dart';
import 'dart:math';

// 2 significatif numbers after dots
double roundDouble(double value, int places) {
  double mod = pow(10.0, places).toDouble();
  return ((value * mod).round().toDouble() / mod);
}

class Food {
  // static int cpt = 0;
  int id = 0;
  String nameFood = '';
  String nameUpdated = '';
  String nutriscore = '';
  int volEstim = 0;
  double volumicMass = 0;
  double mass = 0;
  double kal = 0;
  double protein = 0;
  double carbohydrates = 0;
  double sugar = 0;
  double fat = 0;
  int dateSinceEpoch = 0;

  Food({required this.nameFood});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{DatabaseProvider.COLUMN_NAMEFOOD: nameFood};

    /// do not remove this line becasue the database cant autoincrement if
    /// we store it at 0
    //map[DatabaseProvider.COLUMN_ID] = id;
    print(nameFood);
    map[DatabaseProvider.COLUMN_NAMEFOOD] =
        (nameFood == '' ? "Meal" : nameFood);
    map[DatabaseProvider.COLUMN_NUTRISCORE] = nutriscore;
    map[DatabaseProvider.COLUMN_MASS] = mass;
    map[DatabaseProvider.COLUMN_KAL] = kal;
    map[DatabaseProvider.COLUMN_PROTEIN] = protein;
    map[DatabaseProvider.COLUMN_CARBOHYDRATES] = carbohydrates;
    map[DatabaseProvider.COLUMN_SUGAR] = sugar;
    map[DatabaseProvider.COLUMN_FAT] = fat;
    map[DatabaseProvider.COLUMN_VOLESTIM] = volEstim;
    map[DatabaseProvider.COLUMN_VOLUMICMASS] = volumicMass;
    map[DatabaseProvider.COLUMN_DATE] = dateSinceEpoch;
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
    dateSinceEpoch = map[DatabaseProvider.COLUMN_DATE];
  }

  String toString() {
    // String nameFood = 'nameFood : ' + this.nameFood + '\n';
    String volEstim = 'Volume : ' + this.volEstim.toString() + ' cm??' + '\n';
    String volumicMass = 'Volumic mass : ' +
        (roundDouble(this.volumicMass, 2)).toString() +
        ' g\n';
    String mass =
        'mass food : ' + roundDouble(this.mass, 2).toString() + ' g\n';
    String kal = roundDouble(this.kal, 2).toString() + ' kcal\n';
    String protein =
        'protein : ' + roundDouble(this.protein, 2).toString() + ' g' + '\n';
    String carbohydrates = 'carbohydrates : ' +
        roundDouble(this.carbohydrates, 2).toString() +
        ' g' +
        '\n';
    String sugar =
        'sugar : ' + roundDouble(this.sugar, 2).toString() + ' g' + '\n';
    String fat = 'fat : ' + roundDouble(this.fat, 2).toString() + ' g' + '\n';

    String date = 'date : ' + datetoString() + '\n';
    String hour = 'hour : ' + dateHourtoString() + '\n';
    //full format date : date + hour
    // String date = 'date : ' +
    //     DateTime.fromMillisecondsSinceEpoch(dateSinceEpoch).toString() +
    //     '\n';
    //format in millisecond from epoch of the date
    // String date = 'date:' + dateSinceEpoch.toString() + '\n';
    String finalString =
        (kal + volEstim + protein + carbohydrates + sugar + fat + date + hour);
    // pour moi pas de sens de mettre la masse volumique d'un repas
    // if (this.volumicMass != null) finalString += volumicMass;
    if (this.mass != null) finalString += mass;
    return finalString;
  }

  String datetoString() {
    var mydate = DateTime.fromMillisecondsSinceEpoch(dateSinceEpoch);
    String y = mydate.year.toString();
    String m = mydate.month.toString();
    String d = mydate.day.toString();
    return "$y-$m-$d";
  }

  String dateHourtoString() {
    var mydate = DateTime.fromMillisecondsSinceEpoch(dateSinceEpoch);
    String h = mydate.hour.toString();
    String m = mydate.minute.toString();
    String s = mydate.second.toString();
    return "$h:$m:$s";
  }
}
