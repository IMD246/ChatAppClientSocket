// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:rxdart/rxdart.dart';

import 'package:testsocketchatapp/data/models/chat_user_and_presence.dart';
import 'package:testsocketchatapp/data/models/user_info.dart';
import 'package:testsocketchatapp/presentation/services/bloc/chatBloc/chat_manager.dart';

abstract class ChatState {
  final ChatManager chatManager;
  ChatState({
    required this.chatManager,
  });
}

class BackToWaitingChatState extends ChatState {
  final UserInformation userInformation;
  final BehaviorSubject<List<ChatUserAndPresence>> listChatController;
  BackToWaitingChatState({
    required this.userInformation,
    required this.listChatController,
    required ChatManager chatManager,
  }) : super(chatManager: chatManager);
}

class JoinedChatState extends ChatState {
  final ChatUserAndPresence chatUserAndPresence;
  final UserInformation userInformation;
  JoinedChatState({
    required this.chatUserAndPresence,
    required this.userInformation,
    required ChatManager chatManager,
  }) : super(chatManager: chatManager);
}

class WentToSettingMenuChatState extends ChatState {
  final UserInformation userInformation;
  WentToSettingMenuChatState({
    required this.userInformation,
    required ChatManager chatManager,
  }) : super(chatManager: chatManager);
}

class WentToSearchChatState extends ChatState {
  final UserInformation userInformation;
  WentToSearchChatState({
    required this.userInformation,
    required ChatManager chatManager,
  }) : super(chatManager: chatManager);
}
