import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/flutter_basic_utilities.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ItemChatScreen extends StatelessWidget {
  const ItemChatScreen({super.key, required this.online});
  final bool online;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        clipBehavior: Clip.none,
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          circleImageWidget(
            urlImage: "https://i.stack.imgur.com/l60Hf.png",
            radius: 20.w,
          ),
          if (online) onlineIcon(),
          if (!online) offlineIcon(),
        ],
      ),
      title: textWidget(
        text: "Unknown",
      ),
      subtitle: Row(
        children: [
          Flexible(
            child: textWidget(
              maxLines: 1,
              text: "Unknown",
              textOverflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 16.w),
          textWidget(
            text: "14:21",
          )
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
