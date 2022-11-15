import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/widgets/text_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:testsocketchatapp/presentation/extensions/localization.dart';
import 'package:testsocketchatapp/presentation/services/bloc/settingBloc/setting_bloc.dart';
import 'package:testsocketchatapp/presentation/utilities/handle_value.dart';

import '../../../../UIData/image_sources.dart';
import '../../../../services/provider/theme_provider.dart';

class DarkModeSwitch extends StatelessWidget {
  const DarkModeSwitch({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingBloc = context.read<SettingBloc>();
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = UtilHandleValue.isDarkMode(themeProvider.themeMode);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(
              isDarkMode ? ImageSources.imgDarkMode : ImageSources.imgLightMode,
            ),
            backgroundColor: isDarkMode
                ? Colors.white
                : Colors.yellowAccent.withOpacity(0.2),
            radius: 20.w,
          ),
          SizedBox(width: 10.w),
          textWidget(
            text: context.loc.dark_mode,
          ),
          Switch(
            inactiveTrackColor: Colors.green.withOpacity(0.5),
            value: themeProvider.themeMode == ThemeMode.dark,
            activeColor: Colors.green,
            onChanged: (val) async {
              await themeProvider.toggleTheme(
                isOn: val,
                userID: settingBloc.userInformation.user!.sId!,
              );
            },
          ),
        ],
      ),
    );
  }
}
