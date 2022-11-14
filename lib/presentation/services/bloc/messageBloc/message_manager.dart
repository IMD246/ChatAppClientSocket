import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:testsocketchatapp/data/models/chat.dart';
import 'package:testsocketchatapp/data/models/chat_message.dart';
import 'package:testsocketchatapp/data/models/user_presence.dart';
import 'package:testsocketchatapp/presentation/utilities/validate.dart';

import '../../../../data/repositories/chat_message_repository.dart';

class MessageManager {
  final io.Socket socket;
  late BehaviorSubject<UserPresence> userPresenceSubject;
  late BehaviorSubject<List<ChatMessage>> listChatMessagesSubject;
  late BehaviorSubject<Chat> chatSubject;
  final ChatMessageRepository chatMessageRepository;
  Chat chat = Chat();
  List<ChatMessage> chatMessages = [];
  late ScrollController scrollController;
  final String chatID;
  late UserPresence userPresence;
  MessageManager(
      {required this.socket,
      required this.userPresence,
      required this.chatID,
      required this.chatMessageRepository,
      required this.chat}) {
    scrollController = ScrollController();

    initValue(userPresence: userPresence);
  }
  initValue({required UserPresence userPresence}) {
    log("check chat id $chatID");
    chatSubject = BehaviorSubject<Chat>();
    userPresenceSubject = BehaviorSubject<UserPresence>();
    listChatMessagesSubject = BehaviorSubject<List<ChatMessage>>();
    userPresenceSubject.add(userPresence);
    chatSubject.add(chat);
    fetchChatMessages(chatID: chatID);
  }

  fetchChatMessages({required String chatID}) async {
    final response = await chatMessageRepository.getData(
      body: {"chatID": chatID},
      urlAPI: chatMessageRepository.getChatMessagesURL,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    if (ValidateUtilities.checkBaseResponse(baseResponse: response)) {
      chatMessages =
          chatMessageRepository.convertDynamicToList(value: response!);
    } else {
      chatMessages = [];
    }
    listChatMessagesSubject.add(chatMessages);
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
    // emitJoinChat();
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
      final chatMessage = ChatMessage.fromJson(data);
      chatMessages.add(chatMessage);
      listChatMessagesSubject.add(chatMessages);
      if (scrollController.hasClients) {
        await scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 1),
          curve: Curves.bounceIn,
        );
      }
    });
  }

  void updateActiveChat() {
    socket.emit("sendActiveChat", {"chatID": chatID});
  }

  void sendMessage(
      ChatMessage message,
      String chatID,
      List<String> usersID,
      String deviceToken,
      String nameSender,
      String urlImageSender,
      String userIDSender,
      String userIDReceiver) {
    socket.emit("clientSendMessage", {
      "chatID": chatID,
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
    await listChatMessagesSubject.drain();
    await listChatMessagesSubject.close();
  }
}
