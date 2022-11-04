import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/widgets/outline_button_widget.dart';
import 'package:flutter_basic_utilities/widgets/text_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testsocketchatapp/data/models/user_info.dart';
import 'package:testsocketchatapp/presentation/services/bloc/settingBloc/setting_bloc.dart';
import 'package:testsocketchatapp/presentation/services/bloc/settingBloc/setting_event.dart';
import 'package:testsocketchatapp/presentation/views/setting/components/components/image_and_name.dart';

import '../../../../services/bloc/authBloc/auth_bloc.dart';
import '../../../../services/bloc/authBloc/auth_event.dart';

class BodySettingScreen extends StatelessWidget {
  const BodySettingScreen({
    Key? key,
    required this.userInformation,
  }) : super(key: key);

  final UserInformation userInformation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: textWidget(
          text: "Tôi",
          size: 17.h,
        ),
      ),
      body: Column(
        children: [
          ImageAndName(
            userInformation: userInformation,
          ),
          SizedBox(height: 16.h),
          SettingItemMenuButton(
            text: 'Đăng xuất',
            press: () {
              context.read<AuthBloc>().add(
                    AuthEventLogOut(
                      userInformation: userInformation,
                    ),
                  );
              Navigator.popUntil(context, ModalRoute.withName("/"));
            },
          ),
          SizedBox(height: 16.h),
          SettingItemMenuButton(
            text: 'Update Infomation',
            press: () {
              context.read<SettingBloc>().add(
                    GoToUpdateInfoSettingEvent(
                      userInformation: userInformation,
                    ),
                  );
            },
          ),
        ],
      ),
    );
  }
}

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
