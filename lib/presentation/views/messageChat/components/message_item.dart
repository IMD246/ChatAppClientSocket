import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/flutter_basic_utilities.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testsocketchatapp/presentation/services/bloc/messageBloc/message_bloc.dart';
import 'package:testsocketchatapp/presentation/utilities/format_date.dart';
import 'package:testsocketchatapp/presentation/utilities/handle_value.dart';
import 'package:testsocketchatapp/presentation/views/messageChat/components/text_message.dart';
import 'package:testsocketchatapp/presentation/views/widgets/online_icon_widget.dart';

import '../../../../data/models/chat_message.dart';
import '../../../enum/enum.dart';

class MessageItem extends StatefulWidget {
  const MessageItem({
    super.key,
    required this.message,
    required this.index,
    required this.nextMessage,
    required this.previousMessage,
    required this.totalCountIndex,
  });
  final ChatMessage message;
  final ChatMessage? nextMessage;
  final ChatMessage? previousMessage;
  final int index;
  final int totalCountIndex;
  @override
  State<MessageItem> createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  bool isNeedShowMessageTime = false;
  bool showStatusMessage = false;
  bool showMessageTime = false;
  bool isLastestMessageOfThisSeries = false;
  bool checkLastestMessageIsNotMine = false;
  _checkTimeShowTimeMessage() {
    setState(() {
      if (widget.index == widget.totalCountIndex) {
        isNeedShowMessageTime = true;
      } else {
        if (widget.index >= 0) {
          isNeedShowMessageTime =
              checkDifferenceBeforeAndCurrentTimeGreaterThan10Minutes(
            DateTime.parse(widget.nextMessage!.stampTimeMessage!),
            DateTime.parse(widget.message.stampTimeMessage!),
          );
        } else {
          isNeedShowMessageTime = false;
        }
      }
    });
  }

  @override
  void initState() {
    _checkTimeShowTimeMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final messageBloc = context.read<MessageBloc>();
    final isUserMessage =
        messageBloc.userInformation.user!.sId! == widget.message.userID;
    bool isShowLeftAvartar = false;
    if (!isUserMessage) {
      if (widget.previousMessage == null) {
        isShowLeftAvartar = true;
      } else {
        if (widget.previousMessage!.userID! == widget.message.userID) {
          isShowLeftAvartar = false;
        } else {
          isShowLeftAvartar = true;
        }
      }
    }
    return Column(
      children: [
        Visibility(
          visible: isNeedShowMessageTime || showMessageTime,
          child: textWidget(
            text: differenceInCalendarStampTime(
              DateTime.parse(widget.message.stampTimeMessage!).toLocal(),
            ),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      if (isShowLeftAvartar) leftAvatar(messageBloc),
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
                      Visibility(
                        visible: isUserMessage,
                        child: statusMessage(
                            statusMessage: widget.message.messageStatus!,
                            messageBloc: messageBloc),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: showStatusMessage && showMessageTime,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0.w),
                      child: textWidget(
                        text: UtilHandleValue.setStatusMessageText(
                          widget.message.messageStatus!,
                          context,
                        ),
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

  Widget statusMessage(
      {required String statusMessage, required MessageBloc messageBloc}) {
    if (statusMessage.toLowerCase() == MessageStatus.sent.name.toLowerCase()) {
      return sentIconStatus();
    } else if (statusMessage.toLowerCase() ==
        MessageStatus.viewed.name.toLowerCase()) {
      return rightAvatar(messageBloc);
    } else {
      return Visibility(
        visible: false,
        child: Positioned(
          child: Container(),
        ),
      );
    }
  }

  Positioned sentIconStatus() {
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

  Visibility rightAvatar(MessageBloc messageBloc) {
    return Visibility(
      visible: widget.index == 0,
      child: Positioned(
        bottom: 0,
        right: -8.w,
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
            if (messageBloc.chatUserAndPresence.presence!.presence!)
              onlineIcon(widget: 8.w, height: 8.h),
          ],
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
          if (messageBloc.chatUserAndPresence.presence!.presence!)
            onlineIcon(widget: 8.w, height: 8.h),
        ],
      ),
    );
  }

  Widget dynamicTypeMessageWidget({required ChatMessage message}) {
    if (TypeMessage.text.name == message.typeMessage) {
      return TextMessage(message: message);
    } else {
      return textWidget(text: "Dont build this type message widget yet!");
    }
  }
}
