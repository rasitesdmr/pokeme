import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pokeme/database/todo_database_manager.dart';
import 'package:pokeme/models/todo.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  TodoDatabaseManager _todoDatabaseManager = TodoDatabaseManager();
  DateTime? _alarmTime;
  List<Todo>? _currentAlarms;
  late List<bool> _expandedList;

  final List<Map<String, dynamic>> _todos = [
    {
      'time': '10 AM',
      'task': 'Wake up Bro',
      'isDone': true,
      'icon': Icons.alarm,
      'color': Colors.green,
      'subtasks': [
        {'title': 'Spor salonuna gidilecek', 'isDone': false},
        {'title': 'Su alınacak', 'isDone': false},
      ],
    },
    {
      'time': '11 AM',
      'task': 'Let\'s do Gym',
      'isDone': false,
      'icon': Icons.fitness_center,
      'color': Colors.blue,
      'subtasks': [
        {'title': 'Spor salonuna gidilecek', 'isDone': false},
        {'title': 'Su alınacak', 'isDone': false},
        {'title': 'Protein tozu alınacak', 'isDone': false},
      ],
    },
    // Diğer todo öğeleri...
  ];

  @override
  void initState() {
    super.initState();
    _expandedList = List.generate(_todos.length, (index) => false);
  }

  void _showAddTodoModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return AddTaskScreen();
      },
    );
  }

  Widget _buildExpandableContent(Map<String, dynamic> todo) {
    return Column(
      children: todo['subtasks'].map<Widget>((subtask) {
        return Row(
          children: [
            Icon(
              subtask['isDone']
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
              color: Colors.green,
            ),
            SizedBox(width: 8.0),
            Text(subtask['title']),
          ],
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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
                    onPressed: () => _showAddTodoModal(context),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final todo = _todos[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _expandedList[index] = !_expandedList[index];
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 8.0),
                            leading: Icon(todo['icon'], color: todo['color']),
                            title: Text(
                              todo['task'],
                              style: TextStyle(
                                decoration: todo['isDone']
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            subtitle: Text(todo['time']),
                            trailing: Checkbox(
                              onChanged: (bool? value) {
                                setState(() {
                                  todo['isDone'] = value!;
                                });
                              },
                              value: todo['isDone'],
                            ),
                          ),
                          AnimatedCrossFade(
                            firstChild: Container(),
                            secondChild: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: _buildExpandableContent(todo),
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
            ),
          ),
        ],
      ),
    );
  }
}

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController _titleController = TextEditingController();
  String _alarmTimeString = DateFormat('HH:mm').format(DateTime.now());

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        _alarmTimeString = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: MediaQuery.of(context).viewInsets,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Create New Todo',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Task Title',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Task Title',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Date',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            TextButton(
              onPressed: () => _selectDate(context),
              child: Text(
                DateFormat('dd-MM-yyyy').format(selectedDate),
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Time',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            TextButton(
              onPressed: () => _selectTime(context),
              child: Text(
                _alarmTimeString,
                style: TextStyle(fontSize: 18),
              ),
            ),
            Text(
              'Subtask 1',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            TextField(
              controller: null,
              decoration: InputDecoration(
                hintText: 'Enter subtask 1',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            SizedBox(height: 16),
            Text(
              'Subtask 2',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            TextField(
              controller: null,
              decoration: InputDecoration(
                hintText: 'Enter subtask 2',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            SizedBox(height: 16),
            Text(
              'Subtask 3',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            TextField(
              controller: null,
              decoration: InputDecoration(
                hintText: 'Enter subtask 3',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            // Diğer widget'lar ve butonlar
          ],
        ),
      ),
    );
  }
}
