import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/flutter_basic_utilities.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testsocketchatapp/data/models/user_info.dart';
import 'package:testsocketchatapp/presentation/services/bloc/settingBloc/setting_bloc.dart';
import 'package:testsocketchatapp/presentation/services/bloc/settingBloc/setting_state.dart';
import 'package:testsocketchatapp/presentation/views/UpdateInfoSetting/update_info_setting_screen.dart';
import 'package:testsocketchatapp/presentation/views/UpdateThemeModeSetting/update_info_setting_screen.dart';
import '../../widgets/animated_switcher_widget.dart';
import 'components/body_setting_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key, required this.userInformation});
  final UserInformation userInformation;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingBloc>(
      create: (context) => SettingBloc(
        userInformation: userInformation,
      ),
      child: BlocBuilder<SettingBloc, SettingState>(
        builder: (context, state) {
          return AnimatedSwitcherWidget(
            widget: dynamicThemeScreen(
              state,
            ),
          );
        },
      ),
    );
  }

  Widget dynamicThemeScreen(SettingState state) {
    if (state is InsideSettingState) {
      return BodySettingScreen(
        userInformation: state.userInformation,
      );
    } else if (state is InsideUpdateInfoState) {
      return UpdateInfoSettingScreen(userInformation: state.userInformation,);
    } else if (state is InsideUpdateThemeModeState) {
      return UpdateThemeModeSetting(userInformation: state.userInformation,);
    } else {
      return Scaffold(
        body: Column(
          children: [
            textWidget(text: "Lỗi rồi !"),
            BackButton(
              onPressed: () {},
            ),
          ],
        ),
      );
    }
  }
}
