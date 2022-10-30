import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/flutter_basic_utilities.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testsocketchatapp/data/models/user_info.dart';

import '../../services/bloc/settingBloc/setting_bloc.dart';
import '../../services/bloc/settingBloc/setting_event.dart';

class UpdateThemeModeSetting extends StatelessWidget {
  const UpdateThemeModeSetting({Key? key, required this.userInformation})
      : super(key: key);
  final UserInformation userInformation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          textWidget(text: "asd"),
          BackButton(
            onPressed: () {
              context.read<SettingBloc>().add(
                    BackToMenuSettingEvent(
                      userInformation: userInformation,
                    ),
                  );
            },
          )
        ],
      ),
    );
  }
}