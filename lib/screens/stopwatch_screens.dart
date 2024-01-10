import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StopWatchScreen extends StatefulWidget {
  const StopWatchScreen({super.key});

  @override
  State<StopWatchScreen> createState() => _StopWatchScreenState();
}

class _StopWatchScreenState extends State<StopWatchScreen> {
  // business logic of the app
  int seconds = 0, minutes = 0, hours = 0;
  String digitSeconds = "00", digitminutes = "00", digitHours = "00";
  Timer? timer;
  bool started = false;
  List laps = [];

// Creating the stop timer function

  void stop() {
    timer!.cancel();
    setState(() {
      started = false;
    });
  }

// Creating the reset function

  void reset() {
    timer!.cancel();
    setState(() {
      seconds = 0;
      minutes = 0;
      hours = 0;

      digitSeconds = "00";
      digitminutes = "00";
      digitHours = "00";

      started = false;
    });
  }

  void addLaps() {
    String lap = "$digitHours:$digitminutes:$digitSeconds";
    setState(() {
      laps.add(lap);
    });
  }

// Creating the start timer fonction

  void start() {
    started = true;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  void _updateTime() {
    int localSeconds = seconds + 1;
    int localMinutes = minutes;
    int localHours = hours;

    if (localSeconds >= 60) {
      if (localMinutes >= 59) {
        localHours++;
        localMinutes = 0;
      } else {
        localMinutes++;
        localSeconds = 0;
      }
    }

    setState(() {
      seconds = localSeconds;
      minutes = localMinutes;
      hours = localHours;
      digitSeconds = (seconds >= 10) ? "$seconds" : "0$seconds";
      digitHours = (hours >= 10) ? "$hours" : "0$hours";
      digitminutes = (minutes >= 10) ? "$minutes" : "0$minutes";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Scaffold(
            backgroundColor: Color(0xFF2D2F41),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                        child: Text(
                      "StopWatch App",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold),
                    )),
                    SizedBox(
                      height: 20.0,
                    ),
                    Center(
                      child: Text(
                        "$digitHours:$digitminutes:$digitSeconds",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 70.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      height: 300.0,
                      decoration: BoxDecoration(
                        color: Color(0xFF32F68),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      // now let's add a list
                      child: ListView.builder(
                        itemCount: laps.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${laps[index]}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                ),
                                Text(
                                  "Tur n°${index + 1}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: RawMaterialButton(
                            onPressed: () {
                              (!started) ? start() : stop();
                            },
                            shape: const StadiumBorder(
                                side: BorderSide(color: Colors.purple)),
                            child: Text(
                              (!started) ? "Start" : "Pause",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        IconButton(
                          color: Colors.white,
                          onPressed: () {
                            addLaps();
                          },
                          icon: Icon(Icons.flag),
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Expanded(
                          child: RawMaterialButton(
                            onPressed: () {
                              reset();
                            },
                            fillColor: Colors.purple,
                            shape: const StadiumBorder(
                                side: BorderSide(color: Colors.purple)),
                            child: Text(
                              "Reset",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
