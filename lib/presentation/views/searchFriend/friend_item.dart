import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/flutter_basic_utilities.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/models/friend.dart';
import '../widgets/online_icon_widget.dart';

class FriendItem extends StatelessWidget {
  const FriendItem({super.key, required this.friend, required this.press});
  final Friend friend;
  final VoidCallback press;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        clipBehavior: Clip.none,
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          circleImageWidget(
            urlImage: (friend.user!.urlImage!.isNotEmpty)
                ? friend.user!.urlImage!
                : "https://i.stack.imgur.com/l60Hf.png",
            radius: 20.w,
          ),
          if (friend.presence?.presence ?? false) onlineIcon(),
        ],
      ),
      title: textWidget(
        text: friend.user?.name ?? "Unknown",
      ),
    );
  }

  
}
