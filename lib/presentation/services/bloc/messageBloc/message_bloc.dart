import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testsocketchatapp/data/models/chat_user_and_presence.dart';
import 'package:testsocketchatapp/data/models/user_info.dart';
import 'package:testsocketchatapp/presentation/services/bloc/messageBloc/message_event.dart';
import 'package:testsocketchatapp/presentation/services/bloc/messageBloc/message_manager.dart';
import 'package:testsocketchatapp/presentation/services/bloc/messageBloc/message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final MessageManager messageManager;
  final UserInformation userInformation;
  final ChatUserAndPresence chatUserAndPresence;
  MessageBloc(
      this.messageManager, this.userInformation, this.chatUserAndPresence)
      : super(
          InsideMessageState(
            messageManager: messageManager,
            userInformation: userInformation,
          ),
        ) {
    messageManager.listenSocket();
    on<InitializingMessageEvent>((event, emit) {
      emit(
        InsideMessageState(
            userInformation: userInformation, messageManager: messageManager),
      );
    });
    on<LeaveChatMessageEvent>(
      (event, emit) {
        emit(
          LeavedChatMessageState(
            messageManager: messageManager,
            userInformation: userInformation,
          ),
        );
      },
    );
    on<SendTextMessageEvent>(
      (event, emit) async {
        if (messageManager.chatMessages.isEmpty) {
          messageManager.updateActiveChat();
        }
        messageManager.sendMessage(
            event.message,
            event.chatID,
            chatUserAndPresence.chat!.users!,
            chatUserAndPresence.user!.deviceToken!,
            userInformation.user?.name ?? "",
            userInformation.user?.urlImage ?? "",
            userInformation.user!.sId!,
            chatUserAndPresence.user!.sId!);
      },
    );
  }
}
