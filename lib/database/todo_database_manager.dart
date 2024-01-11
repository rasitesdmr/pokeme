import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:pokeme/models/todo.dart';

const String tableTodo = 'todo';
const String columnId = 'id';
const String columnTitle = 'title';
const String columnDateTime = 'alarmDateTime';
const String columnTodoStatus = 'todoStatus';
const String columnReminderDateTime = 'reminderDateTime';
const String columnText1 = 'text1';
const String columnText1Status = 'text1Status';
const String columnText2 = 'text2';
const String columnText2Status = 'text2Status';
const String columnText3 = 'text3';
const String columnText3Status = 'text3Status';
const String columnReminderAlarmId = 'reminderAlarmId';
const String columnAlarmDateTimeId = 'alarmDateTimeId';

class TodoDatabaseManager {
  static Database? _database;
  static TodoDatabaseManager? _todoDatabaseManager;

  TodoDatabaseManager._createInstance();
  factory TodoDatabaseManager() {
    _todoDatabaseManager ??= TodoDatabaseManager._createInstance();
    return _todoDatabaseManager!;
  }

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    var dir = await getDatabasesPath();
    var path = join(dir, "todo.db");

    var database = await openDatabase(
      path,
      version: 4,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableTodo ( 
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT, 
            $columnTitle TEXT,
            $columnDateTime TEXT,
            $columnTodoStatus INTEGER,
            $columnReminderDateTime TEXT,
            $columnText1 TEXT,
            $columnText1Status INTEGER,
            $columnText2 TEXT,
            $columnText2Status INTEGER,
            $columnText3 TEXT,
            $columnText3Status INTEGER,
            $columnReminderAlarmId INTEGER,
            $columnAlarmDateTimeId INTEGER)
        ''');
      },
    );
    return database;
  }

  Future<int> addTodo(Todo todo) async {
    var db = await this.database;
    var result = await db.insert(tableTodo, todo.toMap());
    print(todo.toMap());
    return result;
  }

  Future<List<Todo>> fetchAllTodos() async {
    var db = await this.database;
    var result = await db.query(tableTodo);
    List<Todo> todos =
        result.isNotEmpty ? result.map((c) => Todo.fromMap(c)).toList() : [];
    for (var todo in todos) {
      print(todo.toMap());
    }
    return todos;
  }

  Future<int> updateTodo(Todo todo) async {
    var db = await this.database;
    var result = await db.update(
      tableTodo,
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
    return result;
  }

  Future<int> deleteTodoById(int? id) async {
    var db = await this.database;
    var result = await db.delete(
      tableTodo,
      where: 'id = ?',
      whereArgs: [id],
    );
    return result;
  }

  Future<Todo?> getTodoByReminderAlarmId(int reminderAlarmId) async {
    var db = await this.database;
    List<Map> maps = await db.query(
      tableTodo,
      where: '$columnReminderAlarmId = ?',
      whereArgs: [reminderAlarmId],
    );

    if (maps.isNotEmpty) {
      // maps.first ifadesini Map<String, dynamic> türüne dönüştürün
      return Todo.fromMap(maps.first as Map<String, dynamic>);
    }

    return null;
  }

  Future<Todo?> getTodoByAlarmDateTimeId(int alarmDateTimeId) async {
    var db = await this.database;
    List<Map> maps = await db.query(
      tableTodo,
      where: '$columnAlarmDateTimeId = ?',
      whereArgs: [alarmDateTimeId],
    );

    if (maps.isNotEmpty) {
      // maps.first ifadesini Map<String, dynamic> türüne dönüştürün
      return Todo.fromMap(maps.first as Map<String, dynamic>);
    }

    return null;
  }

  Future<Todo?> getTodoById(int id) async {
    var db = await this.database;
    List<Map> maps = await db.query(
      tableTodo,
      where: '$columnId = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Todo.fromMap(maps.first as Map<String, dynamic>);
    }
    return null;
  }
}
