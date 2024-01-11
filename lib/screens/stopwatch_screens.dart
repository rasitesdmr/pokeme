import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pokeme/styles/app_color_palette.dart';

class StopWatchScreen extends StatefulWidget {
  const StopWatchScreen({super.key});

  @override
  State<StopWatchScreen> createState() => _StopWatchScreenState();
}

class _StopWatchScreenState extends State<StopWatchScreen> {
  int seconds = 0, minutes = 0, hours = 0;
  String digitSeconds = "00", digitminutes = "00", digitHours = "00";
  Timer? timer;
  bool started = false;
  List<Map<String, dynamic>> laps = [];

  void stop() {
    timer!.cancel();
    setState(() {
      started = false;
    });
  }

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
      laps.clear();
    });
  }

  String _calculateTotalTime() {
    int totalSeconds = laps.fold<int>(0, (previous, lap) => previous + (lap['tur_suresi'] as int? ?? 0));
    int totalHours = totalSeconds ~/ 3600;
    int totalMinutes = (totalSeconds % 3600) ~/ 60;
    int totalRemainingSeconds = totalSeconds % 60;

    return "$totalHours:${totalMinutes.toString().padLeft(2, '0')}:${totalRemainingSeconds.toString().padLeft(2, '0')}";
  }

  void addLaps() {
    int currentSeconds = seconds + (60 * minutes) + (3600 * hours);

    String lapTime = _formatTime(currentSeconds);

    Map<String, dynamic> lapData = {
      'tur': laps.length + 1,
      'tur_suresi': (laps.isEmpty) ? "0:00:00" : _calculateDifference(lapTime),
      'toplam_sure': (laps.isEmpty) ? "0:00:00" : lapTime,
    };

    setState(() {
      laps.add(lapData);
    });
  }

  String _calculateDifference(String currentLapTime) {
    int currentSeconds = _calculateSeconds(currentLapTime);

    String previousLapTime = laps.last['toplam_sure'];
    int previousSeconds = _calculateSeconds(previousLapTime);

    int differenceSeconds = currentSeconds - previousSeconds;

    return _formatTime(differenceSeconds);
  }

  int _calculateSeconds(String lapTime) {
    List<String> timeParts = lapTime.split(':');
    int hours = int.parse(timeParts[0]);
    int minutes = int.parse(timeParts[1]);
    int seconds = int.parse(timeParts[2]);

    return seconds + (60 * minutes) + (3600 * hours);
  }


  String _formatTime(num seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds.toInt() % 60;

    return "$hours:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }




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

  void clearLaps() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Clear All Laps"),
          content: const Text("Are you sure you want to clear all laps?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Kullanıcı onayı iptal etti.

              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  laps.clear(); // Tüm tur verilerini temizle
                });
                Navigator.of(context).pop(); // Kullanıcı onayı tamamlandı.
              },
              child: const Text("Clear"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorPalette.pageBackgroundColor[1],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0, top: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    Text(
                      "Kronometre",
                      style: TextStyle(
                        color: AppColorPalette.primaryTextColor[0],
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              Center(
                child: Text(
                  "$digitHours:$digitminutes:$digitSeconds",
                  style: TextStyle(
                    color: AppColorPalette.primaryTextColor[0],
                    fontSize: 70.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                height: 300.0,
                decoration: BoxDecoration(
                  color: AppColorPalette.stopWatchTourScreenColor, // Tur renk
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Tur",
                            style: TextStyle(
                              color: AppColorPalette.primaryTextColor[0],
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Tur süresi",
                            style: TextStyle(
                              color: AppColorPalette.primaryTextColor[0],
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Toplam Süre",
                            style: TextStyle(
                              color: AppColorPalette.primaryTextColor[0],
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Divider(color: AppColorPalette.primaryTextColor[0]), // Başlıkların altına çizgi ekliyoruz
                      ...laps.asMap().entries.map((entry) {
                        final index = entry.key;
                        final lap = entry.value;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${lap['tur']}",
                              style: TextStyle(
                                color: AppColorPalette.primaryTextColor[0],
                                fontSize: 16.0,
                              ),
                            ),
                            Text(
                              "${lap['tur_suresi']} saniye",
                              style: TextStyle(
                                color: AppColorPalette.primaryTextColor[0],
                                fontSize: 16.0,
                              ),
                            ),
                            Text(
                              "${lap['toplam_sure'] ?? '0:00:00'}",
                              style: TextStyle(
                                color: AppColorPalette.primaryTextColor[0],
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(
                    width: 30.0,
                  ),
                  IconButton(
                    color: AppColorPalette.primaryTextColor[0],
                    onPressed: () {
                      addLaps();
                    },
                    icon: const Icon(Icons.flag),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      (!started) ? start() : stop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColorPalette.buttonColor,
                      minimumSize: const Size(130, 40),
                    ),
                    child: Text(
                      (!started) ? "Başlat" : "Durdur",
                      style: TextStyle(color: AppColorPalette.primaryTextColor[0],
                      fontWeight: FontWeight.bold,
                        fontSize: 17
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  IconButton(
                    color: AppColorPalette.primaryTextColor[0],
                    onPressed: () {
                      reset();
                    },
                    icon: Icon(Icons.refresh),
                  ),
                  const SizedBox(
                    width: 30.0,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
