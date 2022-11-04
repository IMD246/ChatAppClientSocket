import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget onlineIcon({double? widget, double? height}) {
  return Positioned(
    bottom: -1,
    right: 0,
    child: Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      padding: EdgeInsets.all(2.w),
      child: Container(
        width: widget ?? 10.w,
        height: height ?? 10.h,
        decoration: const BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
      ),
    ),
  );
}
