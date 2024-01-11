import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pokeme/database/todo_database_manager.dart';
import 'package:pokeme/models/todo.dart';
import 'package:pokeme/notifications/alarm_notification_manager.dart';
import 'package:pokeme/screens/todo_details_screen.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  late String _selectedTodoTitle;
  late int _selectedTodoStatus = 0;
  late String _selectedText1;
  late String _selectedText2;
  late String _selectedText3;
  late int _selectedText1Status;
  late int _selectedText2Status;
  late int _selectedText3Status;
  late int _selectedReminderAlarmId;
  late int _selectedalarmDateTimeId;
  int count = 1;
  int count2 = 300;

  late String _alarmTimeString;
  late String _reminderAlarmTimeString;
  DateTime? _alarmTime;
  DateTime? _reminderTime;

  static String selectedSoundPath = 'alarm_sound';

  TodoDatabaseManager _todoDatabaseManager = TodoDatabaseManager();
  Future<List<Todo>>? _futureTodos;
  List<Todo>? _todos;

  late List<bool> _expandedList;

  @override
  void initState() {
    super.initState();
    _todoDatabaseManager.initializeDatabase().then(
      (value) {
        loadTodos();
      },
    );
    listenToNotifications();
    super.initState();
  }

  Future<void> loadTodos() async {
    _futureTodos = _todoDatabaseManager.fetchAllTodos();
    List<Todo> fetchedTodos = await _todoDatabaseManager.fetchAllTodos();

    if (mounted) {
      setState(
        () {
          _expandedList = List.generate(fetchedTodos.length, (index) => false);
        },
      );
    }
  }

  // Kaydetme bottom sheet
  void openTodoBottomSheet({Todo? selectedTodo}) {
    _selectedTodoTitle = selectedTodo?.title ?? '';
    _selectedText1 = selectedTodo?.text1 ?? '';
    _selectedText2 = selectedTodo?.text2 ?? '';
    _selectedText3 = selectedTodo?.text3 ?? '';

    List<int> reminderOptions = [
      5,
      10,
      15,
      20
    ]; // Dakika cinsinden hatırlatma seçenekleri
    int selectedReminder = 5; // Varsayılan olarak seçilen hatırlatma süresi

    _alarmTimeString = selectedTodo != null
        ? DateFormat('HH:mm').format(selectedTodo.alarmDateTime!)
        : DateFormat('HH:mm').format(DateTime.now());
    showModalBottomSheet(
      useRootNavigator: true,
      isScrollControlled: true,
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
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () async {
                            final now = DateTime.now();

                            final selectedDate = await showDatePicker(
                                context: context,
                                initialDate: selectedTodo?.alarmDateTime ?? now,
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
                                  _alarmTimeString = DateFormat('HH:mm')
                                      .format(selectedDateTime);
                                },
                              );
                            }
                          },
                          child: Text(
                            _alarmTimeString,
                            style: TextStyle(fontSize: 32),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ---------------------------------------

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Başlık: $_selectedTodoTitle',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Başlık düzenleme işlemi burada
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Başlık'),
                                  content: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: TextField(
                                      onChanged: (value) {
                                        _selectedTodoTitle = value;
                                      },
                                      controller: TextEditingController(
                                        text: _selectedTodoTitle,
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Başlık Ekle',
                                      ),
                                    ),
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
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Görev 1: $_selectedText1',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Başlık düzenleme işlemi burada
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Görev Ekle'),
                                  content: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: TextField(
                                      onChanged: (value) {
                                        _selectedText1 = value;
                                      },
                                      controller: TextEditingController(
                                        text: _selectedText1,
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Görev 1',
                                      ),
                                    ),
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
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Görev 2: $_selectedText2',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Başlık düzenleme işlemi burada
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Görev Ekle'),
                                  content: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: TextField(
                                      onChanged: (value) {
                                        _selectedText2 = value;
                                      },
                                      controller: TextEditingController(
                                        text: _selectedText2,
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Görev 2',
                                      ),
                                    ),
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
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Görev 3: $_selectedText3',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Başlık düzenleme işlemi burada
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Görev Ekle'),
                                  content: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: TextField(
                                      onChanged: (value) {
                                        _selectedText3 = value;
                                      },
                                      controller: TextEditingController(
                                        text: _selectedText3,
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Görev 3',
                                      ),
                                    ),
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
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        isExpanded: true,
                        value: selectedReminder,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        onChanged: (int? newValue) {
                          if (newValue != null) {
                            setModalState(() {
                              selectedReminder = newValue;
                              if (_alarmTime != null) {
                                _reminderTime = _alarmTime!
                                    .subtract(Duration(minutes: newValue));
                                _reminderAlarmTimeString =
                                    DateFormat('HH:mm').format(_reminderTime!);
                              }
                            });
                          }
                        },
                        items: reminderOptions
                            .map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text('$value dakika önce'),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FloatingActionButton.extended(
                    onPressed: () {
                      onSaveTodo(selectedTodo: selectedTodo);
                    },
                    icon: Icon(Icons.alarm),
                    label: Text('Save'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void onSaveTodo({Todo? selectedTodo}) {
    DateTime now = DateTime.now();
    DateTime scheduleAlarmDateTime;
    DateTime scheduleReminderDateTime;

    if (_alarmTime!.isAfter(now)) {
      scheduleAlarmDateTime = _alarmTime!;
    } else {
      scheduleAlarmDateTime = _alarmTime!.add(Duration(days: 1));
    }

    scheduleReminderDateTime = _reminderTime!;

    _selectedReminderAlarmId = count;
    final int reminderAlarmId = _selectedReminderAlarmId;
    count++;

    _selectedalarmDateTimeId = count2;
    final int alarmDateTimeId = _selectedalarmDateTimeId;
    count2++;

    var todoInfo = Todo(
      title: _selectedTodoTitle,
      todoStatus: _selectedTodoStatus,
      text1: _selectedText1,
      text2: _selectedText2,
      text3: _selectedText3,
      alarmDateTime: scheduleAlarmDateTime,
      reminderDateTime: _reminderTime,
      text1Status: 0,
      text2Status: 0,
      text3Status: 0,
      reminderAlarmId: _selectedReminderAlarmId,
      alarmDateTimeId: _selectedalarmDateTimeId,
    );

    if (selectedTodo == null) {
      _todoDatabaseManager.addTodo(todoInfo);
    }
    Navigator.pop(context);
    loadTodos();

    scheduleAlarm(scheduleAlarmDateTime, alarmDateTimeId);
    scheduleReminder(scheduleReminderDateTime, reminderAlarmId);
  }

  void updateTodo(Todo todo) {
    var todoInfo = Todo(
      id: todo.id,
      title: todo.title,
      todoStatus: todo.todoStatus,
      text1: todo.text1,
      text2: todo.text2,
      text3: todo.text3,
      alarmDateTime: todo.alarmDateTime,
      text1Status: _selectedText1Status,
      text2Status: _selectedText2Status,
      text3Status: _selectedText3Status,
    );
    _todoDatabaseManager.updateTodo(todoInfo);
    Navigator.pop(context);
    loadTodos();
  }

  void deleteTodo(int? id) {
    _todoDatabaseManager.deleteTodoById(id);
    Navigator.pop(context);
    loadTodos();
  }

  Widget buildExpandableContent(Todo todo) {
    List<Widget> contentList = [];

    if (todo.text1 != null && todo.text1!.isNotEmpty) {
      contentList.add(buildTaskItem(todo.text1, todo.text1Status));
    }
    if (todo.text2 != null && todo.text2!.isNotEmpty) {
      contentList.add(buildTaskItem(todo.text2, todo.text2Status));
    }
    if (todo.text3 != null && todo.text3!.isNotEmpty) {
      contentList.add(buildTaskItem(todo.text3, todo.text3Status));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: contentList,
    );
  }

  Widget buildTaskItem(String? text, int? status) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            status == 1 ? Icons.check_circle : Icons.radio_button_unchecked,
            color: status == 1 ? Colors.green : Colors.grey,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text ?? '',
              style: TextStyle(
                color: Colors.black,
                decoration: status == 1 ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  listenToNotifications() {
    print("Listening to notification");
    AlarmNotificationManager.onClickNotification.stream.listen((event) {
      print(event);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TodoDetailsScreen(payload: event),
        ),
      );
    });
  }

  Future<void> scheduleAlarm(
      DateTime scheduledNotificationDateTime, int alarmDateTimeId) async {
    await AndroidAlarmManager.oneShotAt(
      scheduledNotificationDateTime,
      alarmDateTimeId,
      alarmCallback,
      exact: true,
      wakeup: true,
    );
  }

  @pragma('vm:entry-point')
  static Future<void> alarmCallback(int alarmDateTimeId) async {
    TodoDatabaseManager todoDatabaseManager = TodoDatabaseManager();
    var todo =
        await todoDatabaseManager.getTodoByAlarmDateTimeId(alarmDateTimeId);

    AlarmNotificationManager.displayAlarmWithAction(
      title: todo!.title!,
      body: "Todo Zamanı",
      payload: 'Alarm Payload',
      customSoundPath: selectedSoundPath,
    );
  }

  Future<void> scheduleReminder(
      DateTime scheduledNotificationDateTime, int reminderAlarmId) async {
    await AndroidAlarmManager.oneShotAt(
      scheduledNotificationDateTime,
      reminderAlarmId,
      alarmReminderCallback,
      exact: true,
      wakeup: true,
    );
  }

  @pragma('vm:entry-point')
  static Future<void> alarmReminderCallback(int reminderAlarmId) async {
    TodoDatabaseManager todoDatabaseManager = TodoDatabaseManager();
    var todo =
        await todoDatabaseManager.getTodoByReminderAlarmId(reminderAlarmId);

    AlarmNotificationManager.sendReminderTodoNotification(
      title: todo!.title!,
      body: "Todo Zamanı",
      payload: 'todoId:${todo.id}',
    );
  }

  // Düzenleme status bottom sheet
  void openTextStatusBottomSheet({Todo? selectedTodo}) {
    if (selectedTodo != null) {
      _selectedText1Status = selectedTodo.text1Status!;
      _selectedText2Status = selectedTodo.text2Status!;
      _selectedText3Status = selectedTodo.text3Status!;
    } else {
      _selectedText1Status = 0;
      _selectedText2Status = 0;
      _selectedText3Status = 0;
    }

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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          '${selectedTodo!.alarmDateTime?.day}/${selectedTodo!.alarmDateTime?.month}/${selectedTodo!.alarmDateTime?.year}'),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                          '${selectedTodo!.alarmDateTime?.hour}:${selectedTodo!.alarmDateTime?.minute}'),
                    ],
                  ),
                  if (selectedTodo?.text1?.isNotEmpty == true)
                    buildStatusItem('Görev 1 : ${selectedTodo?.text1}',
                        _selectedText1Status, (newValue) {
                      _selectedText1Status = newValue;
                      setModalState(() {});
                    }),
                  if (selectedTodo?.text2?.isNotEmpty == true)
                    buildStatusItem('Görev 2 : ${selectedTodo?.text2}',
                        _selectedText2Status, (newValue) {
                      _selectedText2Status = newValue;
                      setModalState(() {});
                    }),
                  if (selectedTodo?.text3?.isNotEmpty == true)
                    buildStatusItem(
                      'Görev 3 : ${selectedTodo?.text3}',
                      _selectedText3Status,
                      (newValue) {
                        _selectedText3Status = newValue;
                        setModalState(() {});
                      },
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        child: Text('Delete',
                            style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(primary: Colors.red),
                        onPressed: () {
                          deleteTodo(selectedTodo?.id);
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        child:
                            Text('Save', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(primary: Colors.blue),
                        onPressed: () {
                          updateTodo(selectedTodo!);
                        },
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget buildStatusItem(
      String title, int status, Function(int) onStatusChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Switch(
          activeTrackColor: Colors.green,
          value: status == 1,
          onChanged: (bool newValue) {
            onStatusChanged(newValue ? 1 : 0);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Todo',
                  style: TextStyle(
                      fontFamily: 'avenir',
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 24),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.add, color: Colors.white),
                    onPressed: () => openTodoBottomSheet(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Todo>>(
              future: _futureTodos,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  _todos = snapshot.data;
                  return ListView.builder(
                    itemCount: _todos!.length,
                    itemBuilder: (context, index) {
                      final Todo? todo = _todos![index];

                      // Kartın rengini belirle
                      Color cardColor = Colors.white; // Varsayılan kart rengi
                      bool isCompleted = false;

                      if ((todo?.text1?.isNotEmpty == true &&
                              todo?.text1Status == 1) ||
                          (todo?.text2?.isNotEmpty == true &&
                              todo?.text2Status == 1) ||
                          (todo?.text3?.isNotEmpty == true &&
                              todo?.text3Status == 1)) {
                        isCompleted = true;
                      }

                      // Tüm metin alanlarının boş olup olmadığını kontrol et
                      if ((todo?.text1?.isEmpty == true ||
                              todo?.text1Status == 0) &&
                          (todo?.text2?.isEmpty == true ||
                              todo?.text2Status == 0) &&
                          (todo?.text3?.isEmpty == true ||
                              todo?.text3Status == 0)) {
                        isCompleted =
                            false; // Eğer tüm alanlar boşsa veya tamamlanmamışsa
                      }

                      if (isCompleted) {
                        cardColor = Colors.green; // Yeşil renk
                      }
                      return GestureDetector(
                        onTap: () {
                          setState(
                            () {
                              _expandedList[index] = !_expandedList[index];
                            },
                          );
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          margin: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Card(
                            color: cardColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 8.0),
                                    leading: Icon(
                                      Icons.ac_unit_sharp,
                                      color: Colors.amberAccent,
                                    ),
                                    title: Text(
                                      todo?.title ?? 'Default Title',
                                      style: TextStyle(
                                        decoration: (todo?.todoStatus == 1
                                                ? true
                                                : false)
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                      ),
                                    ),
                                    trailing: IconButton(
                                        onPressed: () =>
                                            openTextStatusBottomSheet(
                                                selectedTodo: todo),
                                        icon: Icon(Icons.edit))),
                                AnimatedCrossFade(
                                  firstChild: Container(),
                                  secondChild: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                    child: buildExpandableContent(
                                        todo!), // İçeriği Eklenecek
                                  ),
                                  crossFadeState: _expandedList[index]
                                      ? CrossFadeState.showSecond
                                      : CrossFadeState.showFirst,
                                  duration: Duration(milliseconds: 500),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text(
                      'Henüz bir todo yok.',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
