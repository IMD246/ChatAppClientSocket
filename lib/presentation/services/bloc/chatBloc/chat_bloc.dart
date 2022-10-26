import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testsocketchatapp/data/models/user_info.dart';
import 'package:testsocketchatapp/presentation/services/bloc/chatBloc/chat_event.dart';
import 'package:testsocketchatapp/presentation/services/bloc/chatBloc/chat_manager.dart';
import 'package:testsocketchatapp/presentation/services/bloc/chatBloc/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatManager chatManager;
  final UserInformation userInformation;
  ChatBloc({
    required this.userInformation,
    required this.chatManager,
  }) : super(
          BackToWaitingChatState(
            userInformation: userInformation,
          ),
        ) {
    chatManager.listenSocket();
    on<GoToMenuSettingEvent>(
      (event, emit) {
        emit(
          WentToSettingMenuChatState(
            userInformation: userInformation,
          ),
        );
      },
    );
    on<GoToSearchFriendChatEvent>(
      (event, emit) {
        emit(
          WentToSearchChatState(
            userInformation: userInformation,
          ),
        );
      },
    );
    on<BackToWaitingChatEvent>(
      (event, emit) {
        chatManager.socket.emit("hello", "hello1");
        emit(
          BackToWaitingChatState(
            userInformation: userInformation,
          ),
        );
      },
    );
    on<InitializeChatEvent>((event, emit) {});
  }
}
