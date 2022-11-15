import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/flutter_basic_utilities.dart';
import 'package:provider/provider.dart';
import 'package:testsocketchatapp/data/models/user_info.dart';
import 'package:testsocketchatapp/presentation/extensions/localization.dart';
import 'package:testsocketchatapp/presentation/services/provider/update_name_provider.dart';
import 'package:testsocketchatapp/presentation/views/UpdateInfoSetting/body_update_info_setting.dart';

class UpdateInfoSettingScreen extends StatelessWidget {
  const UpdateInfoSettingScreen({Key? key, required this.userInformation})
      : super(key: key);
  final UserInformation userInformation;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UpdateNameProvider>(
      create: (context) =>
          UpdateNameProvider(fullName: userInformation.user?.name ?? ""),
      child: Consumer<UpdateNameProvider>(
        builder: (context, value, child) {
          return Scaffold(
            appBar: AppBar(
              leading: BackButton(
                onPressed: () {
                  Navigator.of(context).pop(value.fullName);
                },
              ),
              title: textWidget(
                text: context.loc.update_information,
              ),
              centerTitle: true,
            ),
            body: BodyUpdateInfoSetting(
              userInformation: userInformation,
            ),
          );
        },
      ),
    );
  }
}
