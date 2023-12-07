import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tinora/model/tasks_model.dart';

class TasksProvider {
  static const _version = 1;
  static const _dbName = 'myDatabase.db';

  static Future<Database> initDatabases() async {
    String dbPath = await getDatabasesPath();
    print(dbPath);
    return openDatabase(
      join(dbPath, _dbName),
      onOpen: (db) async {
        await db.execute(
          '''CREATE TABLE IF NOT EXISTS Task(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              description TEXT NOT NULL,
              deadline INTEGER,
              isImportant INTEGER DEFAULT 0,
              createdAt INTEGER
            )''',
        );
      },
      version: _version,
    );
  }

  static Future<int> addTasks(TasksModel task) async {
    final db = await initDatabases();
    print("this is ${db}");
    return await db.insert(
      'Task',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<int> updateTasks(TasksModel task) async {
    final db = await initDatabases();
    return await db.update(
      'Task',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<int> deleteTasks(TasksModel task) async {
    final db = await initDatabases();
    return await db.delete(
      'Task',
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  static Future<List<TasksModel>?> getAllTasks() async {
    final db = await initDatabases();

    final List<Map<String, dynamic>> maps = await db.query("Task");
    if (maps.isEmpty) {
      return null;
    }
    return List.generate(
        maps.length, (index) => TasksModel.fromJson(maps[index]));
  }

  static Future<Map?> findTasks(int taskId) async {
    final db = await initDatabases();

    List<Map> maps = await db.query(
      'Task',
      where: 'userId=?',
      whereArgs: [taskId],
    );

    // print(maps.first['id']);

    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }
}
