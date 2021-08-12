//class Food
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

  Food({
    required this.nameFood,
    required this.id,
    required this.kal,
    required this.protein,
    required this.carbohydrates,
    required this.sugar,
    required this.fat,
  });

  String toString() {
    String nameFood = 'nameFood : ' + this.nameFood + '\n';
    // String volEstim = 'Volume : ' + this.volEstim.toString() + 'cm³' + '\n';
    // String volumicMass =
    //     'Volumic mass : ' + (this.volumicMass).toString() + '\n';
    // String mass = 'mass food : ' + this.mass.toString() + '\n';
    String kal = this.kal.toString() + 'kcal\n';
    // String protein = 'protein : ' + this.protein.toString() + 'g' + '\n';
    // String carbohydrates =
    //     'carbohydrates : ' + this.carbohydrates.toString() + 'g' + '\n';
    // String sugar = 'sugar : ' + this.sugar.toString() + 'g' + '\n';
    // String fat = 'fat : ' + this.fat.toString() + 'g' + '\n';
    String finalString =
        (nameFood + kal); //+ volEstim + protein + carbohydrates + sugar + fat);
    // pour moi pas de sens de mettre la masse volumique d'un repas
    // if (this.volumicMass != null) finalString += volumicMass;
    // if (this.mass != null) finalString += mass;
    return finalString;
  }
}
