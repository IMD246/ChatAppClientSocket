import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoutePaths {
  static const String home = "/";
  static const String chat = "/chat";
}

class RouteGenerate {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    log("----- ROUTE----: ${settings.name} ------\n"
        "arguments: ${settings.arguments.toString()}");
    return null;
  }
}
