import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/flutter_basic_utilities.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testsocketchatapp/data/models/user_info.dart';
import 'package:testsocketchatapp/presentation/services/bloc/authBloc/auth_bloc.dart';
import 'package:testsocketchatapp/presentation/services/bloc/authBloc/auth_event.dart';
import 'package:testsocketchatapp/presentation/services/bloc/chatBloc/chat_bloc.dart';
import 'package:testsocketchatapp/presentation/services/bloc/chatBloc/chat_event.dart';
import 'package:testsocketchatapp/presentation/views/setting/components/components/image_and_name.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key, required this.userInformation});
  final UserInformation userInformation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            context.read<ChatBloc>().add(
                  BackToHomeChatEvent(
                    userInformation: userInformation,
                  ),
                );
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
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: FillOutlineButton(
              press: () {
                context.read<AuthBloc>().add(
                      AuthEventLogOut(
                        userInformation: userInformation,
                      ),
                    );
              },
              color: Colors.white.withOpacity(0.7),
              minWidth: double.infinity,
              text: "Đăng xuất",
            ),
          )
        ],
      ),
    );
  }
}
