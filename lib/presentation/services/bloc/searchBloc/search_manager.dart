import 'dart:developer';

import 'package:socket_io_client/socket_io_client.dart' as io;

class SearchManager {
  final io.Socket socket;
  SearchManager({
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
    socket.onDisconnect(
      (data) {
        log("socketio Server disconnected");
      },
    );
  }

  void emitLoggedInApp(String userID) {
    if (userID.isNotEmpty) {
      socket.emit("LoggedIn", {
        "userID": userID,
      });
    }
  }

  void emitJoinChat(String chatID) {
    if (chatID.isNotEmpty) {
        socket.emit("JoinChat", {
          "chatID": chatID,
        });
    }
  }
}
