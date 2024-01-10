import 'dart:async';
import 'package:flutter/material.dart';

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({Key? key}) : super(key: key);

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  Timer? countdownTimer;
  Duration myDuration = const Duration(minutes: 25);
  int selectedMinutes = 25;
  bool isTimerRunning = false;
  String currentMode = 'Pomodoro';
  int pomodoroCounter = 0;
  TextEditingController pomodoroCounterController = TextEditingController();
  TextEditingController pomodoroDurationController = TextEditingController();
  TextEditingController shortBreakDurationController = TextEditingController();
  TextEditingController longBreakDurationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    myDuration = const Duration(minutes: 25);
  }

  void startTimer() {
    if (!isTimerRunning) {
      countdownTimer =
          Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
      setState(() => isTimerRunning = true);
    }
  }

  void stopTimer() {
    if (countdownTimer != null && countdownTimer!.isActive) {
      setState(() {
        countdownTimer!.cancel();
        isTimerRunning = false;
      });
    }
  }

  void resetTimer() {
    stopTimer();
    setState(() => myDuration = Duration(minutes: selectedMinutes));
  }

  void setTimerDuration(int minutes, String mode) {
    setState(() {
      selectedMinutes = minutes;
      myDuration = Duration(minutes: minutes);
      currentMode = mode;
      resetTimer();
    });
  }

  void setCountDown() {
    final reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
        isTimerRunning = false;
        showAlertDialog();

        int pomodoroDuration =
            int.tryParse(pomodoroDurationController.text) ?? 25;
        int shortBreakDuration =
            int.tryParse(shortBreakDurationController.text) ?? 5;
        int longBreakDuration =
            int.tryParse(longBreakDurationController.text) ?? 15;

        if (currentMode == 'Pomodoro') {
          pomodoroCounter += 1;
          if (pomodoroCounter % 4 == 0) {
            setTimerDuration(longBreakDuration, 'Uzun Ara');
          } else {
            setTimerDuration(shortBreakDuration, 'Kısa Ara');
          }
        } else if (currentMode == 'Uzun Ara') {
          pomodoroCounter = 0;
          setTimerDuration(pomodoroDuration, 'Pomodoro');
        } else if (currentMode == 'Kısa Ara') {
          setTimerDuration(pomodoroDuration, 'Pomodoro');
        }
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }

  void showAlertDialog() {
    String alertTitle = '';
    String alertContent = '';

    switch (currentMode) {
      case 'Pomodoro':
        alertTitle = 'Süreniz doldu!';
        alertContent = 'Şimdi biraz dinlenme zamanı';
        break;
      case 'Kısa Ara':
      case 'Uzun Ara':
        alertTitle = 'Süreniz doldu!';
        alertContent = 'Çalışma Zamanı';
        break;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: AlertDialog(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(
                    alertTitle,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(alertContent),
                ),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    child: const Text('Tamam'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF3D737F),
          title: const Center(
            child: Text(
              'Ayarlar',
              style: TextStyle(
                color: Color(0xFFCEC7BF),
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  controller: pomodoroDurationController,
                  decoration: const InputDecoration(
                    labelText: 'Pomodoro Süresi (20-60 dak)',
                    labelStyle: TextStyle(
                      color: Color(0xFFCEC7BF),
                      fontWeight: FontWeight.w500,
                    ),
                    contentPadding: EdgeInsets.only(top: 20.0),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFCEC7BF),
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFCEC7BF),
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Color(0xFFCEC7BF)),
                ),
                TextFormField(
                  controller: shortBreakDurationController,
                  decoration: const InputDecoration(
                    labelText: 'Kısa Ara Süresi (5-20 dak)',
                    labelStyle: TextStyle(
                      color: Color(0xFFCEC7BF),
                      fontWeight: FontWeight.w500,
                    ),
                    contentPadding: EdgeInsets.only(top: 20.0),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFCEC7BF),
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFCEC7BF)),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Color(0xFFCEC7BF)),
                ),
                TextFormField(
                  controller: longBreakDurationController,
                  decoration: const InputDecoration(
                    labelText: 'Uzun Ara Süresi (15-40 dak)',
                    labelStyle: TextStyle(
                      color: Color(0xFFCEC7BF),
                      fontWeight: FontWeight.w500,
                    ),
                    contentPadding: EdgeInsets.only(top: 20.0),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFCEC7BF),
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFCEC7BF)),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Color(0xFFCEC7BF)),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Center(
                child: Text(
                  'Tamam',
                  style: TextStyle(
                    color: Color(0xFFCEC7BF),
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              onPressed: () {
                int newPomodoroDuration =
                    int.tryParse(pomodoroDurationController.text) ?? 25;
                int newShortBreakDuration =
                    int.tryParse(shortBreakDurationController.text) ?? 5;
                int newLongBreakDuration =
                    int.tryParse(longBreakDurationController.text) ?? 15;

                if ((newPomodoroDuration < 20 || newPomodoroDuration > 60) ||
                    (newShortBreakDuration < 5 || newShortBreakDuration > 20) ||
                    (newLongBreakDuration < 15 || newLongBreakDuration > 40)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Center(
                        child: Text('Lütfen geçerli bir dakika belirleyiniz'),
                      ),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  setState(() {
                    selectedMinutes = newPomodoroDuration;
                    myDuration = Duration(minutes: newPomodoroDuration);
                    if (currentMode == 'Kısa Ara') {
                      myDuration = Duration(minutes: newShortBreakDuration);
                    } else if (currentMode == 'Uzun Ara') {
                      myDuration = Duration(minutes: newLongBreakDuration);
                    }
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));

    return Scaffold(
        backgroundColor: const Color(0xFF07161B),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(0, 70, 0, 120),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: Ink(
                              decoration: ShapeDecoration(
                                color: const Color(0xFF1C3039),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.timer,
                                    color: Color(0xFFCEC7BF)),
                                onPressed: () {
                                  int pomodoroDuration = int.tryParse(
                                          pomodoroDurationController.text) ??
                                      25;
                                  setTimerDuration(
                                      pomodoroDuration, 'Pomodoro');
                                },
                                iconSize: 55,
                                constraints: const BoxConstraints(
                                  minHeight: 120,
                                  minWidth: 90,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Pomodoro',
                            style: TextStyle(
                                fontSize: 12, color: Color(0xFFCEC7BF)),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: Ink(
                              decoration: ShapeDecoration(
                                color: const Color(0xFF2F4249),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.coffee,
                                    color: Color(0xFFCEC7BF)),
                                onPressed: () {
                                  int shortBreakDuration = int.tryParse(
                                          shortBreakDurationController.text) ??
                                      5;
                                  setTimerDuration(
                                      shortBreakDuration, 'Kısa Ara');
                                },
                                iconSize: 55,
                                constraints: const BoxConstraints(
                                  minHeight: 120,
                                  minWidth: 90,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Kısa Ara',
                            style: TextStyle(
                                fontSize: 12, color: Color(0xFFCEC7BF)),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: Ink(
                              decoration: ShapeDecoration(
                                color: const Color(0xFF2C303B),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.nightlight,
                                    color: Color(0xFFCEC7BF)),
                                onPressed: () {
                                  int longBreakDuration = int.tryParse(
                                          longBreakDurationController.text) ??
                                      15;
                                  setTimerDuration(
                                      longBreakDuration, 'Uzun Ara');
                                },
                                iconSize: 55,
                                constraints: const BoxConstraints(
                                  minHeight: 120,
                                  minWidth: 90,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Uzun Ara',
                            style: TextStyle(
                                fontSize: 12, color: Color(0xFFCEC7BF)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(flex: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$minutes:$seconds',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFCEC7BF),
                          fontSize: 90,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${pomodoroCounter % 4}/3',
                    style: const TextStyle(
                      color: Color(0xFFCEC7BF),
                      fontSize: 24,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon:
                            const Icon(Icons.refresh, color: Color(0xFFCEC7BF)),
                        onPressed: resetTimer,
                        iconSize: 40,
                        constraints: const BoxConstraints(
                          minHeight: 75,
                          minWidth: 75,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: isTimerRunning ? stopTimer : startTimer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3D737F),
                          minimumSize: const Size(175, 75),
                        ),
                        child: Text(
                          isTimerRunning ? 'Stop' : 'Start',
                          style: const TextStyle(
                            fontSize: 30,
                            color: Color(0xFFCEC7BF),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings,
                            color: Color(0xFFCEC7BF)),
                        onPressed: showSettingsDialog,
                        iconSize: 40,
                        constraints: const BoxConstraints(
                          minHeight: 75,
                          minWidth: 75,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
