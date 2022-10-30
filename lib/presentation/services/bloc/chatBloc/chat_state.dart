// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:rxdart/rxdart.dart';

import 'package:testsocketchatapp/data/models/chat_user_and_presence.dart';
import 'package:testsocketchatapp/data/models/user_info.dart';

abstract class ChatState {}

class BackToWaitingChatState extends ChatState {
  final UserInformation userInformation;
  final BehaviorSubject<List<ChatUserAndPresence>> listChatController;
  BackToWaitingChatState({
    required this.userInformation,
    required this.listChatController, 
  });
}
class JoinedChatState extends ChatState {
  final ChatUserAndPresence chatUserAndPresence;
  final UserInformation userInformation;
  JoinedChatState({
    required this.chatUserAndPresence,
    required this.userInformation,
  });
}

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
