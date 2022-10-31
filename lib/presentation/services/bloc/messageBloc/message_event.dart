import 'package:testsocketchatapp/data/models/chat_user_and_presence.dart';
import 'package:testsocketchatapp/data/models/message.dart';
abstract class MessageEvent {}

class InitializingMessageEvent extends MessageEvent {
  final ChatUserAndPresence chatUserAndPresence;
  InitializingMessageEvent({
    required this.chatUserAndPresence,
  });
}

class LeaveChatMessageEvent extends MessageEvent {
  final String chatID;
  final String userID;
  LeaveChatMessageEvent({
    required this.chatID,
    required this.userID,
  });
}

class SendTextMessageEvent extends MessageEvent {
  final String chatID;
  final Message message;
  SendTextMessageEvent({required this.chatID, required this.message});
}
