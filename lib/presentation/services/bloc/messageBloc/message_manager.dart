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
  MessageManager({
    required this.socket,
    required UserPresence userPresence,
    required List<Message> listMessage,
  }) {
    initValue(userPresence: userPresence, listMessage: listMessage);
    listenSocket();
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
      },
    );

    // Connect error
    socket.onConnectError(
      (data) {
        log("connection failed + $data");
      },
    );
    getMessage();
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
  }

  void sendMessage(Message message, String chatID) {
    socket.emit("clientSendMessage", {
      "chatID": chatID,
      "userID": message.userID,
      "message": message.message,
      "urlImageMessage": message.urlImageMessage,
      "urlRecordMessage": message.urlRecordMessage,
      "typeMessage": message.typeMessage,
      "messageStatus": message.messageStatus,
    });
  }
}
