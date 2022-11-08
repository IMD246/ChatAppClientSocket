import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:testsocketchatapp/data/models/chat_user_and_presence.dart';
import 'package:testsocketchatapp/data/models/environment.dart';
import 'package:testsocketchatapp/data/models/user_info.dart';
import 'package:testsocketchatapp/presentation/views/messageChat/message_chat_screen.dart';
import '../../../router/routers.dart';
import '../notification/notification.dart';

class ConfigAppProvider extends ChangeNotifier {
  final Environment env;
  NotificationService noti;
  final GlobalKey<NavigatorState> navigatorKey;
  ConfigAppProvider(
      {required this.env, required this.noti, required this.navigatorKey});

  handlerNotification({
    required BuildContext context,
    required List<ChatUserAndPresence> listChatUser,
    required Socket socket,
    required UserInformation userInformation,
  }) {
    noti.onNotificationClick.listen(
      (value) async {
        final navigator = Navigator.of(context);
        if (value != null) {
          log(value.toString());
          final namePath = RoutesHandler.getNamePath(globalKey: navigatorKey);
          final ChatUserAndPresence checkChatAvailable =
              listChatUser.firstWhere(
            (element) => element.chat!.sId == value["chatID"],
            orElse: () => ChatUserAndPresence(),
          );
          if (namePath != null) {
            if (checkChatAvailable.chat?.sId != null) {
              if (namePath == "/") {
                log("check get inside");
                await navigator.push(
                  MaterialPageRoute(
                    builder: (context) {
                      return MessageChatScreen(
                        socket: socket,
                        chatUserAndPresence: checkChatAvailable,
                        userInformation: userInformation,
                      );
                    },
                    settings: RouteSettings(
                      name: "chat:${checkChatAvailable.chat!.sId!}",
                    ),
                  ),
                );
              } else {
                _checkChatPageOrReplace(
                  namePath: namePath,
                  navigator: navigator,
                  socket: socket,
                  chatUserAndPresence: checkChatAvailable,
                  userInformation: userInformation,
                );
              }
            }
          }
          await noti.onNotificationClick.drain(null);
        }
      },
    );
  }

  _checkChatPageOrReplace({
    required String namePath,
    required NavigatorState navigator,
    required Socket socket,
    required ChatUserAndPresence chatUserAndPresence,
    required UserInformation userInformation,
  }) async {
    log("check full namePath");
    log(namePath);
    log(namePath.split(":").first);
    if (namePath.split(":").first == "chat") {
      final checkRoute = RoutesHandler.checkChatPage(
          pathValue: namePath, idChat: chatUserAndPresence.chat?.sId ?? "");
      if (!checkRoute) {
        await navigator.pushReplacement(
          MaterialPageRoute(
            builder: (context) {
              return MessageChatScreen(
                socket: socket,
                chatUserAndPresence: chatUserAndPresence,
                userInformation: userInformation,
              );
            },
            settings: RouteSettings(
              name: "chat:${chatUserAndPresence.chat!.sId!}",
            ),
          ),
        );
      }
    }
  }
}
