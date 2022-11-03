import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/widgets/circle_image_widget.dart';
import 'package:flutter_basic_utilities/widgets/text_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testsocketchatapp/data/models/message.dart';
import 'package:testsocketchatapp/presentation/extensions/localization.dart';
import 'package:testsocketchatapp/presentation/services/bloc/messageBloc/message_bloc.dart';
import 'package:testsocketchatapp/presentation/utilities/format_date.dart';
import 'package:testsocketchatapp/presentation/views/messageChat/components/text_message.dart';
import 'package:testsocketchatapp/presentation/views/widgets/online_icon_widget.dart';

import '../../../enum/enum.dart';

class MessageItem extends StatefulWidget {
  const MessageItem(
      {super.key,
      required this.message,
      required this.index,
      required this.messages});
  final Message message;
  final Iterable<Message> messages;
  final int index;
  @override
  State<MessageItem> createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  late bool isNeedShowMessageTime;
  bool showStatusMessage = false;
  bool showMessageTime = false;
  bool isLastestMessageOfThisSeries = false;
  bool checkLastestMessageIsNotMine = false;
  _checkTimeShowTimeMessage() {
    setState(() {
      if (widget.index == 0) {
        isNeedShowMessageTime = true;
      } else if (widget.index > 0) {
        isNeedShowMessageTime =
            checkDifferenceBeforeAndCurrentTimeGreaterThan10Minutes(
          DateTime.parse(widget.message.stampTimeMessage!),
          DateTime.parse(
              widget.messages.elementAt(widget.index - 1).stampTimeMessage!),
        );
      } else {
        isNeedShowMessageTime = false;
      }
    });
  }

  @override
  void initState() {
    _checkTimeShowTimeMessage();
    setState(() {
      if (widget.index < widget.messages.length - 1) {
        if (widget.message.userID !=
            widget.messages.elementAt(widget.index + 1).userID) {
          isLastestMessageOfThisSeries = true;
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final messageBloc = context.read<MessageBloc>();
    final isUserMessage =
        messageBloc.userInformation.user!.sId! == widget.message.userID;
    return Column(
      children: [
        if (widget.index == widget.messages.length - 1)
          SizedBox(
            height: 16.h,
          ),
        Visibility(
          visible: isNeedShowMessageTime || showMessageTime,
          child: textWidget(
            text: differenceInCalendarStampTime(
              DateTime.parse(
                  widget.message.stampTimeMessage ?? DateTime.now().toString()),
            ),
            color: Colors.black54,
            size: 12.h,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 8.h,
          ),
          child: Row(
            mainAxisAlignment:
                isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      if (!isUserMessage) leftAvatar(messageBloc),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showMessageTime = !showMessageTime;
                            showStatusMessage = !showStatusMessage;
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18.0.w),
                          child: dynamicTypeMessageWidget(
                            message: widget.message,
                          ),
                        ),
                      ),
                      statusMessage(),
                    ],
                  ),
                  Visibility(
                    visible: showStatusMessage && showMessageTime,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0.w),
                      child: textWidget(
                        text: context.loc.sent,
                        color: Colors.black54,
                        size: 12.h,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Positioned statusMessage() {
    return Positioned(
      bottom: 0,
      right: -4.w,
      child: Container(
        width: 16.w,
        height: 16.h,
        decoration: const BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.done,
          color: Colors.white,
          size: 8.h,
        ),
      ),
    );
  }

  Positioned leftAvatar(MessageBloc messageBloc) {
    return Positioned(
      bottom: 0,
      left: -8.w,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          circleImageWidget(
            urlImage: messageBloc.chatUserAndPresence.user!.urlImage!.isEmpty
                ? "https://i.stack.imgur.com/l60Hf.png"
                : messageBloc.chatUserAndPresence.user!.urlImage!,
            radius: 12.w,
          ),
          if (messageBloc.chatUserAndPresence.presence!.presence!) onlineIcon(),
        ],
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
