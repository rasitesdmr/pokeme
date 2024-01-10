import 'package:pokeme/models/alarm.dart';
import 'package:sqflite/sqflite.dart';

const String tableAlarm = 'alarm';
const String columnId = 'id';
const String columnTitle = 'title';
const String columnDateTime = 'alarmDateTime';
const String columnStatus = 'status';
const String columnColorIndex = 'gradientColorIndex';

class AlarmDatabaseManager {
  static Database? _database;
  static AlarmDatabaseManager? _alarmDatabaseManager;

  AlarmDatabaseManager._createInstance();
  factory AlarmDatabaseManager() {
    _alarmDatabaseManager ??= AlarmDatabaseManager._createInstance();
    return _alarmDatabaseManager!;
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
      version: 2,
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < 2) {
          // Eğer eski sürüm 1 ise, yeni sütunları ekleyin
          await db.execute(
              'ALTER TABLE $tableAlarm ADD COLUMN $columnStatus INTEGER');
        }
      },
      onCreate: (db, version) {
        db.execute('''
          create table $tableAlarm ( 
          $columnId integer primary key autoincrement, 
          $columnTitle text not null,
          $columnDateTime text not null,
          $columnStatus integer,
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
      for (var alarm in _alarms) {
        print(alarm.toMap());
      }
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
