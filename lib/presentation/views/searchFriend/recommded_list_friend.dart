import 'package:flutter/material.dart';
import 'package:testsocketchatapp/data/models/friend.dart';
import 'package:testsocketchatapp/presentation/views/searchFriend/friend_item.dart';

class RecommmendedListFriend extends StatelessWidget {
  const RecommmendedListFriend({super.key, required this.listFriend});
  final List<Friend> listFriend;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: listFriend.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final friend = listFriend.elementAt(index);
        return FriendItem(
          friend: friend,
          press: () {},
        );
      },
    );
  }
}
