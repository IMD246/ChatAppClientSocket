import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:testsocketchatapp/data/models/environment.dart';
import 'package:testsocketchatapp/presentation/services/notification/notification.dart';
import 'package:testsocketchatapp/presentation/services/provider/config_app_provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'home_app.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  log(message.notification?.title ?? "Dont have data");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final noti = NotificationService();
  await noti.initNotification();
  tz.initializeTimeZones();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();

  // If the message also contains a data property with a "type" of "chat",
  // navigate to a chat screen
  // initialMessage;
  log(initialMessage?.notification?.title ?? "khong co du lieu 1");
  if (initialMessage != null) {
    noti.showNotification(
        id: 1,
        title: initialMessage.notification?.title ?? "d",
        body: initialMessage.notification?.body ?? "d");
  }
  // Also handle any interaction when the app is in the background via a
  // Stream listener
  FirebaseMessaging.onMessageOpenedApp.listen(
    (event) {
      noti.showNotification(
          id: 1,
          title: event.notification?.title ?? "d",
          body: event.notification?.body ?? "d");
    },
  );
  FirebaseMessaging.onMessage.listen((event) {
    noti.showNotification(
        id: 1,
        title: event.notification?.title ?? "d",
        body: event.notification?.body ?? "d");
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ConfigAppProvider>(
      create: (context) => ConfigAppProvider(
        env: Environment(
          isProduct: false,
        ),
      ),
      child: Consumer<ConfigAppProvider>(
        builder: (context, value, child) {
          return const HomeApp();
        },
      ),
    );
  }
}
