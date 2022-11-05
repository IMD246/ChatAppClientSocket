import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:testsocketchatapp/data/models/environment.dart';
import 'package:testsocketchatapp/presentation/services/notification/notification.dart';
import 'package:testsocketchatapp/presentation/services/provider/config_app_provider.dart';
import 'package:testsocketchatapp/presentation/utilities/handle_file.dart';
// ignore: depend_on_referenced_packages
import 'package:timezone/data/latest.dart' as tz;
import 'home_app.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  final noti = NotificationService();
  await noti.initNotification();
  await noti.showNotification(
      id: 1,
      title: message.notification?.title ?? "d",
      body: message.notification?.body ?? "d");
  log(message.notification?.title ?? "Dont have data");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final noti = NotificationService();
  await noti.initNotification();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  //hide code background for test
  // (message) async {
  //   await Firebase.initializeApp();
  //   log("check url Image");
  //   log(message.data["urlImageSender"] ?? "");
  //   final image = await UtilsDownloadFile.downloadFile(
  //       message.data["urlImageSender"] ?? "", "largeIcon");
  //   await noti.showNotification(
  //       id: 1,
  //       title: message.notification?.title ?? "d",
  //       body: message.notification?.body ?? "d",
  //       urlImage: image);
  //   log(message.notification?.title ?? "Dont have data");
  // },
  tz.initializeTimeZones();
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();

  // If the message also contains a data property with a "type" of "chat",
  // navigate to a chat screen
  // initialMessage;
  log(initialMessage?.notification?.title ?? "khong co du lieu 1");
  if (initialMessage != null) {
    log("check url Image");
    log(initialMessage.data["urlImageSender"] ?? "");
    final image = await UtilsDownloadFile.downloadFile(
        initialMessage.data["urlImageSender"] ?? "", "largeIcon");
    await noti.showNotification(
        id: 1,
        title: initialMessage.notification?.title ?? "d",
        body: initialMessage.notification?.body ?? "d",
        urlImage: image);
  }
  // Also handle any interaction when the app is in the background via a
  // Stream listener
  FirebaseMessaging.onMessageOpenedApp.listen(
    (event) async {
      log("check url Image");
      log(event.data["urlImageSender"] ?? "");
      final image = await UtilsDownloadFile.downloadFile(
          event.data["urlImageSender"] ?? "", "largeIcon");
      await noti.showNotification(
          id: 1,
          title: event.notification?.title ?? "d",
          body: event.notification?.body ?? "d",
          urlImage: image);
    },
  );
  FirebaseMessaging.onMessage.listen((event) async {
    log("check url Image");
    log(event.data["urlImageSender"] ?? "");
    final image = await UtilsDownloadFile.downloadFile(
        event.data["urlImageSender"] ?? "", "largeIcon");
    await noti.showNotification(
        id: 1,
        title: event.notification?.title ?? "d",
        body: event.notification?.body ?? "d",
        urlImage: image);
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
