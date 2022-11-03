import 'dart:developer';

import 'package:rxdart/rxdart.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:testsocketchatapp/data/models/message.dart';
import 'package:testsocketchatapp/data/models/user_presence.dart';

class MessageManager {
  final io.Socket socket;
  final BehaviorSubject<UserPresence> userPresenceSubject =
      BehaviorSubject<UserPresence>();
  final BehaviorSubject<List<Message>> listMessageSubject =
      BehaviorSubject<List<Message>>();
  List<Message> messages = [];
  final String chatID;
  late UserPresence userPresence;
  MessageManager(
      {required this.socket,
      required this.userPresence,
      required List<Message> listMessage,
      required this.chatID}) {
    initValue(userPresence: userPresence, listMessage: listMessage);
  }
  initValue(
      {required UserPresence userPresence,
      required List<Message> listMessage}) {
    userPresenceSubject.add(userPresence);
    messages = listMessage;
    listMessageSubject.add(listMessage);
  }

  listenSocket() {
    socket.onConnect(
      (data) {
        log("Connection established");
        emitJoinChat();
      },
    );

    // Connect error
    socket.onConnectError(
      (data) {
        log("connection failed + $data");
      },
    );
    emitJoinChat();
    getMessage();
    socket.on("userOnline", (data) {
      log("start received Message");
      final presence = UserPresence.fromJson(data["presence"]);
      if (userPresence.sId == presence.sId) {
        userPresence = presence;
        userPresenceSubject.add(userPresence);
      }
    });
    socket.on("userDisconnected", (data) {
      log("start received Message");
      final presence = UserPresence.fromJson(data["presence"]);
      presence.presenceTimeStamp = DateTime.now().toString();
      if (userPresence.sId == presence.sId) {
        userPresence = presence;
        userPresenceSubject.add(userPresence);
      }
    });
  }

  void getMessage() {
    socket.on("serverSendMessage", (data) {
      messages.add(Message.fromJson(data));
      listMessageSubject.add(messages);
    });
  }

  void emitLeaveChat(String chatID, String userID) {
    socket.emit("LeaveChat", {
      "chatID": chatID,
      "userID": userID,
    });
    messages = [];
    listMessageSubject.add([]);
  }

  void emitJoinChat() {
    if (chatID.isNotEmpty) {
      socket.emit("JoinChat", {
        "chatID": chatID,
      });
    }
  }

  void sendMessage(Message message, String chatID, List<String> usersID) {
    socket.emit("clientSendMessage", {
      "chatID": chatID,
      "userID": message.userID,
      "message": message.message,
      "urlImageMessage": message.urlImageMessage,
      "urlRecordMessage": message.urlRecordMessage,
      "typeMessage": message.typeMessage,
      "messageStatus": message.messageStatus,
      "usersID": usersID,
    });
  }

  void dispose() {}
}
