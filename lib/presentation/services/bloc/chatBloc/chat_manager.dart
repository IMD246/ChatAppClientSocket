import 'dart:developer';

import 'package:rxdart/rxdart.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:testsocketchatapp/data/models/chat.dart';
import 'package:testsocketchatapp/data/models/user_info.dart';
import 'package:testsocketchatapp/data/models/user_presence.dart';

import '../../../../data/models/chat_user_and_presence.dart';

class ChatManager {
  final io.Socket socket;
  final BehaviorSubject<List<ChatUserAndPresence>> listChatController =
      BehaviorSubject<List<ChatUserAndPresence>>();
  List<ChatUserAndPresence> listChat = [];
  final UserInformation userInformation;
  ChatManager({
    required this.socket,
    required this.userInformation,
  });
  listenSocket() {
    onConnecet();
    // Connect error
    onConnectError();

    // disconnect
    onDisconnect();

    receivedMessage();

    userOnline();

    userDisconnected();

    receiveNewChat();

    userLoggedOut();

    emitLoggedInApp();

    receiveNameUser();
  }

  void onConnecet() {
    return socket.onConnect(
      (data) {
        log("Connection established");
        emitLoggedInApp();
      },
    );
  }

  void onDisconnect() {
    return socket.onDisconnect(
      (data) {
        log("socketio Server disconnected");
      },
    );
  }

  void onConnectError() {
    return socket.onConnectError(
      (data) {
        log("connection failed + $data");
      },
    );
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
    if (userInformation.user!.sId!.isNotEmpty) {
      socket.emit("LoggedIn", {
        "userID": userInformation.user!.sId,
      });
    }
  }

  void receivedMessage() {
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

  void userDisconnected() {
    socket.on("userDisconnected", (data) {
      log("start user Disconnected");
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
  }

  void receiveNameUser() {
    socket.on("receiveNameUser", (data) {
      log("start received Name User");
      final String userID = data["userID"];
      final String newName = data["name"];
      if (userInformation.user!.sId == userID) {
        userInformation.user!.name = newName;
      }
      for (var i = 0; i < listChat.length; i++) {
        if (userID == listChat[i].user!.sId) {
          listChat.elementAt(i).user!.name = newName;
          listChatController.add(listChat);
          log("check list presence element i new");
          log(listChat.elementAt(i).presence!.presence.toString());
          break;
        }
      }
    });
  }

  void userLoggedOut() {
    socket.on("userLoggedOut", (data) {
      log("start received user logged out");
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
  }

  void receiveNewChat() {
    socket.on("receiveNewChat", (data) {
      final newChat = ChatUserAndPresence.fromJson(data["chatUserAndPresence"]);
      listChat.add(newChat);
      listChatController.add(listChat);
    });
  }

  void userOnline() {
    socket.on("userOnline", (data) {
      log("start received user online");
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
  }
}
