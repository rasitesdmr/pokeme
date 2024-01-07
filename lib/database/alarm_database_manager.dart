import 'package:pokeme/models/alarm.dart';
import 'package:sqflite/sqflite.dart';

const String tableAlarm = 'alarm';
const String columnId = 'id';
const String columnTitle = 'title';
const String columnDateTime = 'alarmDateTime';
const String columnPending = 'isPending';
const String columnColorIndex = 'gradientColorIndex';

class AlarmDatabaseManager {
  static Database? _database;
  static AlarmDatabaseManager? _alarmHelper;

  AlarmDatabaseManager._createInstance();
  factory AlarmDatabaseManager() {
    _alarmHelper ??= AlarmDatabaseManager._createInstance();
    return _alarmHelper!;
  }

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    var dir = await getDatabasesPath();
    var path = "${dir}alarm.db";

    var database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          create table $tableAlarm ( 
          $columnId integer primary key autoincrement, 
          $columnTitle text not null,
          $columnDateTime text not null,
          $columnPending integer,
          $columnColorIndex integer)
        ''');
      },
    );
    return database;
  }

  void addAlarm(Alarm alarmInfo) async {
    var db = await database;
    var result = await db.insert(tableAlarm, alarmInfo.toMap());
    print(alarmInfo.alarmDateTime);
    print('result : $result');
  }

  Future<List<Alarm>> fetchAllAlarms() async {
    List<Alarm> _alarms = [];

    var db = await database;
    var result = await db.query(tableAlarm);
    for (var element in result) {
      var alarmInfo = Alarm.fromMap(element);
      _alarms.add(alarmInfo);
      print(_alarms.first.toMap());
    }

    return _alarms;
  }

  Future<int> deleteAlarmById(int? id) async {
    var db = await database;
    return await db.delete(tableAlarm, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> updateAlarm(Alarm alarmInfo) async {
    var db = await database;
    return await db.update(
      tableAlarm,
      alarmInfo.toMap(),
      where: '$columnId = ?',
      whereArgs: [alarmInfo.id],
    );
  }
}
