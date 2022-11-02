import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:testsocketchatapp/data/models/chat_user_and_presence.dart';
import 'package:testsocketchatapp/data/models/user_info.dart';
import 'package:testsocketchatapp/data/repositories/user_repository.dart';
import 'package:testsocketchatapp/presentation/services/bloc/chatBloc/chat_event.dart';
import 'package:testsocketchatapp/presentation/services/bloc/chatBloc/chat_manager.dart';
import 'package:testsocketchatapp/presentation/services/bloc/chatBloc/chat_state.dart';
import 'package:testsocketchatapp/presentation/utilities/validate.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatManager chatManager;
  final UserInformation userInformation;
  final UserRepository userRepository;
  ChatBloc({
    required this.userInformation,
    required this.chatManager,
    required this.userRepository,
  }) : super(
          BackToWaitingChatState(
            userInformation: userInformation,
            listChatController: BehaviorSubject<List<ChatUserAndPresence>>(),
            chatManager: chatManager,
          ),
        ) {
    chatManager.listenSocket();
    on<GoToMenuSettingEvent>(
      (event, emit) {
        emit(
          WentToSettingMenuChatState(
              userInformation: userInformation, chatManager: chatManager),
        );
      },
    );
    on<GoToSearchFriendChatEvent>(
      (event, emit) {
        emit(
          WentToSearchChatState(
            userInformation: userInformation,
            chatManager: chatManager,
            userRepository: userRepository,
          ),
        );
      },
    );
    on<BackToWaitingChatEvent>(
      (event, emit) {
        emit(
          BackToWaitingChatState(
              userInformation: userInformation,
              listChatController: chatManager.listChatController,
              chatManager: chatManager),
        );
      },
    );
    on<InitializeChatEvent>((event, emit) async {
      final chatResponse = await userRepository.getData(
        body: {"userID": event.userInformation.user?.sId ?? ""},
        urlAPI: userRepository.getChatsURL,
        headers: {'Content-Type': 'application/json'},
      );
      if (ValidateUtilities.checkBaseResponse(baseResponse: chatResponse)) {
        final listChat =
            userRepository.convertDynamicToList(value: chatResponse!);
        chatManager.listChatController.add(listChat);
        chatManager.listChat = listChat;
      } else {
        chatManager.listChatController.add([]);
      }
      emit(
        BackToWaitingChatState(
            userInformation: userInformation,
            listChatController: chatManager.listChatController,
            chatManager: chatManager),
      );
    });
    on<JoinChatEvent>((event, emit) {
      emit(
        JoinedChatState(
            chatUserAndPresence: event.chatUserAndPresence,
            userInformation: userInformation,
            chatManager: chatManager),
      );
    });
  }
}
