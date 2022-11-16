import 'dart:developer';

import 'package:rxdart/rxdart.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:testsocketchatapp/data/models/chat.dart';
import 'package:testsocketchatapp/data/models/user_info.dart';
import 'package:testsocketchatapp/data/models/user_presence.dart';
import 'package:testsocketchatapp/data/repositories/user_repository.dart';

import '../../../../data/models/chat_user_and_presence.dart';
import '../../../utilities/validate.dart';

class ChatManager {
  final io.Socket socket;
  final BehaviorSubject<List<ChatUserAndPresence>> listChatController =
      BehaviorSubject<List<ChatUserAndPresence>>();
  List<ChatUserAndPresence> listChat = [];
  final UserInformation userInformation;
  final UserRepository userRepository;
  int count = 0;
  ChatManager({
    required this.socket,
    required this.userInformation,
    required this.userRepository,
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

    receiveNameUser();

    reConnected();
  }

  void onConnecet() {
    return socket.onConnect(
      (data) {
        log("Connection established");
        bool isRequestReloadData = count > 0 ? true : false;
        count++;
        emitLoggedInApp(isRequestReloadData: isRequestReloadData);
      },
    );
  }

  void reConnected() async {
    socket.on("reload", (data) async {
      bool reload = data["reloadData"] as bool;
      if (reload) {
        log("start load data");
        await fetchChatData();
      }
    });
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

  void emitLoggedInApp({required bool isRequestReloadData}) {
    if (userInformation.user!.sId!.isNotEmpty) {
      socket.emit("LoggedIn", {
        "userID": userInformation.user!.sId,
        "requestReloadData": isRequestReloadData
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

  Future<void> fetchChatData() async {
    final chatResponse = await userRepository.getData(
      body: {"userID": userInformation.user?.sId ?? ""},
      urlAPI: userRepository.getChatsURL,
      headers: {'Content-Type': 'application/json'},
    );
    if (ValidateUtilities.checkBaseResponse(baseResponse: chatResponse)) {
      listChat = userRepository.convertDynamicToList(value: chatResponse!);
      listChatController.add(listChat);
    } else {
      listChat = [];
      listChatController.add([]);
    }
  }
}
