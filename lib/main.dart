import 'dart:convert';
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
void _handleMessage(
  RemoteMessage message,
  bool isBackground,
) async {
  final image = await UtilsDownloadFile.downloadFile(
      message.data["urlImageSender"] ?? "", "largeIcon");
  log(message.data["message"]);
  await noti.showNotification(
    id: 1,
    title: message.notification?.title ?? "",
    body: message.notification?.body ?? "",
    urlImage: image,
    payload: jsonEncode(message.data),
    isBackground: isBackground,
  );
}

Future<void> setupInteractedMessage() async {
  noti = NotificationService();
  await noti.initNotification();
  tz.initializeTimeZones(); // Get any messages which caused the application to open from
  // a terminated state.
  await FirebaseMessaging.instance.getInitialMessage().then((value) {
    if (value != null) {
      noti.stateNotification.add(true);
      noti.dataSubjectNotification.add(value.data);
    }
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    log("3");
    _handleMessage(event, false);
  });
  FirebaseMessaging.onMessage.listen((event) {
    log("4");
    _handleMessage(event, false);
  });
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupInteractedMessage();
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
  @override
  void initState() {
    super.initState();
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
