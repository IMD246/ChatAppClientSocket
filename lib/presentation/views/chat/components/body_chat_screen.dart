import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/flutter_basic_utilities.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testsocketchatapp/data/models/chat_user_and_presence.dart';
import 'package:testsocketchatapp/data/models/user_info.dart';
import 'package:testsocketchatapp/presentation/views/chat/components/list_chat.dart';
import 'package:testsocketchatapp/presentation/views/widgets/observer.dart';

import '../../../services/bloc/chatBloc/chat_bloc.dart';
import '../../../services/bloc/chatBloc/chat_event.dart';

class BodyChatScreen extends StatefulWidget {
  const BodyChatScreen(
      {super.key, required this.userInformation, required this.$chats});
  final UserInformation userInformation;
  final StreamController<List<ChatUserAndPresence>> $chats;
  @override
  State<BodyChatScreen> createState() => _BodyChatScreenState();
}

class _BodyChatScreenState extends State<BodyChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            context.read<ChatBloc>().add(
                  GoToMenuSettingEvent(
                    userInformation: widget.userInformation,
                  ),
                );
          },
          child: circleImageWidget(
            urlImage: widget.userInformation.user?.urlImage ??
                "https://i.stack.imgur.com/l60Hf.png",
            radius: 14.h,
          ),
        ),
        title: textWidget(
          text: "Đoạn Chat",
          size: 20.h,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 8.h,
            ),
            searchWidget(context),
            Observer(
              stream: widget.$chats.stream,
              onSuccess: (context, data) {
                final listChat = data;
                if (listChat == null || listChat.isEmpty) {
                  return textWidget(text: "Let find some chat");
                } else {
                  return ListChat(chats: listChat);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget searchWidget(
    BuildContext context,
  ) {
    return Center(
      child: InkWell(
        onTap: () {
          BlocProvider.of<ChatBloc>(context).add(
            GoToSearchFriendChatEvent(
              userInformation: widget.userInformation,
            ),
          );
        },
        borderRadius: BorderRadius.circular(20.w),
        child: Container(
          width: 300.w,
          height: 40.h,
          padding: EdgeInsets.symmetric(horizontal: 8.0.w),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.4),
            borderRadius: BorderRadius.circular(20.w),
          ),
          alignment: Alignment.center,
          child: Row(
            children: [
              const Icon(
                Icons.search,
                color: Colors.black54,
              ),
              textWidget(
                text: "Tìm kiếm",
                color: Colors.black54,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
