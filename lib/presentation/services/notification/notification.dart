// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/timezone.dart' as tz;
// ignore: library_prefixes


class NotificationService {
  final BehaviorSubject<Map<String, dynamic>> dataSubjectNotification =
      BehaviorSubject<Map<String, dynamic>>();
  final BehaviorSubject<String?> onNotificationClick =
      BehaviorSubject<String?>();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  NotificationService();
  Future<void> initNotification() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
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
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    required Map<String, dynamic> data,
    String? payload,
    String urlImage = "",
  }) async {
    dataSubjectNotification.add(data);
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
          'mychannel',
          "My Channel",
          importance: Importance.max,
          priority: Priority.max,
          largeIcon: FilePathAndroidBitmap(urlImage),
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

  void onDidReceiveBackgroundNotificationResponse(
      NotificationResponse details) {
    onNotificationClick.add(details.payload);
    log("payload : ${details.payload}");
    // if (details.payload != null) {
    // }
  }

  void onDidReceiveNotificationResponse(NotificationResponse details) {
    onNotificationClick.add(details.payload);
    log("payload : ${details.payload}");
    // if (details.payload != null ) {
    // }
  }
}
