// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:testsocketchatapp/data/models/user_info.dart';

import '../../../../data/models/chat_user_and_presence.dart';

abstract class ChatEvent {}

class JoinChatEvent extends ChatEvent {
  final ChatUserAndPresence chatUserAndPresence;
  JoinChatEvent({
    required this.chatUserAndPresence,
  });
}

class BackToWaitingChatEvent extends ChatEvent {
  final UserInformation userInformation;
  BackToWaitingChatEvent({
    required this.userInformation,
  });
}

class InitializeChatEvent extends ChatEvent {
  final UserInformation userInformation;
  InitializeChatEvent({
    required this.userInformation,
  });
}

class GoToSearchFriendChatEvent extends ChatEvent {
  final UserInformation userInformation;
  GoToSearchFriendChatEvent({
    required this.userInformation,
  });
}

class GoToMenuSettingEvent extends ChatEvent {
  final UserInformation userInformation;
  GoToMenuSettingEvent({
    required this.userInformation,
  });
}
