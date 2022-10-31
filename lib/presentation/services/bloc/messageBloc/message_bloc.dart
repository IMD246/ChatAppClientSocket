import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:testsocketchatapp/data/models/chat_user_and_presence.dart';
import 'package:testsocketchatapp/presentation/services/bloc/chatBloc/chat_manager.dart';
import 'package:testsocketchatapp/presentation/services/bloc/messageBloc/message_event.dart';
import 'package:testsocketchatapp/presentation/services/bloc/messageBloc/message_manager.dart';
import 'package:testsocketchatapp/presentation/services/bloc/messageBloc/message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final MessageManager messageManager;
  final BehaviorSubject<ChatUserAndPresence> chatUserAndPresenceSubject =
      BehaviorSubject<ChatUserAndPresence>();
  MessageBloc(this.messageManager)
      : super(
          InsideMessageState(
            $chatUserAndPresence: BehaviorSubject<ChatUserAndPresence>().stream,
          ),
        ) {
    on<InitializingMessageEvent>((event, emit) {
      chatUserAndPresenceSubject.add(event.chatUserAndPresence);
      emit(
        InsideMessageState(
          $chatUserAndPresence: chatUserAndPresenceSubject.stream,
        ),
      );
    });
    on<LeaveChatMessageEvent>(
      (event, emit) {
        messageManager.emitLeaveChat(event.chatID, event.userID);
        emit(
          LeavedChatMessageState(
            $chatUserAndPresence: chatUserAndPresenceSubject.stream,
          ),
        );
      },
    );
    on<SendTextMessageEvent>(
      (event, emit) {
        messageManager.sendMessage(event.message, event.chatID);
      },
    );
  }
}
