import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testsocketchatapp/data/models/chat_user_and_presence.dart';
import 'item_chat.dart';

class ListChat extends StatelessWidget {
  const ListChat({super.key, required this.chats});
  final List<ChatUserAndPresence> chats;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: chats.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        chats.sort(
          (b, a) => a.chat!.timeLastMessage!.compareTo(
            b.chat!.timeLastMessage!,
          ),
        );
        final chat = chats.elementAt(index);
        return Padding(
          padding: EdgeInsets.only(top: index == 0 ? 8.0.h : 0),
          child: ItemChatScreen(chat: chat),
        );
      },
    );
  }
}
