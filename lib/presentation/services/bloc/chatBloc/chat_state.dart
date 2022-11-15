import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:testsocketchatapp/data/models/chat_user_and_presence.dart';
import 'package:testsocketchatapp/data/repositories/user_repository.dart';
import 'package:testsocketchatapp/presentation/services/bloc/chatBloc/chat_manager.dart';

abstract class ChatState {
  final ChatManager chatManager;
  ChatState({
    required this.chatManager,
  });
}

class BackToWaitingChatState extends ChatState with EquatableMixin {
  final BehaviorSubject<List<ChatUserAndPresence>> listChatController;
  BackToWaitingChatState({
    required this.listChatController,
    required ChatManager chatManager,
  }) : super(chatManager: chatManager);

  @override
  List<Object?> get props => [chatManager];
}

class JoinedChatState extends ChatState {
  final ChatUserAndPresence chatUserAndPresence;
  JoinedChatState({
    required this.chatUserAndPresence,
    required ChatManager chatManager,
  }) : super(chatManager: chatManager);
}

class WentToSettingMenuChatState extends ChatState {
  WentToSettingMenuChatState({
    required ChatManager chatManager,
  }) : super(chatManager: chatManager);
}

class WentToSearchChatState extends ChatState {
  final UserRepository userRepository;
  WentToSearchChatState({
    required this.userRepository,
    required ChatManager chatManager,
  }) : super(chatManager: chatManager);
}
