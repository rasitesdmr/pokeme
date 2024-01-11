import 'package:flutter/material.dart';
import 'package:pokeme/enums/menu_type_enum.dart';
import 'package:pokeme/providers/menu_selection_provider.dart';
import 'package:pokeme/screens/alarm_screens.dart';
import 'package:pokeme/screens/stopwatch_screens.dart';
import 'package:pokeme/screens/todo_screen.dart';
import 'package:pokeme/screens/pomodoro_screen.dart';
import 'package:pokeme/widgets/analog_clock_builder.dart';
import 'package:pokeme/widgets/navigation_control_builder.dart';
import 'package:pokeme/widgets/real_time_clock_widget.dart';
import 'package:pokeme/styles/app_color_palette.dart';
import 'package:provider/provider.dart';

class ClockScreen extends StatefulWidget {
  const ClockScreen({super.key});

  @override
  State<ClockScreen> createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {
  bool showFirstClock = true;
  int selectedClockIndex = 1; // Saat widget'ı seçimi için durum değişkeni

  void toggleClock() {
    setState(() {
      selectedClockIndex =
          (selectedClockIndex % 4) + 1; // Saatleri döngüsel olarak değiştir
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget clockWidget;
    // Seçilen saate göre widget'ı belirle
    switch (selectedClockIndex) {
      case 1:
        clockWidget = AnalogClockBuilder.buildFirstClock();
        break;
      case 2:
        clockWidget = AnalogClockBuilder.buildSecondClock();
        break;
      case 3:
        clockWidget = AnalogClockBuilder.buildThirdClock(); // Üçüncü saat
        break;
      case 4:
        clockWidget = AnalogClockBuilder.buildFourthClock(); // Dördüncü saat
        break;
      default:
        clockWidget =
            AnalogClockBuilder.buildFirstClock(); // Varsayılan olarak ilk saat
        break;
    }

    return Scaffold(
      backgroundColor: AppColorPalette.pageBackgroundColor[0],
      bottomNavigationBar: NavigationControlBuilder.bottomAppBar(context),
      body: Row(
        children: [
          Expanded(
            child: Consumer<MenuSelectionProvider>(
              builder: (BuildContext context,
                  MenuSelectionProvider menuSelectionProvider, Widget? child) {
                if (menuSelectionProvider.menuTypeEnum == MenuTypeEnum.alarm) {
                  return AlarmScreen();
                }
                if (menuSelectionProvider.menuTypeEnum ==
                    MenuTypeEnum.stopwatch) {
                  return StopWatchScreen();
                }
                if (menuSelectionProvider.menuTypeEnum ==
                    MenuTypeEnum.pomodoro) {
                  return PomodoroScreen();
                }
                if (menuSelectionProvider.menuTypeEnum == MenuTypeEnum.todo) {
                  return TodoScreen();
                }
                return Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Clock',
                          style: TextStyle(
                            color: Color(0xFFCEC7BF),
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: GestureDetector(
                              onTap: toggleClock, child: clockWidget),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Center(
                          child: RealTimeClockWidget(),
                        ),
                      ),
                    ],
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
