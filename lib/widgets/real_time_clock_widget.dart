import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RealTimeClockWidget extends StatefulWidget {
  const RealTimeClockWidget({super.key});

  @override
  _RealTimeClockWidgetState createState() => _RealTimeClockWidgetState();
}

class _RealTimeClockWidgetState extends State<RealTimeClockWidget> {
  String timeString = "";
  String dateString = "";
  late Timer timer;

  @override
  void initState() {
    super.initState();
    _updateTime();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _updateTime());
  }

  void _updateTime() {
    final DateTime now = DateTime.now();
    final String formattedTime = DateFormat('HH:mm:ss').format(now);
    final String formattedDate = DateFormat('dd/MM/yyyy').format(now);
    setState(() {
      timeString = formattedTime;
      dateString = formattedDate;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('HH:mm:ss').format(dateTime);
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          timeString,
          style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          dateString,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
