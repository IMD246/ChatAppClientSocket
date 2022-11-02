import 'dart:developer';

import 'package:rxdart/rxdart.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:testsocketchatapp/data/models/chat.dart';

import '../../../../data/models/chat_user_and_presence.dart';

class ChatManager {
  final io.Socket socket;
  final BehaviorSubject<List<ChatUserAndPresence>> listChatController =
      BehaviorSubject<List<ChatUserAndPresence>>();
  List<ChatUserAndPresence> listChat = [];
  final String userID;
  ChatManager({
    required this.socket,
    required this.userID,
  });
  listenSocket() {
    socket.onConnect(
      (data) {
        log("Connection established");
        emitLoggedInApp();
      },
    );

    // Connect error
    socket.onConnectError(
      (data) {
        log("connection failed + $data");
      },
    );

    // disconnect
    socket.onDisconnect(
      (data) {
        log("socketio Server disconnected");
      },
    );
    socket.on("receivedMessage", (data) {
      log("start received Message");
      final chat = Chat.fromJson(data["chat"]);
      for (var i = 0; i < listChat.length; i++) {
        if (chat.sId == listChat[i].chat!.sId) {
          listChat.elementAt(i).chat = chat;
          listChatController.add(listChat);
          log("check list chat element i new");
          log(listChat.elementAt(i).chat!.lastMessage!);
          break;
        }
      }
    });
  }

  void emitLoggedInApp() {
    if (userID.isNotEmpty) {
      socket.emit("LoggedIn", {
        "userID": userID,
      });
    }
  }
}
