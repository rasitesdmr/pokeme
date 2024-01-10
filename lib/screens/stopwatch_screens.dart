import 'dart:async';
import 'package:flutter/material.dart';

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
          title: Text("Clear All Laps"),
          content: Text("Are you sure you want to clear all laps?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Kullanıcı onayı iptal etti.

              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  laps.clear(); // Tüm tur verilerini temizle
                });
                Navigator.of(context).pop(); // Kullanıcı onayı tamamlandı.
              },
              child: Text("Clear"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2F41),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "Kronometre",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
                  color: const Color(0xFF32F68), // Tur renk
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
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Tur süresi",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Toplam Süre",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Divider(color: Colors.white), // Başlıkların altına çizgi ekliyoruz
                      ...laps.asMap().entries.map((entry) {
                        final index = entry.key;
                        final lap = entry.value;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${lap['tur']}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                            Text(
                              "${lap['tur_suresi']} saniye",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                            Text(
                              "${lap['toplam_sure'] ?? '0:00:00'}",
                              style: TextStyle(
                                color: Colors.white,
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
                        side: BorderSide(color: Colors.purple),
                      ),
                      child: Text(
                        (!started) ? "Başlat" : "Durdur",
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
                      fillColor: const Color(0xFF6B2FBB), // Reset rengi
                      shape: const StadiumBorder(
                        side: BorderSide(color: Colors.purple),
                      ),
                      child: Text(
                        "Sıfırla",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
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
