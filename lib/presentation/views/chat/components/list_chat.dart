import 'package:flutter/material.dart';
import 'item_chat.dart';

class ListChat extends StatelessWidget {
  const ListChat({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 12,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return const ItemChatScreen(online: false);
      },
    );
  }
}
