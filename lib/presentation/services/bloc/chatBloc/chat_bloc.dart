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
  }) : super(LeavedChatState(userInformation: userInformation)) {
    on<InitializeChatEvent>((event, emit) {});
    on<GoToSettingChatEvent>(
      (event, emit) {
        emit(
          InsideSettingChatState(
            userInformation: event.userInformation,
          ),
        );
      },
    );
    on<BackToHomeChatEvent>(
      (event, emit) {
        emit(
          LeavedChatState(
            userInformation: event.userInformation,
          ),
        );
      },
    );
    on<GoToSearchFriendChatEvent>(
      (event, emit) {
        emit(
          InsideSearchChatState(userInformation: event.userInformation),
        );
      },
    );
  }
}
