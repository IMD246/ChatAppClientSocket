import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testsocketchatapp/data/models/chat_message.dart';
import 'package:testsocketchatapp/data/models/chat_user_and_presence.dart';
import 'package:testsocketchatapp/presentation/enum/enum.dart';
import 'package:testsocketchatapp/presentation/services/bloc/messageBloc/message_bloc.dart';
import 'package:testsocketchatapp/presentation/services/bloc/messageBloc/message_event.dart';
import 'package:testsocketchatapp/presentation/views/messageChat/components/listview_message.dart';
import 'package:testsocketchatapp/presentation/views/widgets/observer.dart';

class BodyMessageChat extends StatefulWidget {
  const BodyMessageChat(
      {Key? key, required this.messages, required this.chatUserAndPresence})
      : super(key: key);
  final Stream<List<ChatMessage>> messages;
  final ChatUserAndPresence chatUserAndPresence;
  @override
  State<BodyMessageChat> createState() => _BodyMessageChatState();
}

class _BodyMessageChatState extends State<BodyMessageChat> {
  late final FocusNode focusNode;
  late final TextEditingController textController;
  @override
  void initState() {
    focusNode = FocusNode();
    textController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final messageBloc = context.read<MessageBloc>();
    return Column(
      children: [
        Expanded(
          child: Observer<List<ChatMessage>>(
            onSuccess: (context, data) {
              final messages = data ?? [];
              return ListViewMessage(messages: messages);
            },
            stream: widget.messages,
          ), 
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 4.w,
            vertical: 8.h,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF00BF6D).withOpacity(0.1),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 4),
                blurRadius: 32,
                color: const Color(0xFF087949).withOpacity(0.08),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00BF6D).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(40.w),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            maxLines: null,
                            controller: textController,
                            decoration: const InputDecoration(
                              labelStyle: TextStyle(
                                decoration: TextDecoration.none,
                                color: Colors.red,
                              ),
                              hintText: "Type message",
                              hintStyle: TextStyle(
                                color: Colors.green,
                              ),
                              border: InputBorder.none,
                            ),
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (textController.text.isNotEmpty) {
                      final String value = textController.text;
                      textController.clear();
                      context.read<MessageBloc>().add(
                            SendTextMessageEvent(
                              chatID:
                                  widget.chatUserAndPresence.chat?.sId ?? "",
                              message: ChatMessage(
                                userID: messageBloc.userInformation.user!.sId,
                                message: value,
                                messageStatus: "Sent",
                                stampTimeMessage: DateTime.now().toString(),
                                typeMessage: TypeMessage.text.name,
                                urlImageMessage: [],
                                urlRecordMessage: "",
                              ),
                            ),
                          );
                    }
                  },
                  icon: const Icon(
                    Icons.send,
                    color: Color(0xFF00BF6D),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
