import 'dart:io';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:android_intent/android_intent.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pokeme/database/alarm_database_manager.dart';
import 'package:pokeme/models/alarm.dart';
import 'package:pokeme/notifications/alarm_notification_manager.dart';
import 'package:pokeme/styles/app_color_palette.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  DateTime? _alarmTime;
  late String _alarmTimeString;
  int? _alarmStatus = 0;
  AlarmDatabaseManager _alarmDatabaseManager = AlarmDatabaseManager();
  Future<List<Alarm>>? _alarms;
  List<Alarm>? _currentAlarms;
  late String _selectedTitle;
  static String selectedSoundPath = 'alarm_sound';
  File? selectedMusicFile;

  @override
  void initState() {
    _alarmTime = DateTime.now();
    _alarmDatabaseManager.initializeDatabase().then((value) {
      loadAlarms();
    });
    listenToNotifications();
    super.initState();
  }

  listenToNotifications() {
    print("Listening to notification");
    AlarmNotificationManager.onClickNotification.stream.listen((event) {
      print(event);
      Navigator.pushNamed(context, '/another', arguments: event);
    });
  }

  void loadAlarms() {
    _alarms = _alarmDatabaseManager.fetchAllAlarms();
    if (mounted) setState(() {});
  }

  void openAlarmBottomSheet({Alarm? selectedAlarm}) {
    _alarmTimeString = selectedAlarm != null
        ? DateFormat('HH:mm').format(selectedAlarm.alarmDateTime!)
        : DateFormat('HH:mm').format(DateTime.now());
    _selectedTitle = selectedAlarm?.title ?? '';
    showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  TextButton(
                    onPressed: () async {
                      final now = DateTime.now();

                      final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedAlarm?.alarmDateTime ?? now,
                          firstDate: now,
                          lastDate: DateTime(2101),
                          locale: const Locale('tr', 'TR'));

                      var selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                        builder: (BuildContext context, Widget? child) {
                          return MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(alwaysUse24HourFormat: true),
                            child: child!,
                          );
                        },
                      );
                      if (selectedTime != null) {
                        var selectedDateTime = DateTime(
                          selectedDate!.year,
                          selectedDate.month,
                          selectedDate.day,
                          selectedTime.hour,
                          selectedTime.minute,
                        );
                        _alarmTime = selectedDateTime;
                        setModalState(
                          () {
                            _alarmTimeString =
                                DateFormat('HH:mm').format(selectedDateTime);
                          },
                        );
                      }
                    },
                    child: Text(
                      _alarmTimeString,
                      style: TextStyle(fontSize: 32),
                    ),
                  ),
                  ListTile(
                    title: Text('Repeat'),
                    trailing: Switch(
                      onChanged: (value) {
                        setModalState(() {
                          _alarmStatus = value == true ? 1 : 0;
                        });
                      },
                      value: _alarmStatus == 1 ? true : false,
                    ),
                  ),
                  ListTile(
                    title: Text('Sound'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () async {},
                  ),
                  ListTile(
                    title: Text('Title'),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // Başlık düzenleme işlemi burada
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Edit Title'),
                              content: TextField(
                                onChanged: (value) {
                                  _selectedTitle = value;
                                },
                                controller:
                                    TextEditingController(text: _selectedTitle),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    setModalState(() {});
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                  FloatingActionButton.extended(
                    onPressed: () {
                      onSaveAlarm(selectedAlarm);
                    },
                    icon: Icon(Icons.alarm),
                    label: Text(selectedAlarm == null ? 'Save' : 'Update'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void onSaveAlarm(Alarm? selectedAlarm) {
    DateTime now = DateTime.now();
    DateTime scheduleAlarmDateTime;

    if (_alarmTime!.isAfter(now)) {
      scheduleAlarmDateTime = _alarmTime!;
    } else {
      scheduleAlarmDateTime = _alarmTime!.add(Duration(days: 1));
    }

    var alarmInfo = Alarm(
      alarmDateTime: scheduleAlarmDateTime,
      gradientColorIndex: _currentAlarms!.length,
      title: _selectedTitle,
      status: _alarmStatus,
    );

    if (selectedAlarm == null) {
      _alarmDatabaseManager.addAlarm(alarmInfo);
    } else {
      selectedAlarm.alarmDateTime = scheduleAlarmDateTime;
      selectedAlarm.title = _selectedTitle;
      _alarmDatabaseManager.updateAlarm(selectedAlarm);
    }

    Navigator.pop(context);
    loadAlarms();
    scheduleAlarm(scheduleAlarmDateTime); // Alarmı zamanla
  }

  void deleteAlarm(int? id) {
    _alarmDatabaseManager.deleteAlarmById(id);
    loadAlarms();
  }

  Future<void> scheduleAlarm(DateTime scheduledNotificationDateTime) async {
    var alarmId =
        0; // Bu ID'yi her alarm için benzersiz olacak şekilde ayarlayın.
    await AndroidAlarmManager.oneShotAt(
      scheduledNotificationDateTime,
      alarmId,
      alarmCallback,
      exact: true,
      wakeup: true,
    );
  }

  @pragma('vm:entry-point')
  static void alarmCallback() {
    AlarmNotificationManager.displayAlarmWithAction(
      title: "Alarm",
      body: "Alarmınız çalıyor!",
      payload: 'Alarm Payload',
      customSoundPath: selectedSoundPath,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Alarm',
            style: TextStyle(
                fontFamily: 'avenir',
                fontWeight: FontWeight.w700,
                color: AppColorPalette.primaryTextColor,
                fontSize: 24),
          ),
          Expanded(
            child: FutureBuilder<List<Alarm>>(
              future: _alarms,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _currentAlarms = snapshot.data;
                  return ListView(
                    children: snapshot.data!.map<Widget>((alarm) {
                      var alarmTime =
                          DateFormat('HH:mm').format(alarm.alarmDateTime!);
                      var gradientColor = GradientTemplate
                          .gradientTemplate[alarm.gradientColorIndex!].colors;
                      return Slidable(
                        key: Key(alarm.id.toString()),
                        endActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          extentRatio: 0.25,
                          children: [
                            SlidableAction(
                              onPressed: (BuildContext context) =>
                                  deleteAlarm(alarm.id),
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                              flex: 2,
                              borderRadius: BorderRadius.circular(30),
                              spacing: 4,
                              autoClose: true,
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: () =>
                              openAlarmBottomSheet(selectedAlarm: alarm),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: gradientColor,
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: gradientColor.last.withOpacity(0.4),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                  offset: Offset(4, 4),
                                ),
                              ],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      alarmTime,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'avenir',
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.label,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          alarm.title!,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'avenir'),
                                        ),
                                      ],
                                    ),
                                    Switch(
                                      onChanged: (bool value) {},
                                      value: alarm.status == 1 ? true : false,
                                      activeColor: Colors.white,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).followedBy([
                      DottedBorder(
                        strokeWidth: 2,
                        color: AppColorPalette.clockOutline,
                        borderType: BorderType.RRect,
                        radius: Radius.circular(24),
                        dashPattern: [5, 4],
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColorPalette.clockBG,
                            borderRadius: BorderRadius.all(Radius.circular(24)),
                          ),
                          child: MaterialButton(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            onPressed: () => openAlarmBottomSheet(),
                            child: Column(
                              children: <Widget>[
                                Image.asset(
                                  'assets/add_alarm.png',
                                  scale: 1.5,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Add Alarm',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'avenir'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ]).toList(),
                  );
                }
                return Center(
                  child: Text(
                    'Loading..',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
