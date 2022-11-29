import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:testsocketchatapp/constants/constant.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final PublishSubject<Map<String, dynamic>?> onNotificationClick =
      PublishSubject<Map<String, dynamic>?>();
  Map<String, dynamic>? initDataNotification;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Future<void> initNotification() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/chat_icon');
    const DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  Future<void> showNotification(
      {required int id,
      required String title,
      required String body,
      String? payload,
      String urlImage = "",
      required bool isBackground}) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      payload: payload,
      tz.TZDateTime.now(tz.local).add(
        const Duration(seconds: 1),
      ),
      NotificationDetails(
        android: AndroidNotificationDetails(
          Constants.defaultNotificationChannelId,
          Constants.notificationName,
          importance: Importance.max,
          priority: Priority.max,
          largeIcon: urlImage.isEmpty ? null : FilePathAndroidBitmap(urlImage),
          channelDescription: "Main Channel Notifiaction",
        ),
        iOS: const DarwinNotificationDetails(
          sound: 'default.wav',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  void onDidReceiveNotificationResponse(NotificationResponse details) {
    if (details.payload != null || details.payload!.isNotEmpty) {
      onNotificationClick.add(jsonDecode(details.payload!));
    }
  }
}
