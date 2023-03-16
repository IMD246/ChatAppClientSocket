import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/widgets/fill_out_line_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingItemMenuButton extends StatelessWidget {
  const SettingItemMenuButton({
    Key? key,
    required this.text,
    required this.press,
  }) : super(key: key);

  final String text;
  final VoidCallback press;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: FillOutlineButton(
        press: press,
        color: Colors.white.withOpacity(0.7),
        minWidth: double.infinity,
        text: text,
      ),
    );
  }
}