import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:pokeme/models/todo.dart';

const String tableTodo = 'todo';
const String columnId = 'id';
const String columnTitle = 'title';
const String columnDateTime = 'alarmDateTime';
const String columnTodoStatus = 'todoStatus';
const String columnColorIndex = 'gradientColorIndex';
const String columnText1 = 'text1';
const String columnText1Status = 'text1Status';
const String columnText2 = 'text2';
const String columnText2Status = 'text2Status';
const String columnText3 = 'text3';
const String columnText3Status = 'text3Status';

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
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE $tableTodo ( 
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            title TEXT,
            alarmDateTime TEXT,
            todoStatus INTEGER,
            gradientColorIndex INTEGER,
            text1 TEXT,
            text1Status INTEGER,
            text2 TEXT,
            text2Status INTEGER,
            text3 TEXT,
            text3Status INTEGER)
        ''');
      },
    );
    return database;
  }

  Future<int> insertTodo(Todo todo) async {
    var db = await this.database;
    var result = await db.insert(tableTodo, todo.toMap());
    return result;
  }

  Future<List<Todo>> fetchAllTodos() async {
    var db = await this.database;
    var result = await db.query(tableTodo);
    List<Todo> todos =
        result.isNotEmpty ? result.map((c) => Todo.fromMap(c)).toList() : [];
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

  Future<int> deleteTodo(int id) async {
    var db = await this.database;
    var result = await db.delete(
      tableTodo,
      where: 'id = ?',
      whereArgs: [id],
    );
    return result;
  }
}
