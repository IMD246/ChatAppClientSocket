// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:testsocketchatapp/data/models/user_info.dart';

abstract class ChatEvent {}

class JoinChatEvent extends ChatEvent {}

class LeaveChatEvent extends ChatEvent {}

class InitializeChatEvent extends ChatEvent {}

class LogoutChatEvent extends ChatEvent{
  final UserInformation userInformation;
  LogoutChatEvent({
    required this.userInformation,
  });
}
