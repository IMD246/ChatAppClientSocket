import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:testsocketchatapp/data/models/chat_user_and_presence.dart';
import 'package:testsocketchatapp/data/models/user_info.dart';
import 'package:testsocketchatapp/data/repositories/user_repository.dart';
import 'package:testsocketchatapp/presentation/services/bloc/chatBloc/chat_manager.dart';

abstract class ChatState {
  final ChatManager chatManager;
  ChatState({
    required this.chatManager,
  });
}

class BackToWaitingChatState extends ChatState with EquatableMixin {
  final UserInformation userInformation;
  final BehaviorSubject<List<ChatUserAndPresence>> listChatController;
  BackToWaitingChatState({
    required this.userInformation,
    required this.listChatController,
    required ChatManager chatManager,
  }) : super(chatManager: chatManager);

  @override
  List<Object?> get props => [userInformation, chatManager];
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
  final UserRepository userRepository;
  WentToSearchChatState({
    required this.userRepository,
    required this.userInformation,
    required ChatManager chatManager,
  }) : super(chatManager: chatManager);
}
