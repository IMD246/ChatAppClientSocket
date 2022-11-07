import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:testsocketchatapp/data/models/chat_user_and_presence.dart';
import 'package:testsocketchatapp/data/models/message.dart';
import 'package:testsocketchatapp/data/models/user_presence.dart';

class MessageManager {
  final io.Socket socket;
  late BehaviorSubject<UserPresence> userPresenceSubject;
  late BehaviorSubject<List<Message>> listMessageSubject;
  List<Message> messages = [];
  late ScrollController scrollController;
  final String chatID;
  late UserPresence userPresence;
  MessageManager(
      {required this.socket,
      required this.userPresence,
      required List<Message> listMessage,
      required this.chatID}) {
    scrollController = ScrollController();

    initValue(userPresence: userPresence, listMessage: listMessage);
  }
  initValue(
      {required UserPresence userPresence,
      required List<Message> listMessage}) {
    userPresenceSubject = BehaviorSubject<UserPresence>();
    listMessageSubject = BehaviorSubject<List<Message>>();
    messages = listMessage;
    userPresenceSubject.add(userPresence);
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
    socket.on("serverSendMessage", (data) async {
      final message = Message.fromJson(data);
      messages.add(message);
      listMessageSubject.add(messages);
      if (scrollController.hasClients) {
        await scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 1),
          curve: Curves.bounceIn,
        );
      }
    });
  }

  void emitLeaveChat(String chatID, String userID) {
    socket.emit("LeaveChat", {
      "chatID": chatID,
      "userID": userID,
    });
    // messages = [];
    // listMessageSubject.add([]);
  }

  void emitJoinChat() {
    if (chatID.isNotEmpty) {
      socket.emit("JoinChat", {
        "chatID": chatID,
      });
    }
  }

  void emitNewChat({required ChatUserAndPresence chatUserAndPresence}) {
    socket.emit("clientSendNewChat", {
      "chatUserAndPresence": chatUserAndPresence,
      "usersChat": chatUserAndPresence.chat!.users
    });
  }

  void sendMessage(Message message, String chatID, List<String> usersID,
      String deviceToken, String nameSender, String urlImageSender,String userIDSender,String userIDReceiver) {
    socket.emit("clientSendMessage", {
      "chatID": chatID,
      "userID": message.userID,
      "message": message.message,
      "urlImageMessage": message.urlImageMessage,
      "urlRecordMessage": message.urlRecordMessage,
      "typeMessage": message.typeMessage,
      "messageStatus": message.messageStatus,
      "usersID": usersID,
      "deviceToken": deviceToken,
      "nameSender": nameSender,
      "urlImageSender": urlImageSender,
      "userIDSender": userIDSender,
      "userIDReceiver": userIDReceiver
    });
  }

  void dispose() async {
    await userPresenceSubject.drain();
    await userPresenceSubject.close();
    await listMessageSubject.drain();
    await listMessageSubject.close();
  }
}
