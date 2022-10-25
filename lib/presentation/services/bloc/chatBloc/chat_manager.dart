import 'package:socket_io_client/socket_io_client.dart' as io;

class ChatManager {
  final io.Socket socket;
  ChatManager({
    required this.socket,
  });
}
