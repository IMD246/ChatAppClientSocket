import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/widgets/circle_image_widget.dart';
import 'package:flutter_basic_utilities/widgets/text_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testsocketchatapp/data/models/user_info.dart';

class ImageAndName extends StatelessWidget {
  const ImageAndName({Key? key, required this.userInformation})
      : super(key: key);
  final UserInformation userInformation;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 16.h,
        ),
        Center(
          child: Stack(
            children: [
              circleImageWidget(
                urlImage: userInformation.user?.urlImage ??
                    "https://i.stack.imgur.com/l60Hf.png",
              ),
              Positioned(
                bottom: 3.h,
                right: 3.w,
                child: Container(
                  padding: EdgeInsets.all(5.w),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white54,
                  ),
                  child: const Icon(Icons.edit),
                ),
              ),
            ],
          ),
        ),
        textWidget(
          text: userInformation.user?.name ?? "Unknown",
          fontWeight: FontWeight.bold,
          size: 18.h,
        ),
      ],
    );
  }
}
