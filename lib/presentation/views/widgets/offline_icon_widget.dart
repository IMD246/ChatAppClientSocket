import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/widgets/text_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget offlineIcon({required String? text}) {
  return Positioned(
    bottom: 0,
    right: -6.w,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.w),
      ),
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
          text: text ?? "45 p",
          textAlign: TextAlign.center,
          size: 8.h,
        ),
      ),
    ),
  );
}
