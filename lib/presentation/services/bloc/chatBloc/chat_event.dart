import 'package:testsocketchatapp/data/models/user_info.dart';

abstract class ChatEvent {}

class JoinChatEvent extends ChatEvent {}

class BackToWaitingChatEvent extends ChatEvent {
  final UserInformation userInformation;
  BackToWaitingChatEvent({
    required this.userInformation,
  });
}

class InitializeChatEvent extends ChatEvent {}

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
