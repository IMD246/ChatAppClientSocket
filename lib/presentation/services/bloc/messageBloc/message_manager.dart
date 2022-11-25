import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:testsocketchatapp/data/models/chat.dart';
import 'package:testsocketchatapp/data/models/chat_message.dart';
import 'package:testsocketchatapp/data/models/user.dart';
import 'package:testsocketchatapp/data/models/user_presence.dart';
import 'package:testsocketchatapp/presentation/enum/enum.dart';
import 'package:testsocketchatapp/presentation/utilities/validate.dart';

import '../../../../data/repositories/chat_message_repository.dart';

class MessageManager {
  final io.Socket socket;
  late BehaviorSubject<UserPresence> _userPresenceSubject;
  late BehaviorSubject<List<ChatMessage>> _listChatMessagesSubject;
  late BehaviorSubject<Chat> _chatSubject;
  late BehaviorSubject<User> _userSubject;
  Stream<Chat> get streamChat => _chatSubject.stream;
  Stream<User> get streamUser => _userSubject.stream;
  Stream<UserPresence> get streamUserPresence => _userPresenceSubject.stream;
  Stream<List<ChatMessage>> get streamListChatMessage => _listChatMessagesSubject.stream; 
  late User user;
  final ChatMessageRepository chatMessageRepository;
  Chat chat = Chat();
  List<ChatMessage> chatMessages = [];
  late ScrollController scrollController;
  final String ownerUserID;
  late UserPresence userPresence;
  int count = 0;
  MessageManager({
    required this.socket,
    required this.userPresence,
    required this.chatMessageRepository,
    required this.chat,
    required this.ownerUserID,
    required this.user,
  }) {
    scrollController = ScrollController();

    initValue(userPresence: userPresence);
  }
  initValue({required UserPresence userPresence}) {
    _chatSubject = BehaviorSubject<Chat>();
    _userPresenceSubject = BehaviorSubject<UserPresence>();
    _listChatMessagesSubject = BehaviorSubject<List<ChatMessage>>();
    _userSubject = BehaviorSubject<User>();
    _userPresenceSubject.add(userPresence);
    _chatSubject.add(chat);
    _userSubject.add(user);
    fetchChatMessages();
  }

  fetchChatMessages() async {
    final response = await chatMessageRepository.getData(
      body: {"chatID": chat.sId},
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
    _listChatMessagesSubject.add(chatMessages);
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

    receiveNameUser();

    reConnected();
    
    updateActiveChat();
  }

  void onConnect() {
    return socket.onConnect(
      (data) {},
    );
  }

  void reConnected() async {
    socket.on("reload", (data) async {
      bool reload = data["reloadData"] as bool;
      if (reload) {
        log("start load data");
        await fetchChatMessages();
      }
    });
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
        _userPresenceSubject.add(userPresence);
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
        _userPresenceSubject.add(userPresence);
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
        _userPresenceSubject.add(userPresence);
      }
    });
  }

  void receiveNameUser() {
    socket.on("receiveNameUser", (data) {
      log("start received Name User");
      final String userID = data["userID"];
      final String newName = data["name"];
      if (user.sId == userID) {
        user.name = newName;
        _userSubject.add(user);
      }
    });
  }

  void getMessage() {
    socket.on("serverSendMessage", (data) async {
      final chatMessage = ChatMessage.fromJson(data);
      chatMessages.add(chatMessage);
      _listChatMessagesSubject.add(chatMessages);
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

  void updateActiveChat() {
    socket.on("receiveActiveChat", (data) {
      if (chat.sId == data["chatID"]) {
        chat.active = true;
        _chatSubject.add(chat);
      }
    });
  }

  void getMessagesUpdated() {
    socket.on("receiveMessagesUpdated", (data) {
      final List<dynamic> listMessagesUpdated = data["ListIDMessage"];
      if (listMessagesUpdated.isNotEmpty) {
        fetchChatMessages();
      }
    });
  }

  void sendActiveChat() {
    socket.emit("sendActiveChat", {"chatID": chat.sId});
  }

  void emitUpdateSentMessages() {
    if (chatMessages.isNotEmpty) {
      final getLastMessage = chatMessages.elementAt(chatMessages.length - 1);
      if (getLastMessage.userID != ownerUserID &&
          getLastMessage.messageStatus!.toLowerCase() ==
              MessageStatus.sent.name.toLowerCase()) {
        socket.emit(
          "updateSentMessages",
          {"chatID": chat.sId, "userID": ownerUserID},
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
    await _userPresenceSubject.drain();
    await _userPresenceSubject.close();
    await _listChatMessagesSubject.drain();
    await _listChatMessagesSubject.close();
  }
}
