import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testsocketchatapp/presentation/services/bloc/messageBloc/message_event.dart';
import 'package:testsocketchatapp/presentation/services/bloc/messageBloc/message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  MessageBloc() : super(InsideMessageState()) {
    on<InitializingMessageEvent>((event, emit) {
      emit(InsideMessageState());
    });
  }
}
