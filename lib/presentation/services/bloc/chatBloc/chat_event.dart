import 'package:testsocketchatapp/data/models/user_info.dart';

abstract class ChatEvent {}

class JoinChatEvent extends ChatEvent {}

class LeaveChatEvent extends ChatEvent {}

class InitializeChatEvent extends ChatEvent {}

class GoToSearchFriendChatEvent extends ChatEvent {
  final UserInformation userInformation;
  GoToSearchFriendChatEvent({
    required this.userInformation,
  });
}

class GoToSettingChatEvent extends ChatEvent {
  final UserInformation userInformation;
  GoToSettingChatEvent({
    required this.userInformation,
  });
}
class BackToHomeChatEvent extends ChatEvent{
   final UserInformation userInformation;
  BackToHomeChatEvent({
    required this.userInformation,
  });
}
class GoToUpdateInfoChatEvent extends ChatEvent {}

class GoToUpdateThemeModeChatEvent extends ChatEvent {}
