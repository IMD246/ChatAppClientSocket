import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:testsocketchatapp/data/models/environment.dart';
import 'package:testsocketchatapp/presentation/services/notification/notification.dart';
import 'package:testsocketchatapp/presentation/services/provider/config_app_provider.dart';
import 'package:testsocketchatapp/presentation/utilities/handle_file.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'home_app.dart';

late NotificationService noti;
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log(message.data["message"]);
  await noti.showNotification(
    id: 1,
    title: message.notification?.title ?? "d",
    body: message.notification?.body ?? "d",
    data: message.data,
    payload: "Background",
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  noti = NotificationService();
  await noti.initNotification();
  tz.initializeTimeZones();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    await FirebaseMessaging.instance.getInitialMessage().then((value) {
      if (value != null) {
        _handleMessage(value);
      }
    });

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    FirebaseMessaging.onMessage.listen(_handleMessage);
  }

  void _handleMessage(
    RemoteMessage message,
  ) async {
    final image = await UtilsDownloadFile.downloadFile(
        message.data["urlImageSender"] ?? "", "largeIcon");
    log(message.data["message"]);
    await noti.showNotification(
      id: 1,
      title: message.notification?.title ?? "d",
      body: message.notification?.body ?? "d",
      urlImage: image,
      payload: "onMessage",
      data: message.data,
    );
  }

  @override
  void initState() {
    super.initState();
    setupInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ConfigAppProvider>(
      create: (context) => ConfigAppProvider(
        env: Environment(
          isProduct: false,
        ),
        noti: noti,
      ),
      child: Consumer<ConfigAppProvider>(
        builder: (context, value, child) {
          return const HomeApp();
        },
      ),
    );
  }
}
