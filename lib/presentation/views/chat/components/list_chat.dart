import 'package:flutter/material.dart';
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
        final chat = chats.elementAt(index);
        return ItemChatScreen(chat:chat);
      },
    );
  }
}
