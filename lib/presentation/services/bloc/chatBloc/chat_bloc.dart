import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:testsocketchatapp/data/models/chat_user_and_presence.dart';
import 'package:testsocketchatapp/presentation/services/bloc/chatBloc/chat_event.dart';
import 'package:testsocketchatapp/presentation/services/bloc/chatBloc/chat_manager.dart';
import 'package:testsocketchatapp/presentation/services/bloc/chatBloc/chat_state.dart';
import 'package:testsocketchatapp/presentation/services/notification/notification.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatManager chatManager;
  final NotificationService noti;
  ChatBloc({
    required this.chatManager,
    required this.noti,
  }) : super(
          InitializeChatState(
            listChatController: BehaviorSubject<List<ChatUserAndPresence>>(),
            chatManager: chatManager,
          ),
        ) {
    chatManager.listenSocket();
    on<GoToMenuSettingEvent>(
      (event, emit) {
        emit(
          WentToSettingMenuChatState(
            chatManager: chatManager,
          ),
        );
      },
    );
    on<GoToSearchFriendChatEvent>(
      (event, emit) {
        emit(
          WentToSearchChatState(
            chatManager: chatManager,
            userRepository: chatManager.userRepository,
          ),
        );
      },
    );
    on<BackToWaitingChatEvent>(
      (event, emit) {
        emit(
          BackToWaitingChatState(
              listChatController: chatManager.listChatController,
              chatManager: chatManager),
        );
      },
    );
    on<InitializeChatEvent>((event, emit) async {
      await chatManager.fetchChatData();
      emit(
        InitializeChatState(
          listChatController: chatManager.listChatController,
          chatManager: chatManager,
        ),
      );
    });
    on<JoinChatEvent>((event, emit) {
      emit(
        JoinedChatState(
            chatUserAndPresence: event.chatUserAndPresence,
            chatManager: chatManager),
      );
    });
  }
}
