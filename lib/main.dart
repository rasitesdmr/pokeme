import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pokeme/enums/menu_type_enum.dart';
import 'package:pokeme/notifications/alarm_notification_manager.dart';
import 'package:pokeme/providers/menu_selection_provider.dart';
import 'package:pokeme/screens/clock_screen.dart';
import 'package:provider/provider.dart';

final navigatorKey = GlobalKey<NavigatorState>();
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AlarmNotificationManager.initializeNotifications();
  await AndroidAlarmManager.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'PokeMe',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      localizationsDelegates: const [
        // Yerelleştirme desteği ekleniyor
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('tr', 'TR'), // Türkçe desteği
        // Diğer desteklenen dilleri buraya ekleyebilirsiniz
      ],
      home: ChangeNotifierProvider<MenuSelectionProvider>(
        create: (context) =>
            MenuSelectionProvider(menuTypeEnum: MenuTypeEnum.clock),
        child: ClockScreen(),
      ),
    );
  }
}
