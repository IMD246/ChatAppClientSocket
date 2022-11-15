import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:testsocketchatapp/data/models/user_info.dart';
import 'package:testsocketchatapp/presentation/services/bloc/settingBloc/setting_bloc.dart';
import 'package:testsocketchatapp/presentation/services/bloc/settingBloc/setting_event.dart';
import 'package:testsocketchatapp/presentation/services/bloc/settingBloc/setting_manager.dart';
import 'package:testsocketchatapp/presentation/services/bloc/settingBloc/setting_state.dart';
import 'package:testsocketchatapp/presentation/views/UpdateInfoSetting/update_info_setting_screen.dart';
import 'components/body_setting_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({
    super.key,
    required this.userInformation,
    required this.socket,
  });
  final UserInformation userInformation;
  final Socket socket;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingBloc>(
      create: (context) => SettingBloc(
        userInformation: userInformation,
        settingManager:
            SettingManager(socket: socket, userInfomation: userInformation),
      ),
      child: BlocConsumer<SettingBloc, SettingState>(
        listener: (context, state) {
          if (state is InsideUpdateInfoState) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return UpdateInfoSettingScreen(
                    userInformation: state.userInformation,
                  );
                },
              ),
            ).then((value) {
              context.read<SettingBloc>().add(
                    BackToMenuSettingEvent(
                      userInformation: state.userInformation,
                    ),
                  );
            });
          }
        },
        builder: (context, state) {
          return dynamicThemeScreen(
            state,
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
    } else {
      return Scaffold(
        body: Container(),
      );
    }
  }
}
