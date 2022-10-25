// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:testsocketchatapp/data/models/user_info.dart';

abstract class ChatEvent {}

class JoinChatEvent extends ChatEvent {}

class LeaveChatEvent extends ChatEvent {}

class InitializeChatEvent extends ChatEvent {}

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
