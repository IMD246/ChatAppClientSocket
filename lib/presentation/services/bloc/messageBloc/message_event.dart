import 'package:testsocketchatapp/data/models/chat_message.dart';
import 'package:testsocketchatapp/data/models/chat_user_and_presence.dart';
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
  final ChatMessage message;
  SendTextMessageEvent({required this.chatID, required this.message});
}
