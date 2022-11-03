import 'package:flutter/material.dart';
import 'package:testsocketchatapp/data/models/message.dart';
import 'package:testsocketchatapp/presentation/views/messageChat/components/message_item.dart';


class ListViewMessage extends StatefulWidget {
  const ListViewMessage({super.key, required this.messages});
  final List<Message> messages;

  @override
  State<ListViewMessage> createState() => _ListViewMessageState();
}

class _ListViewMessageState extends State<ListViewMessage> {
  late final FocusNode focusNode;
  late final ScrollController scrollController;
  @override
  void initState() {
    focusNode = FocusNode();
    scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.messages.reversed.length,
        controller: scrollController,
        reverse: true,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final message = widget.messages.reversed.elementAt(index);
          return MessageItem(message:message,index:index,messages: widget.messages.reversed);
        },
      ),
    );
  }
}
