import 'dart:developer';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../../../../data/models/user_info.dart';

class SettingManager {
  final io.Socket socket;
  final UserInformation userInfomation;
  SettingManager({required this.socket, required this.userInfomation});

  listenSocket() {
    onConnect();

    // Connect error
    onConnectError();
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

}
