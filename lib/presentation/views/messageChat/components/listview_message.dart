import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testsocketchatapp/data/models/message.dart';
import 'package:testsocketchatapp/presentation/services/bloc/messageBloc/message_bloc.dart';
import 'package:testsocketchatapp/presentation/views/messageChat/components/message_item.dart';
import 'package:testsocketchatapp/presentation/views/messageChat/components/welcome_chat_message.dart';

class ListViewMessage extends StatefulWidget {
  const ListViewMessage({super.key, required this.messages});
  final List<Message> messages;

  @override
  State<ListViewMessage> createState() => _ListViewMessageState();
}

class _ListViewMessageState extends State<ListViewMessage> {
  late final FocusNode focusNode;
  @override
  void initState() {
    focusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final messageBloc = context.read<MessageBloc>();
    final messages = widget.messages.reversed;
    return Expanded(
      child: messages.isEmpty
          ? const WelcomeChatMessage()
          : ListView.builder(
              itemCount: messages.length,
              controller: messageBloc.messageManager.scrollController,
              reverse: true,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final message = messages.elementAt(index);
                Message? nextMessage;
                Message? previousMessage;
                if (index + 1 <= widget.messages.length - 1) {
                  nextMessage = messages.elementAt(index + 1);
                } else {
                  nextMessage = null;
                }
                if (index <= 0) {
                  previousMessage = null;
                } else {
                  previousMessage = messages.elementAt(index - 1);
                }
                return Padding(
                  padding: EdgeInsets.only(
                      top: index == messages.length - 1 ? 16.0.h : 0),
                  child: MessageItem(
                    totalCountIndex: messages.length - 1,
                    message: message,
                    index: index,
                    nextMessage: nextMessage,
                    previousMessage: previousMessage,
                  ),
                );
              },
            ),
    );
  }
}
