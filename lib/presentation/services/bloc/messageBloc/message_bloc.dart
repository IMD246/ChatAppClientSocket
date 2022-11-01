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
  MessageBloc(this.messageManager, this.userInformation, this.chatUserAndPresence)
      : super(
          InsideMessageState($messages: messageManager.listMessageSubject.stream, userInformation: userInformation, userPresence: messageManager.userPresenceSubject.stream
          ),
        ) {
    on<InitializingMessageEvent>((event, emit) {
      emit(
        InsideMessageState(
          $messages: messageManager.listMessageSubject.stream, userInformation: userInformation, userPresence: messageManager.userPresenceSubject.stream
        ),
      );
    });
    on<LeaveChatMessageEvent>(
      (event, emit) {
        messageManager.emitLeaveChat(event.chatID, event.userID);
        emit(
          LeavedChatMessageState(
            $messages: messageManager.listMessageSubject.stream, userInformation: userInformation, userPresence: messageManager.userPresenceSubject.stream
          ),
        );
      },
    );
    on<SendTextMessageEvent>(
      (event, emit) {
        messageManager.sendMessage(event.message, event.chatID,chatUserAndPresence.chat!.users!);
      },
    );
  }
}
