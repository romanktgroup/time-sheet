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
        date TEXT NOT NULL UNIQUE,
        hoursWorked REAL NOT NULL,
        ratePerHour REAL NOT NULL,
        comment TEXT
      )
      ''',
    );
  }

  Future<int> insertWorkDay(WorkDay workDay) async {
    final db = await database;

    final existingWorkDay = await db.query(
      'workdays',
      where: 'date = ?',
      whereArgs: [workDay.date.toIso8601String()],
    );

    if (existingWorkDay.isNotEmpty) {
      return await db.update(
        'workdays',
        workDay.toMap(),
        where: 'date = ?',
        whereArgs: [workDay.date.toIso8601String()],
      );
    } else {
      return await db.insert(
        'workdays',
        workDay.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<WorkDay>> getAllWorkDays() async {
    final db = await database;
    final List<Map<String, dynamic>> workDaysMap = await db.query('workdays');

    return workDaysMap.map((map) => WorkDay.fromMap(map)).toList();
  }

  Future<int> deleteWorkDayByDate(DateTime date) async {
    final db = await database;

    final formattedDate = date.toIso8601String().split('T').first;

    return await db.delete(
      'workdays',
      where: 'strftime("%Y-%m-%d", date) = ?',
      whereArgs: [formattedDate],
    );
  }
}
