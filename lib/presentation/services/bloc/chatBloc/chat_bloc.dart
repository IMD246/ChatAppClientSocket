import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:testsocketchatapp/data/models/chat_user_and_presence.dart';
import 'package:testsocketchatapp/data/repositories/user_repository.dart';
import 'package:testsocketchatapp/presentation/services/bloc/chatBloc/chat_event.dart';
import 'package:testsocketchatapp/presentation/services/bloc/chatBloc/chat_manager.dart';
import 'package:testsocketchatapp/presentation/services/bloc/chatBloc/chat_state.dart';
import 'package:testsocketchatapp/presentation/services/notification/notification.dart';
import 'package:testsocketchatapp/presentation/utilities/validate.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatManager chatManager;
  final UserRepository userRepository;
  final NotificationService noti;
  ChatBloc(
    {
    required this.chatManager,
    required this.userRepository,
    required this.noti, 
  }) : super(
          BackToWaitingChatState(
            listChatController: BehaviorSubject<List<ChatUserAndPresence>>(),
            chatManager: chatManager,
          ),
        ) {
    chatManager.listenSocket();
    on<GoToMenuSettingEvent>(
      (event, emit) {
        emit(
          WentToSettingMenuChatState(
              chatManager: chatManager,),
        );
      },
    );
    on<GoToSearchFriendChatEvent>(
      (event, emit) {
        emit(
          WentToSearchChatState(
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
            listChatController: chatManager.listChatController,
            chatManager: chatManager),
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
