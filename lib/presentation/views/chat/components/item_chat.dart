import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/flutter_basic_utilities.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testsocketchatapp/data/models/chat_user_and_presence.dart';
import 'package:date_format/date_format.dart';

class ItemChatScreen extends StatelessWidget {
  const ItemChatScreen({super.key, required this.chat});
  final ChatUserAndPresence chat;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        clipBehavior: Clip.none,
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          circleImageWidget(
            urlImage: chat.user!.urlImage!.isEmpty
                ? "https://i.stack.imgur.com/l60Hf.png"
                : chat.user!.urlImage!,
            radius: 20.w,
          ),
          if (chat.presence?.presence ?? false) onlineIcon(),
          if (chat.presence?.presence ?? false) offlineIcon(),
        ],
      ),
      title: textWidget(
        text: chat.user?.name ?? "Unknown",
      ),
      subtitle: Row(
        children: [
          Flexible(
            child: textWidget(
              maxLines: 1,
              text: chat.chat?.lastMessage ?? "",
              textOverflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 16.w),
          textWidget(
              text: DateTime.parse(chat.chat!.timeLastMessage!).toString()),
        ],
      ),
    );
  }

  Widget offlineIcon() {
    return Positioned(
      bottom: 0,
      right: -6.w,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.all(2.h),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 2.w,
            vertical: 0.5.h,
          ),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(
              10.w,
            ),
          ),
          alignment: Alignment.center,
          child: textWidget(
            text: "45 p",
            textAlign: TextAlign.center,
            size: 8.h,
          ),
        ),
      ),
    );
  }

  Widget onlineIcon() {
    return Positioned(
      bottom: 0,
      right: 2,
      child: Container(
        width: 10.w,
        height: 10.h,
        decoration: const BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
