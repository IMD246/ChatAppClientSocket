import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/flutter_basic_utilities.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testsocketchatapp/constants/constant.dart';
import 'package:testsocketchatapp/presentation/extensions/localization.dart';
import 'package:testsocketchatapp/presentation/utilities/validation.dart';

class BodyUpdateInfoSetting extends StatefulWidget {
  const BodyUpdateInfoSetting({Key? key}) : super(key: key);
  @override
  State<BodyUpdateInfoSetting> createState() => _BodyUpdateInfoSettingState();
}

class _BodyUpdateInfoSettingState extends State<BodyUpdateInfoSetting> {
  late final TextEditingController firstName;
  late final TextEditingController lastName;
  String errorStringFirstName = '';
  String errorStringLastName = '';
  @override
  void initState() {
    firstName = TextEditingController();
    lastName = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isKeyboard) SizedBox(height: size.height * 0.05),
          Padding(
            padding: EdgeInsets.all(12.0.w),
            child: TextFieldWidget(
              controller: firstName,
              padding: 12.w,
              boxDecorationColor: kPrimaryColor.withOpacity(0.8),
              hintText: context.loc.enter_your_first_name,
              isShowSearchButton: false,
              textInputAction: TextInputAction.go,
              onSubmitted: (value) {},
              onChanged: (value) {
                setState(() {});
              },
              onDeleted: () {
                setState(() {
                  firstName.clear();
                });
              },
            ),
          ),
          Visibility(
            visible: UtilValidation.handleLengthText(
              value: firstName.text,
              context: context,
            ).isNotEmpty,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0.w),
              child: textWidget(
                text: UtilValidation.handleLengthText(
                  value: firstName.text,
                  context: context,
                ),
                color: Colors.redAccent,
              ),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Padding(
            padding: EdgeInsets.all(12.0.w),
            child: TextFieldWidget(
              controller: lastName,
              padding: 12.w,
              boxDecorationColor: kPrimaryColor.withOpacity(0.8),
              hintText: context.loc.enter_your_last_name,
              textInputAction: TextInputAction.done,
              isShowSearchButton: false,
              onSubmitted: (value) {},
              onChanged: (value) {
                setState(() {});
              },
              onDeleted: () {
                setState(() {
                  lastName.clear();
                });
              },
            ),
          ),
          Visibility(
            visible: UtilValidation.handleLengthText(
              value: lastName.text,
              context: context,
            ).isNotEmpty,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0.w),
              child: textWidget(
                text: UtilValidation.handleLengthText(
                  value: lastName.text,
                  context: context,
                ),
                color: Colors.redAccent,
              ),
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0.w),
            child: FillOutlineButton(
              color: kPrimaryColor,
              minWidth: double.infinity,
              press: () {},
              text: context.loc.update,
            ),
          )
        ],
      ),
    );
  }
}
