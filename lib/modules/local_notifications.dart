import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';


class LocalNotifications {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) => null,
    );
    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            macOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (details) => null);
  }

  //Simple notification
  static Future<void> showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: payload);
  }

  //Scheduled notification
  static Future showScheduleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    try {
      final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
      debugPrint("Current Timezone: $currentTimeZone");
    } catch (e) {
      debugPrint("Error getting timezone: $e");
    }
  }

  static Future<void> cancelAll() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
