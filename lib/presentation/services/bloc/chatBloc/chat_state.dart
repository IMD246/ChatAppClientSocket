import 'package:testsocketchatapp/data/models/user_info.dart';

abstract class ChatState {}

class BackToWaitingChatState extends ChatState {
  final UserInformation userInformation;
  BackToWaitingChatState({
    required this.userInformation,
  });
}

class JoinedChatState extends ChatState {}
class WentToSettingMenuChatState extends ChatState{
  final UserInformation userInformation;
  WentToSettingMenuChatState({
    required this.userInformation,
  });
}
