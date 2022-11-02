import 'dart:developer';

import 'package:socket_io_client/socket_io_client.dart' as io;

class ChatManager {
  final io.Socket socket;
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
      log(data["newMessage"]);
      log(data["timeLastMessage"]);
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
