import 'dart:developer';

import 'package:rxdart/rxdart.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:testsocketchatapp/data/models/chat_user_and_presence.dart';
import 'package:testsocketchatapp/data/models/message.dart';

class MessageManager {
  final io.Socket socket;
  final BehaviorSubject<ChatUserAndPresence> chatSubject =
      BehaviorSubject<ChatUserAndPresence>();
  MessageManager({
    required this.socket,
  });
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
    // disconnect
    // socket.onDisconnect(
    //   (data) {
    //     log("socketio Server disconnected");
    //   },
    // );
    // socket.on("helloclient", (data) => log(data));
  }

  void emitLeaveChat(String chatID, String userID) {
    socket.emit("LeaveChat", {
      "chatID": chatID,
      "userID": userID,
    });
  }

  void sendMessage(Message message,String chatID) {
    socket.emit("clientSendMessage",{
      "chatID":chatID,
      "userID":message.userID,
      "message":message.message,
      "urlImageMessage":message.urlImageMessage,
      "urlRecordMessage":message.urlRecordMessage,
      "typeMessage":message.typeMessage,
      "messageStatus":message.messageStatus,
    });
  }
}
