import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tinora/model/user_model.dart';

class UserProvider {
  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();
  static const _version = 1;
  static const _dbName = 'myDatabase.db';

  static Future<Database> initDatabases() async {
    String dbPath = await getDatabasesPath();
    print(dbPath);
    return openDatabase(
      join(dbPath, _dbName),
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE User(id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT UNIQUE NOT NULL,password NOT NULL)",
        );
      },
      version: _version,
    );
  }

  static Future<int> addUser(UserModel user) async {
    final db = await initDatabases();
    return await db.insert(
      'User',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<int> updateUser(UserModel user) async {
    final db = await initDatabases();
    return await db.update(
      'User',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<int> deleteUser(UserModel user) async {
    final db = await initDatabases();
    return await db.delete(
      'User',
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  static Future<bool> authUser(String userName, String password) async {
    final db = await initDatabases();
    final SharedPreferences prefs = await _prefs;

    List<Map> maps = await db.query(
      'User',
      where: 'username=? AND password=?',
      whereArgs: [userName, password],
    );

    // print(maps.first['id']);

    if (maps.isNotEmpty) {
      prefs.setInt('user', maps.first['id']);
      return true;
    }
    return false;
  }

  static Future<List<UserModel>?> getAllUsers() async {
    final db = await initDatabases();

    final List<Map<String, dynamic>> maps = await db.query("User");
    print(maps.first);
    if (maps.isEmpty) {
      return null;
    }
    return List.generate(
        maps.length, (index) => UserModel.fromJson(maps[index]));
  }
}
