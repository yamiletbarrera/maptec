import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SharedPreferences {
  int? id;
  String? data;
  bool? isDark;

  SharedPreferences({this.id, this.data, this.isDark});

  SharedPreferences.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    data = json['data'];
    isDark = json['isDark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['data'] = this.data;
    data['isDark'] = isDark;
    return data;
  }
}

class SharedPreferencesDB {
  dynamic _database;
  static final SharedPreferencesDB instance = SharedPreferencesDB._init();

  SharedPreferencesDB._init();

  //Get a reference to the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  //Create the database or open it if it already exists
  Future<Database> initDB() async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';

    return await openDatabase(join(await getDatabasesPath(), "maptec.db"),
        onCreate: (db, version) async {
      await db.execute(
          "CREATE TABLE spreferences(id $idType, isDark $boolType, data $textType)");
    }, version: 1);
  }

  //Create a new Record
  Future<void> insertSharedPreferences(SharedPreferences sp) async {
    final db = await instance.database;

    await db.insert(
      'spreferences',
      sp.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //Create all the Records
  Future<List<SharedPreferences>> readSharedPreferences() async {
    final db = await instance.database;
    try {
      List<Map<String, dynamic>> maps = await db.query('spreferences');
      if (maps.isNotEmpty) {
        return List.generate(maps.length, (i) {
          //return SharedPreferences.fromJson(maps[i]);
          return SharedPreferences(
            id: maps[i]['id'],
            data: maps[i]['data'],
            isDark: maps[i]['isDark'] == 0 ? false : true,
          );
        });
      }
    } catch (e) {
      return List.empty();
    }
    return List.empty();
  }

  //Update a Record
  Future<void> updateSharedPreferences(SharedPreferences sp) async {
    final db = await instance.database;

    try {
      await db.update(
        'spreferences',
        sp.toJson(),
        where: "id = ?",
        whereArgs: [sp.id],
      );
    } catch (e) {
      print(e);
    }
  }

  //Delete a Record
  Future<void> deleteSharedPreferences(int id) async {
    final db = await instance.database;

    try {
      await db.delete(
        'spreferences',
        where: "id = ?",
        whereArgs: [id],
      );
    } catch (e) {
      print(e);
    }
  }
}
