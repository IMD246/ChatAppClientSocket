import 'package:testsocketchatapp/data/models/chat_user_and_presence.dart';
import 'package:testsocketchatapp/data/models/user_info.dart';

abstract class ChatState {}

class BackToWaitingChatState extends ChatState {
  final UserInformation userInformation;
  final Stream<List<ChatUserAndPresence>> chats;
  BackToWaitingChatState({
    required this.userInformation,
    required this.chats, 
  });
}

class JoinedChatState extends ChatState {}

class WentToSettingMenuChatState extends ChatState {
  final UserInformation userInformation;
  WentToSettingMenuChatState({
    required this.userInformation,
  });
}

class WentToSearchChatState extends ChatState {
  final UserInformation userInformation;
  WentToSearchChatState({
    required this.userInformation,
  });
}
