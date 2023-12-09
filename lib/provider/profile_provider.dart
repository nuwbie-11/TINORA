import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tinora/model/profile_model.dart';

class ProfileProvider {
  static const _version = 1;
  static const _dbName = 'myDatabase.db';

  static Future<Database> initDatabases() async {
    String dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, _dbName),
      onOpen: (db) async {
        await db.execute(
          '''CREATE TABLE IF NOT EXISTS Profile(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              userId INTEGER NOT NULL,
              name TEXT NOT NULL,
              level INTEGER DEFAULT 0,
              experience REAL DEFAULT 0,
              FOREIGN KEY (userId) REFERENCES User(id) ON DELETE CASCADE
            )''',
        );
      },
      version: _version,
    );
  }

  static Future<void> addProfile(ProfileModel profile) async {
    final db = await initDatabases();
    await db.insert(
      'Profile',
      profile.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    db.close();
  }

  static Future<int> updateProfile(ProfileModel profile) async {
    final db = await initDatabases();
    return await db.update(
      'Profile',
      profile.toMap(),
      where: 'id = ?',
      whereArgs: [profile.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<int> deleteProfile(ProfileModel profile) async {
    final db = await initDatabases();
    return await db.delete(
      'Profile',
      where: 'id = ?',
      whereArgs: [profile.id],
    );
  }

  static Future<List<ProfileModel>?> getAllProfile() async {
    final db = await initDatabases();

    final List<Map<String, dynamic>> maps = await db.query("User");
    if (maps.isEmpty) {
      return null;
    }
    return List.generate(
        maps.length, (index) => ProfileModel.fromJson(maps[index]));
  }

  static Future<Map?> findProfile(int userId) async {
    final db = await initDatabases();

    List<Map> maps = await db.query(
      'Profile',
      where: 'userId=?',
      whereArgs: [userId],
    );

    // print(maps.first['id']);

    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }
}
