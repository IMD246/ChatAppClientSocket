import 'package:testsocketchatapp/data/models/chat_user_and_presence.dart';

abstract class MessageState {
  final Stream<ChatUserAndPresence> $chatUserAndPresence;
  MessageState({required this.$chatUserAndPresence});
}

class InsideMessageState extends MessageState {
  InsideMessageState({required super.$chatUserAndPresence});
}
class LeavedChatMessageState extends MessageState {
  LeavedChatMessageState({required super.$chatUserAndPresence});
}