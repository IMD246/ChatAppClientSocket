import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:testsocketchatapp/data/models/chat.dart';
import 'package:testsocketchatapp/data/models/chat_message.dart';
import 'package:testsocketchatapp/data/models/user_presence.dart';
import 'package:testsocketchatapp/presentation/enum/enum.dart';
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
  final String ownerUserID;
  late UserPresence userPresence;
  MessageManager({
    required this.socket,
    required this.userPresence,
    required this.chatID,
    required this.chatMessageRepository,
    required this.chat,
    required this.ownerUserID,
  }) {
    scrollController = ScrollController();

    initValue(userPresence: userPresence);
  }
  initValue({required UserPresence userPresence}) {
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
    emitUpdateSentMessages();
    listChatMessagesSubject.add(chatMessages);
  }

  listenSocket() {
    onConnect();

    // Connect error
    onConnectError();

    getMessage();

    userOnline();

    userDisconnected();

    getMessagesUpdated();

    userLoggedOut();
  }

  void onConnect() {
    return socket.onConnect(
      (data) {
        log("Connection established");
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

  void userOnline() {
    socket.on("userOnline", (data) {
      log("start received Message");
      final presence = UserPresence.fromJson(data["presence"]);
      if (userPresence.sId == presence.sId) {
        userPresence = presence;
        userPresenceSubject.add(userPresence);
      }
    });
  }

  void userDisconnected() {
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

  void userLoggedOut() {
    socket.on("userLoggedOut", (data) {
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
        if (chatMessage.userID == ownerUserID) {
          await scrollController.animateTo(
            0.0,
            duration: const Duration(milliseconds: 1),
            curve: Curves.bounceIn,
          );
        }
      }
      if (chatMessage.userID! != ownerUserID) {
        emitUpdateSentMessages();
      }
    });
  }

  void getMessagesUpdated() {
    socket.on("receiveMessagesUpdated", (data) {
      final List<dynamic> listMessagesUpdated = data["ListIDMessage"];
      if (listMessagesUpdated.isNotEmpty) {
        fetchChatMessages(chatID: chatID);
      }
    });
  }

  void updateActiveChat() {
    socket.emit("sendActiveChat", {"chatID": chatID});
  }

  void emitUpdateSentMessages() {
    if (chatMessages.isNotEmpty) {
      final getLastMessage = chatMessages.elementAt(chatMessages.length - 1);
      if (getLastMessage.userID != ownerUserID &&
          getLastMessage.messageStatus!.toLowerCase() ==
              MessageStatus.sent.name.toLowerCase()) {
        socket.emit(
          "updateSentMessages",
          {"chatID": chatID, "userID": ownerUserID},
        );
      }
    }
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

  Future<void> dispose() async {
    await userPresenceSubject.drain();
    await userPresenceSubject.close();
    await listChatMessagesSubject.drain();
    await listChatMessagesSubject.close();
  }
}
