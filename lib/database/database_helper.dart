import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:time_sheet/model/work_day_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'timesheet.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE workdays (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        hoursWorked REAL NOT NULL,
        ratePerHour REAL NOT NULL,
        comment TEXT
      )
      ''',
    );
  }

  Future<int> insertWorkDay(WorkDay workDay) async {
    final db = await database;
    return await db.insert('workdays', workDay.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<WorkDay>> getAllWorkDays() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('workdays');

    return List.generate(maps.length, (i) {
      return WorkDay.fromMap(maps[i]);
    });
  }

  Future<int> deleteWorkDay(int id) async {
    final db = await database;
    return await db.delete('workdays', where: 'id = ?', whereArgs: [id]);
  }

  // Дополнительные методы для обновления, получения данных и т.д.
}
