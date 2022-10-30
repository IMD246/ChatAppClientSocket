import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/flutter_basic_utilities.dart';
import 'package:flutter_basic_utilities/widgets/circle_image_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testsocketchatapp/presentation/services/bloc/messageBloc/message_bloc.dart';
import 'package:testsocketchatapp/presentation/services/bloc/messageBloc/message_state.dart';
import 'package:testsocketchatapp/presentation/views/messageChat/body_message_chat.dart';

import '../widgets/online_icon_widget.dart';

class MessageChatScreen extends StatelessWidget {
  const MessageChatScreen({Key? key, required this.callBackPop})
      : super(key: key);
  final Function callBackPop;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppbar(context),
      body: const BodyMessageChat(),
    );
  }

  AppBar buildAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.greenAccent,
      leading: BackButton(
        color: Colors.black,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              circleImageWidget(
                urlImage: "https://i.stack.imgur.com/l60Hf.png",
                radius: 18.w,
              ),
              onlineIcon(),
            ],
          ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textWidget(
                text: "Nguyễn Thành Duy",
                size: 13.h,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Online ",
                      style: TextStyle(
                        fontSize: 12.h,
                        color: Colors.black54,
                      ),
                    ),
                    TextSpan(
                      text: "3 months ago",
                      style: TextStyle(
                        fontSize: 12.h,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
