import 'package:transfer_learning_fruit_veggies/model/food.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

/// truc à ameliorer
/// la possibilite de mettre des doubles dans une database
/// faire une database pour la page statistics et faire en sorte qu'on
/// puisse récupérer les kcal de chaque food et les sommer par jour
/// -rajouter un argument date dans la bdd pour faire le point précédent
class DatabaseProvider {
  static const String TABLE_FOOD = "food";
  static const String COLUMN_ID = "id";
  static const String COLUMN_NAMEFOOD = "nameFood";
  static const String COLUMN_VOLESTIM = "volumeEstimation";
  static const String COLUMN_VOLUMICMASS = "volumicMass";
  static const String COLUMN_MASS = "mass";
  static const String COLUMN_NUTRISCORE = "nutriscore";
  static const String COLUMN_KAL = "kal";
  static const String COLUMN_PROTEIN = "protein";
  static const String COLUMN_CARBOHYDRATES = "carbohydrates";
  static const String COLUMN_SUGAR = "sugar";
  static const String COLUMN_FAT = "fat";
  static const String COLUMN_DATE = "date";

  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();

  // le ? et =null pour initialiser à null
  // plus tard on utilise les opérateurs ! pour le return à cause du futur
  Database? _database = null;

  /// methode get de la base de donnée
  Future<Database> get database async {
    print("database getter called");

    if (_database != null) {
      print("database already created and returned");
      print(_database.toString());
      return _database!;
    }

    _database = await createDatabase();

    return _database!;
  }

  /// creation of both the database file and the table
  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, 'foodDB.db'),
      version: 1,
      onCreate: (Database database, int version) async {
        print("Creating food table");

        await database.execute(
          "CREATE TABLE $TABLE_FOOD ("
          "$COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"
          "$COLUMN_NAMEFOOD TEXT,"
          "$COLUMN_VOLESTIM INTEGER,"
          "$COLUMN_VOLUMICMASS REAL,"
          "$COLUMN_NUTRISCORE TEXT,"
          "$COLUMN_MASS REAL,"
          "$COLUMN_KAL REAL,"
          "$COLUMN_PROTEIN REAL,"
          "$COLUMN_CARBOHYDRATES REAL,"
          "$COLUMN_SUGAR REAL,"
          "$COLUMN_FAT REAL,"
          "$COLUMN_DATE INTEGER"
          ")",
        );
        print("Food table created");
      },
    );
  }

  /// execute a query for the table of table food (all the table)
  /// and add to the foodlist all elements from the requests
  /// return a List<Food>
  Future<List<Food>> getFoods() async {
    final db = await database;

    var foods = await db.query(TABLE_FOOD, columns: [
      COLUMN_ID,
      COLUMN_NAMEFOOD,
      COLUMN_VOLESTIM,
      COLUMN_VOLUMICMASS,
      COLUMN_NUTRISCORE,
      COLUMN_MASS,
      COLUMN_KAL,
      COLUMN_PROTEIN,
      COLUMN_CARBOHYDRATES,
      COLUMN_SUGAR,
      COLUMN_FAT,
      COLUMN_DATE,
    ]);
    List<Map> myquery = await db.rawQuery('SELECT * FROM ' + TABLE_FOOD);

    List<Food> foodList = [];

    foods.forEach((currentFood) {
      Food food = Food.fromMap(currentFood);

      foodList.add(food);
    });

    return foodList;
  }

  Future<List<Food>> get15minFoods() async {
    var currentDate = new DateTime.now().millisecondsSinceEpoch;
    var dateLastWeek = currentDate - 42 * 60 * 1000;
    final db = await database;
    var myquery = await db.rawQuery('SELECT * FROM ' +
        TABLE_FOOD +
        ' WHERE ' +
        COLUMN_DATE +
        '>= ' +
        dateLastWeek.toString());

    List<Food> foodList = [];

    myquery.forEach((currentFood) {
      Food food = Food.fromMap(currentFood);
      foodList.add(food);
    });
    print("food list :");
    print(foodList);
    return foodList;
  }

//    var moonLanding = DateTime.parse(lastMidnight.toString());
// print("Current date");
//     print(currentDate);
//     print(currentDate.millisecondsSinceEpoch);
  DateTime lastMidnight() {
    var currentDate = new DateTime.now();
    var lastMidnight =
        DateTime(currentDate.year, currentDate.month, currentDate.day);
    return lastMidnight;
  }

  Future<List<Food>> getTodayFoods() async {
    final db = await database;
    var currentMidnight = lastMidnight().millisecondsSinceEpoch;

    var myquery = await db.rawQuery('SELECT * FROM ' +
        TABLE_FOOD +
        ' WHERE ' +
        COLUMN_DATE +
        '>= ' +
        currentMidnight.toString());
    print(myquery);
    List<Food> foodList = [];

    myquery.forEach((currentFood) {
      Food food = Food.fromMap(currentFood);
      foodList.add(food);
    });
    return foodList;
  }

  Future<List<Food>> getWeekFoods() async {
    var currentDate = new DateTime.now().millisecondsSinceEpoch;
    var dateLastWeek = currentDate - 7 * 24 * 3600 * 1000;
    final db = await database;
    var myquery = await db.rawQuery('SELECT * FROM ' +
        TABLE_FOOD +
        'WHERE ' +
        COLUMN_DATE +
        '>= ' +
        dateLastWeek.toString());

    List<Food> foodList = [];

    myquery.forEach((currentFood) {
      Food food = Food.fromMap(currentFood);
      // if ((food.dateSinceEpoch <= currentDate) &&
      //     (currentDate - food.dateSinceEpoch <= 7 * 24 * 3600 * 1000)) {
      foodList.add(food);
      //}
    });
    return foodList;
  }

  Future<List<Food>> getMonthFoods() async {
    var currentDate = new DateTime.now().millisecondsSinceEpoch;
    var dateLastWeek = currentDate - 30 * 7 * 24 * 3600 * 1000;
    final db = await database;
    var myquery = await db.rawQuery('SELECT * FROM ' +
        TABLE_FOOD +
        'WHERE ' +
        COLUMN_DATE +
        '>= ' +
        dateLastWeek.toString());

    List<Food> foodList = [];

    myquery.forEach((currentFood) {
      Food food = Food.fromMap(currentFood);
      // if ((food.dateSinceEpoch <= currentDate) &&
      //     (currentDate - food.dateSinceEpoch <= 7 * 24 * 3600 * 1000)) {
      foodList.add(food);
      //}
    });
    return foodList;
  }

  /// insert a food element (by using its map) into the database
  /// return Food inserted element
  Future<Food> insert(Food food) async {
    final db = await database;
    food.id = await db.insert(TABLE_FOOD, food.toMap());
    print("food id : ${food.id} added to the table");
    // print(food.id);
    return food;
  }

  /// return the nb of lines that are deleted if the method is sucessful,
  ///  0 if it didnt find any match
  /// param :
  ///  id ==> id to delete
  Future<int> delete(int id) async {
    final db = await database;
    //the ? will be replace by the id from whereArgs
    print("food id : ${id} deleted from the table");
    return await db.delete(
      TABLE_FOOD,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  /// param :
  /// -food : it is the value that will be replaced into the database
  /// we update this food.id by this value : food.toMap()
  Future<int> update(Food food) async {
    final db = await database;

    return await db.update(
      TABLE_FOOD,
      food.toMap(),
      where: "id = ?",
      whereArgs: [food.id],
    );
  }
}
