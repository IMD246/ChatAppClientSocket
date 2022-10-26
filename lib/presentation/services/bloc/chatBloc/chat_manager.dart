import 'dart:developer';

import 'package:socket_io_client/socket_io_client.dart' as io;

class ChatManager {
  final io.Socket socket;
  ChatManager({
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
    socket.on("helloclient", (data) => log(data));
  }
}
