import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:testsocketchatapp/data/models/environment.dart';
import '../../../page1.dart';
import '../../../page2.dart';
import '../../../router/routers.dart';
import '../notification/notification.dart';

class ConfigAppProvider extends ChangeNotifier {
  final Environment env;
  NotificationService noti;
  final GlobalKey<NavigatorState> navigatorKey;
  ConfigAppProvider(
      {required this.env, required this.noti, required this.navigatorKey});
  setNoti({required NotificationService value}) {
    noti = value;
    notifyListeners();
  }

  handlerNotification({required BuildContext context}) {
    noti.onNotificationClick.listen((value) {
      if (value != null) {
        log(value.toString());
        noti.onNotificationClick.sink.add(null);
        final namePath = RoutesHandler.getNamePath(globalKey: navigatorKey);
        if (namePath != null) {
          if (RoutesHandler.checkChatPage(pathValue: namePath)) {
            Navigator.of(context).pushNamed("/page2");
          } else {
            if (value["message"] == "p2") {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const Page2();
                  },
                  settings: const RouteSettings(name: "/page2"),
                ),
              );
            } else if (value["message"] == "p1") {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const Page1();
                  },
                  settings: const RouteSettings(name: "/page1"),
                ),
              );
            }
          }
        }
      }
    });
  }
}
