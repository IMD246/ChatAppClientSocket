import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:testsocketchatapp/data/models/user_info.dart';
import 'package:testsocketchatapp/presentation/extensions/localization.dart';
import 'package:testsocketchatapp/presentation/services/provider/language_provider.dart';
import 'package:testsocketchatapp/presentation/utilities/handle_value.dart';
import 'package:testsocketchatapp/presentation/views/setting/components/components/language_radio.dart';

class ChangeLanguage extends StatefulWidget {
  const ChangeLanguage({Key? key, required this.userInformation})
      : super(key: key);
  final UserInformation userInformation;
  @override
  State<ChangeLanguage> createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          context.loc.language,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10.w,
          vertical: 20.h,
        ),
        child: Column(
          children: [
            Row(
              children: [
                LanguageRadio(
                  value: "vi_VN",
                  groupValue:
                      UtilHandleValue.getFullLocale(languageProvider.locale),
                  onChanged: (val) async {
                    final getLocale = val!.split("_");
                    await languageProvider.changeLocale(
                      languageCode: getLocale[0],
                      countryCode: getLocale[1],
                      userID: widget.userInformation.user!.sId!,
                    );
                  },
                ),
                Text(context.loc.vietnamese),
              ],
            ),
            Row(
              children: [
                LanguageRadio(
                  value: "en_US",
                  groupValue:
                      UtilHandleValue.getFullLocale(languageProvider.locale),
                  onChanged: (val) async {
                    final getLocale = val!.split("_");
                    await languageProvider.changeLocale(
                      languageCode: getLocale[0],
                      countryCode: getLocale[1],
                      userID: widget.userInformation.user!.sId!,
                    );
                  },
                ),
                Text(context.loc.english),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
