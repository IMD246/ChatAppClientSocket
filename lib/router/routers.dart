import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:testsocketchatapp/page1.dart';
import 'package:testsocketchatapp/page2.dart';

class RoutePaths {
  static const String page1 = "/page1";
  static const String page2 = "/page2";
}

class RouteGenerate {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/page1':
        return MaterialPageRoute(builder: (_) => const Page1());
      case '/page2':
        return MaterialPageRoute(builder: (_) => const Page2());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}

class RoutesHandler {
  static bool checkChatPage({required String pathValue}) {
    if (pathValue.contains(RoutePaths.page1) == true) {
      return true;
    }
    return false;
  }

  static String? getNamePath({required GlobalKey<NavigatorState> globalKey}) {
    String? currentPath;
    if (globalKey.currentState == null) {
      return null;
    }
    globalKey.currentState!.popUntil((route) {
      currentPath = route.settings.name;
      return true;
    });
    log(currentPath ?? "No routes available");
    return currentPath;
  }

  static bool checkIsRouteNameExist(
      {required GlobalKey<NavigatorState> globalKey}) {
    String? currentPath;
    if (globalKey.currentState == null) {
      return false;
    }
    globalKey.currentState!.popUntil((route) {
      currentPath = route.settings.name;
      return true;
    });
    if (currentPath == null) {
      return false;
    }
    return true;
  }
}
