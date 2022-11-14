import 'dart:developer';

import 'package:rxdart/rxdart.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:testsocketchatapp/data/models/chat.dart';
import 'package:testsocketchatapp/data/models/user_presence.dart';

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
    socket.on("userOnline", (data) {
      log("start received Message");
      final presence = UserPresence.fromJson(data["presence"]);
      for (var i = 0; i < listChat.length; i++) {
        if (presence.sId == listChat[i].presence!.sId) {
          listChat.elementAt(i).presence = presence;
          listChatController.add(listChat);
          log("check list presence element i new");
          log(listChat.elementAt(i).presence!.presence.toString());
          break;
        }
      }
    });
    socket.on("userDisconnected", (data) {
      log("start received Message");
      final presence = UserPresence.fromJson(data["presence"]);
      presence.presenceTimeStamp = DateTime.now().toString();
      for (var i = 0; i < listChat.length; i++) {
        if (presence.sId == listChat[i].presence!.sId) {
          listChat.elementAt(i).presence = presence;
          listChatController.add(listChat);
          log("check list presence element i new");
          log(listChat.elementAt(i).presence!.presence.toString());
          break;
        }
      }
    });
    socket.on("receiveNewChat", (data) {
      final newChat = ChatUserAndPresence.fromJson(data["chatUserAndPresence"]);
      listChat.add(newChat);
      listChatController.add(listChat);
    });
  }
   void updateActiveChat() {
    socket.on("receiveActiveChat", (data) {
      for (var i = 0; i < listChat.length; i++) {
        if (data["chatID"] == listChat[i].chat!.sId) {
          listChat.elementAt(i).chat!.active = true;
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
