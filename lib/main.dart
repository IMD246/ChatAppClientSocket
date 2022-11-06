import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:testsocketchatapp/data/models/environment.dart';
import 'package:testsocketchatapp/presentation/services/notification/notification.dart';
import 'package:testsocketchatapp/presentation/services/provider/config_app_provider.dart';
import 'package:testsocketchatapp/presentation/utilities/handle_file.dart';
import 'package:timezone/data/latest.dart' as tzLast;

import 'home_app.dart';

late NotificationService noti;
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // noti = NotificationService();
  // await noti.initNotification();
  await noti.showNotification(
    id: 1,
    title: message.notification?.title ?? "d",
    body: message.notification?.body ?? "d",
    data: message.data,
    payload: "Background",
  );
  // log(message.notification?.title ?? "Dont have data");
}

Future<void> setupInteractedMessage() async {
  // Get any messages which caused the application to open from
  // a terminated state.
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();

  // If the message also contains a data property with a "type" of "chat",
  // navigate to a chat screen
  if (initialMessage != null) {
    _handleMessage(initialMessage);
  }

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
  await noti.showNotification(
    id: 1,
    title: message.notification?.title ?? "d",
    body: message.notification?.body ?? "d",
    urlImage: image,
    payload: "onMessage",
    data: message.data,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  tzLast.initializeTimeZones();
  noti = NotificationService();
  await noti.initNotification();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  setupInteractedMessage();
  runApp(
    MyApp(
      noti: noti,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.noti});
  final NotificationService noti;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ConfigAppProvider>(
      create: (context) => ConfigAppProvider(
          env: Environment(
            isProduct: false,
          ),
          noti: noti),
      child: Consumer<ConfigAppProvider>(
        builder: (context, value, child) {
          return const HomeApp();
        },
      ),
    );
  }
}
