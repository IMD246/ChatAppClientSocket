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
  late final BehaviorSubject<List<ChatUserAndPresence>> listChatController =
      BehaviorSubject<List<ChatUserAndPresence>>();
  late final $chats = listChatController.stream;
  ChatBloc({
    required this.userInformation,
    required this.chatManager,
    required this.userRepository,
  }) : super(
          BackToWaitingChatState(
            userInformation: userInformation,
            listChatController: BehaviorSubject<List<ChatUserAndPresence>>(),
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
            listChatController: listChatController,
          ),
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
        listChatController.add(listChat);
      } else {
        listChatController.add([]);
      }
      emit(
        BackToWaitingChatState(
          userInformation: userInformation,
          listChatController: listChatController,
        ),
      );
    });
    on<JoinChatEvent>((event, emit) {
      emit(
        JoinedChatState(
          chatUserAndPresence: event.chatUserAndPresence,
          userInformation: userInformation,
        ),
      );
    });
  }
}
