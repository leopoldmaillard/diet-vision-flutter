import 'package:transfer_learning_fruit_veggies/model/food.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseProvider {
  static const String TABLE_FOOD = "food";
  static const String COLUMN_ID = "id";
  static const String COLUMN_NAME = "name";

  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();

  // le ? et =null pour initialiser à null
  // plus tard on utilise les opérateurs ! pour le return à cause du futur
  Database? _database = null;

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
          "$COLUMN_NAME TEXT"
          ")",
        );
        print("food table created");
      },
    );
  }

  Future<List<Food>> getFoods() async {
    final db = await database;

    var foods = await db.query(TABLE_FOOD, columns: [COLUMN_ID, COLUMN_NAME]);

    List<Food> foodList = [];

    foods.forEach((currentFood) {
      Food food = Food.fromMap(currentFood);

      foodList.add(food);
    });

    return foodList;
  }

  Future<Food> insert(Food food) async {
    final db = await database;
    food.id = await db.insert(TABLE_FOOD, food.toMap());
    print("food id :");
    print(food.id);
    return food;
  }

  Future<int> delete(int id) async {
    final db = await database;

    return await db.delete(
      TABLE_FOOD,
      where: "id = ?",
      whereArgs: [id],
    );
  }

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
