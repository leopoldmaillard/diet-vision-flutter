import 'package:transfer_learning_fruit_veggies/model/food.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseProvider {
  static const String TABLE_FOOD = "food";
  static const String COLUMN_VOLESTIM = "volume Estimation";
  static const String COLUMN_VOLUMICMASS = "volumic mass";
  static const String COLUMN_ID = "id";
  static const String COLUMN_NAMEFOOD = "nameFood";
  static const String COLUMN_NUTRISCORE = "nutriscore";
  static const String COLUMN_MASS = "mass";
  static const String COLUMN_KAL = "kal";
  static const String COLUMN_PROTEIN = "protein";
  static const String COLUMN_CARBOHYDRATES = "carbohydrates";
  static const String COLUMN_SUGAR = "sugar";
  static const String COLUMN_FAT = "fat";

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
      // print(_database.toString());
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
          "$COLUMN_VOLUMICMASS INTEGER,"
          "$COLUMN_NUTRISCORE TEXT,"
          "$COLUMN_MASS INTEGER,"
          "$COLUMN_KAL INTEGER,"
          "$COLUMN_PROTEIN INTEGER,"
          "$COLUMN_CARBOHYDRATES INTEGER,"
          "$COLUMN_SUGAR INTEGER,"
          "$COLUMN_FAT INTEGER,"
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
      COLUMN_NUTRISCORE,
      COLUMN_MASS,
      COLUMN_KAL,
      COLUMN_PROTEIN,
      COLUMN_CARBOHYDRATES,
      COLUMN_SUGAR,
      COLUMN_FAT,
    ]);

    List<Food> foodList = [];

    foods.forEach((currentFood) {
      Food food = Food.fromMap(currentFood);

      foodList.add(food);
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
