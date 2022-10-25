// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:testsocketchatapp/data/models/user_info.dart';

abstract class ChatState {}

class LeavedChatState extends ChatState {
  final UserInformation userInformation;
  LeavedChatState({
    required this.userInformation,
  });
}

class JoinedChatState extends ChatState {}
