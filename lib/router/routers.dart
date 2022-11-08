import 'dart:developer';

import 'package:flutter/material.dart';

// class RouteGenerate {
//   static Route<dynamic> generateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       case "/":
//         return MaterialPageRoute(
//           builder: (context) {
//             return const App();
//           },
//         );
//       // case "chat":
//       //   final value = jsonDecode(settings.arguments.toString());
//       //   log(value);
//       //   return MaterialPageRoute(
//       //     builder: (context) {
//       //       return MessageChatScreen(
//       //         socket: value["socket"],
//       //         chatUserAndPresence: value["chatUserAndPresence"],
//       //         userInformation: value["userInformation"],
//       //       );
//       //     },
//       //   );
//       default:
//         return MaterialPageRoute(
//           builder: (_) => Scaffold(
//             body: Center(child: Text('No route defined for ${settings.name}')),
//           ),
//         );
//     }
//   }
// }

class RoutesHandler {
  static bool checkChatPage(
      {required String pathValue, required String idChat}) {
    if (pathValue.contains("chat:$idChat") == true) {
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
