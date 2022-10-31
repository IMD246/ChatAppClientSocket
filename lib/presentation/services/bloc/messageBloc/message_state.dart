import 'package:testsocketchatapp/data/models/user_info.dart';
import 'package:testsocketchatapp/data/models/user_presence.dart';

import '../../../../data/models/message.dart';

abstract class MessageState {
  final Stream<List<Message>> $messages;
  final UserInformation userInformation;
  final Stream<UserPresence> userPresence;
  MessageState({required this.$messages,required this.userInformation, required this.userPresence});
}

class InsideMessageState extends MessageState {
  InsideMessageState({required super.$messages, required super.userInformation, required super.userPresence});
  
}

class LeavedChatMessageState extends MessageState {
  LeavedChatMessageState({required super.$messages, required super.userInformation, required super.userPresence});
}
