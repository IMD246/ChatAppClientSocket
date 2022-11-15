import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/widgets/text_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:testsocketchatapp/data/models/user_info.dart';
import 'package:testsocketchatapp/presentation/extensions/localization.dart';
import 'package:testsocketchatapp/presentation/services/bloc/settingBloc/setting_bloc.dart';
import 'package:testsocketchatapp/presentation/services/bloc/settingBloc/setting_event.dart';
import 'package:testsocketchatapp/presentation/views/setting/components/components/image_and_name.dart';
import 'package:testsocketchatapp/presentation/views/setting/components/components/languages_setting.dart';
import 'package:testsocketchatapp/presentation/views/setting/components/components/setting_item_menu_button.dart';
import '../../../../services/bloc/authBloc/auth_bloc.dart';
import '../../../../services/bloc/authBloc/auth_event.dart';
import 'dark_mode_switch.dart';

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
          text: context.loc.me,
          size: 20.h,
        ),
      ),
      body: Column(
        children: [
          ImageAndName(
            userInformation: userInformation,
          ),
          const DarkModeSwitch(),
          SizedBox(height: 8.h),
          const LanguageSetting(),
          SizedBox(height: 16.h),
          SettingItemMenuButton(
            text: context.loc.logout,
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
            text: context.loc.update_information,
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
