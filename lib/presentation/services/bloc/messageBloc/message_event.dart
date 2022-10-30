import 'package:testsocketchatapp/presentation/enum/enum.dart';

abstract class MessageEvent {}

class InitializingMessageEvent extends MessageEvent{
    
}
class SendTextMessageEvent extends MessageEvent {
  final String textMessage;
  final String userSenderID;
  final List<String> listUser;
  final TypeMessage typeMessage;
  final DateTime stampTimeMessage;
  
  SendTextMessageEvent({
    required this.textMessage,
    required this.userSenderID,
    required this.listUser,
    required this.typeMessage,
    required this.stampTimeMessage,
  });
}
