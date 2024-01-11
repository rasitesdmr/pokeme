import 'package:flutter/material.dart';
import 'package:pokeme/database/todo_database_manager.dart';
import 'package:pokeme/models/todo.dart';

class TodoDetailsScreen extends StatefulWidget {
  final String payload;

  TodoDetailsScreen({Key? key, required this.payload}) : super(key: key);

  @override
  _TodoDetailsScreenState createState() => _TodoDetailsScreenState();
}

class _TodoDetailsScreenState extends State<TodoDetailsScreen> {
  Todo? todo;

  @override
  void initState() {
    super.initState();
    fetchTodoDetails();
  }

  void fetchTodoDetails() async {
    // Payload'tan todo ID'sini alın. Örnek payload: "todoId:3"
    final todoId = int.parse(widget.payload.split(":")[1]);

    TodoDatabaseManager todoDatabaseManager = TodoDatabaseManager();
    Todo? fetchedTodo = await todoDatabaseManager.getTodoById(todoId);

    if (mounted) {
      setState(() {
        todo = fetchedTodo;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Todo Details')),
      body: todo == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Title: ${todo!.title}',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Details: ${todo!.text1}',
                    style: TextStyle(fontSize: 18),
                  ),
                  // Diğer todo detayları...
                ],
              ),
            ),
    );
  }
}
