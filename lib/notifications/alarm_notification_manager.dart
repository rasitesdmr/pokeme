import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pokeme/main.dart';
import 'package:pokeme/screens/todo_details_screen.dart';
import 'package:rxdart/rxdart.dart';

class AlarmNotificationManager {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static final onClickNotification = BehaviorSubject<String>();

  // Bildirim tıklama işleyicisi
  static void handleNotificationTap(NotificationResponse notificationResponse) {
    if (notificationResponse.actionId == 'Durdur') {
      // Alarmı durdurma işlemi...
      print("Alarm Durdur");
      _flutterLocalNotificationsPlugin.cancel(notificationResponse.id!);
    } else {
      print('Alarm Devam');
      // Bildirime basıldığında TodoDetailsScreen'e git...
      navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (context) =>
            TodoDetailsScreen(payload: notificationResponse.payload!),
      ));
    }
  }

  // Yerel bildirimleri başlatma
  static Future initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) => null,
    );
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: handleNotificationTap);
  }

// Çalar saat tarzı bildirim gösterme
  static Future displayAlarmNotification({
    required String title,
    required String body,
    required String payload,
    String? customSoundPath,
  }) async {
    // 'const' kaldırıldı
    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'alarm_channel_id', // Benzersiz bir kanal ID'si
      'Alarm Channel', // Kanalın adı
      channelDescription: 'Alarm notifications', // Kanal açıklaması
      importance: Importance.max,
      priority: Priority.high,
      sound: const RawResourceAndroidNotificationSound(
          'alarm_sound'), // Alarm sesi
      playSound: true,
      enableVibration: true, // Titreşimi etkinleştir
      vibrationPattern:
          Int64List.fromList([0, 1000, 500, 1000]), // Titreşim modeli
      ongoing: true, // Bildirimi kapatana kadar göster
      autoCancel: false, // Kullanıcı dokunduğunda bildirimi kapatma
    );
    final NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: payload);
  }

  static Future<void> displayAlarmWithAction({
    required String title,
    required String body,
    required String payload,
    String? customSoundPath,
  }) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound(customSoundPath!),
      enableVibration: true,
      playSound: true,
      vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
      fullScreenIntent: true,
      additionalFlags: Int32List.fromList([4]), // Insistent flag
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction('stop_alarm', 'Durdur')
      ],
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  // Basit bildirim gönderme
  static Future<void> sendReminderTodoNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails('channel_id', 'channel_name',
            channelDescription: 'channel_description');
    final NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(
      0, // ID
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}
