import 'package:flutter/material.dart';
import 'package:pokeme/database/todo_database_manager.dart';
import 'package:pokeme/main.dart';
import 'package:pokeme/models/todo.dart';
import 'package:pokeme/screens/todo_screen.dart';

class TestDetailsScreen extends StatefulWidget {
  final String payload;

  const TestDetailsScreen({Key? key, required this.payload}) : super(key: key);

  @override
  State<TestDetailsScreen> createState() => _TestDetailsScreenState();
}

class _TestDetailsScreenState extends State<TestDetailsScreen> {
  Todo? todo;

  @override
  void initState() {
    super.initState();
    fetchTodoDetails();
  }

  void fetchTodoDetails() async {
    // Payload'tan todo ID'sini alın. Örnek payload: "todoId:3"
    final reminderId = int.parse(widget.payload.split(":")[1]);

    TodoDatabaseManager todoDatabaseManager = TodoDatabaseManager();
    Todo? fetchedTodo =
        await todoDatabaseManager.getTodoByReminderAlarmId(reminderId);

    if (mounted) {
      setState(() {
        todo = fetchedTodo;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int? todoHour;
    int? todoMinute;
    if (todo != null) {
      todoHour = todo?.alarmDateTime?.hour;
      todoMinute = todo?.alarmDateTime?.minute;
    }
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF3D737F),
        body: Padding(
          padding: const EdgeInsets.only(top: 80, bottom: 0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'REMAINDER',
                      style: TextStyle(
                          color: Color(0xFFCEC7BF),
                          fontSize: 35,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 70,
                      width: 220,
                      decoration: BoxDecoration(
                          color: const Color(0xFFCEC7BF),
                          borderRadius: BorderRadius.circular(10),
                          shape: BoxShape.rectangle),
                      child: Center(
                        child: Text(
                          '${todo?.alarmDateTime?.hour ?? ''}:${todo?.alarmDateTime?.minute ?? ''}',
                          style: TextStyle(
                              color: Color(0xFF07161B),
                              fontSize: 35,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${todo!.alarmDateTime!.minute - todo!.reminderDateTime!.minute} minutes left',
                      style: TextStyle(
                        color: Color(0xFFCEC7BF),
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 250,
                      width: 220,
                      decoration: BoxDecoration(
                          color: const Color(0xFFCEC7BF),
                          borderRadius: BorderRadius.circular(10),
                          shape: BoxShape.rectangle),
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            todo?.title ?? '',
                            style: TextStyle(
                              color: Color(0xFF07161B),
                              fontSize: 20,
                            ),
                          ),
                          const Spacer(flex: 10),
                          Text(
                            todo?.text1 ?? '',
                            style: TextStyle(
                              color: Color(0xFF07161B),
                              fontSize: 15,
                            ),
                          ),
                          Container(
                            height: 1.0,
                            width: 180,
                            color: Color(0xFF07161B),
                          ),
                          const Spacer(flex: 9),
                          Text(
                            todo?.text2 ?? '',
                            style: TextStyle(
                              color: Color(0xFF07161B),
                              fontSize: 15,
                            ),
                          ),
                          Container(
                            height: 1.0,
                            width: 180,
                            color: Color(0xFF07161B),
                          ),
                          const Spacer(flex: 9),
                          Text(
                            todo?.text3 ?? '',
                            style: TextStyle(
                              color: Color(0xFF07161B),
                              fontSize: 15,
                            ),
                          ),
                          Container(
                            height: 1.0,
                            width: 180,
                            color: const Color(0xFF07161B),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 80),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF07161B),
                    minimumSize: const Size(150, 70),
                  ),
                  child: const Text(
                    'Ok',
                    style: TextStyle(
                      fontSize: 25,
                      color: Color(0xFFCEC7BF),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
