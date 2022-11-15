import 'package:testsocketchatapp/data/models/user_info.dart';
import 'package:testsocketchatapp/presentation/services/bloc/messageBloc/message_manager.dart';

abstract class MessageState {
  final MessageManager messageManager;
  final UserInformation userInformation;
  MessageState({required this.messageManager,required this.userInformation});
}

class InsideMessageState extends MessageState {
  InsideMessageState(
      {
      required super.userInformation,
      required super.messageManager});
}

class LeavedChatMessageState extends MessageState {
  LeavedChatMessageState(
       {
      required super.userInformation,
      required super.messageManager});
}
