import 'dart:convert';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testsocketchatapp/data/models/environment.dart';
import 'package:testsocketchatapp/presentation/services/notification/notification.dart';
import 'package:testsocketchatapp/presentation/services/provider/config_app_provider.dart';
import 'package:testsocketchatapp/presentation/services/provider/internet_provider.dart';
import 'package:testsocketchatapp/presentation/services/provider/language_provider.dart';
import 'package:testsocketchatapp/presentation/services/provider/theme_provider.dart';
import 'package:testsocketchatapp/presentation/utilities/handle_internet.dart';
import 'package:testsocketchatapp/presentation/utilities/handle_file.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'home_app.dart';

late NotificationService noti;
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage event) async {}

void _handleMessage(
  RemoteMessage message,
  bool isBackground,
) async {
  final image = await UtilsDownloadFile.downloadFile(
      message.notification?.android?.imageUrl ?? "", "largeIcon");
  await noti.showNotification(
    id: 1,
    title: message.notification?.title ?? "",
    body: message.notification?.body ?? "",
    urlImage: image ?? "",
    payload: jsonEncode(message.data),
    isBackground: isBackground,
  );
}

Future<void> setupInteractedMessage() async {
  final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    log("initMes");
    noti.onNotificationClick.add(initialMessage.data);
    noti.initDataNotification = initialMessage.data;
  }
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    log("onMessOpened");
    noti.onNotificationClick.add(event.data);
  });
  FirebaseMessaging.onMessage.listen((event) {
    log("onMessage");
    _handleMessage(event, false);
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  noti = NotificationService();
  await Firebase.initializeApp();
  await noti.initNotification();
  final sharedPref = await SharedPreferences.getInstance();
  final deviceToken = await FirebaseMessaging.instance.getToken();
  tz.initializeTimeZones();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(
    MyApp(sharedPref: sharedPref, deviceToken: deviceToken),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    required this.sharedPref,
    this.deviceToken,
  });
  final SharedPreferences sharedPref;
  final String? deviceToken;
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    setupInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
    final env = Environment(isProduct: false);
    return MultiProvider(
      providers: [
        StreamProvider<ConnectivityResult>(
          create: (context) => Connectivity().onConnectivityChanged,
          initialData: ConnectivityResult.none,
        ),
        ChangeNotifierProvider<InternetProvider>(
          create: (context) => InternetProvider(
            isConnectedInternet: false,
          ),
        ),
        ChangeNotifierProvider<ConfigAppProvider>(
          create: (context) => ConfigAppProvider(
              sharedPref: widget.sharedPref,
              env: env,
              noti: noti,
              navigatorKey: GlobalKey<NavigatorState>(),
              deviceToken: widget.deviceToken),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(
            sharedPref: widget.sharedPref,
          ),
        ),
        ChangeNotifierProvider<LanguageProvider>(
          create: (context) => LanguageProvider(widget.sharedPref),
        ),
      ],
      builder: (context, child) {
        return Consumer<ConnectivityResult>(
          builder: (context, value, child) {
            return FutureBuilder<bool>(
              future: UtilHandlerInternet.checkInternet(result: value),
              builder: (context, snapshot) {
                bool isHaveInternet = snapshot.data ?? false;
                return HomeApp(isHaveInternet: isHaveInternet);
              },
            );
          },
        );
      },
    );
  }
}
