import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/flutter_basic_utilities.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testsocketchatapp/data/models/message.dart';
import 'package:testsocketchatapp/presentation/views/messageChat/components/text_message.dart';

import '../../../enum/enum.dart';

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
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 8.h,
                ),
                child: dynamicTypeMessageWidget(message: message),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget dynamicTypeMessageWidget({required Message message}) {
    if (TypeMessage.text.name == message.typeMessage) {
      return TextMessage(message: message);
    } else {
      return textWidget(text: "Dont build this type message widget yet!");
    }
  }
}
