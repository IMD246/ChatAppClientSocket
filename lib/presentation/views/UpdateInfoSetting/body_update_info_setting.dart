import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/flutter_basic_utilities.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:testsocketchatapp/constants/constant.dart';
import 'package:testsocketchatapp/presentation/extensions/localization.dart';
import 'package:testsocketchatapp/presentation/services/provider/update_name_provider.dart';
import 'package:testsocketchatapp/presentation/utilities/validate.dart';
import 'package:testsocketchatapp/presentation/utilities/validation.dart';

import '../../../data/models/user_info.dart';
import '../../../data/repositories/name_repository.dart';
import '../../services/provider/config_app_provider.dart';

class BodyUpdateInfoSetting extends StatefulWidget {
  const BodyUpdateInfoSetting({Key? key, required this.userInformation})
      : super(key: key);
  final UserInformation userInformation;
  @override
  State<BodyUpdateInfoSetting> createState() => _BodyUpdateInfoSettingState();
}

class _BodyUpdateInfoSettingState extends State<BodyUpdateInfoSetting> {
  late final TextEditingController firstName;
  late final TextEditingController lastName;
  String errorStringFirstName = '';
  String errorStringLastName = '';
  late final ConfigAppProvider configAppProvider;
  bool isValid = false;
  @override
  void initState() {
    super.initState();
    firstName = TextEditingController();
    lastName = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    firstName.dispose();
    lastName.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ConfigAppProvider configAppProvider =
        Provider.of<ConfigAppProvider>(context);
    final NameRepository nameRepository =
        NameRepository(env: configAppProvider.env);
    final updateNameProvider = Provider.of<UpdateNameProvider>(context);
    Size size = MediaQuery.of(context).size;
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isKeyboard) SizedBox(height: size.height * 0.05),
          Container(
            margin: EdgeInsets.all(12.w),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.circular(
                20.w,
              ),
            ),
            child: TextFieldWidget(
              borderRadius: 20.w,
              controller: firstName,
              hintText: context.loc.enter_your_first_name,
              isShowSearchButton: false,
              textInputAction: TextInputAction.next,
              onSubmitted: (value) {},
              onChanged: (value) {
                setState(() {
                  isValid = UtilValidation.checkLengthTextIsValid(value: value);
                });
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
          Container(
            margin: EdgeInsets.all(12.w),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.circular(
                20.w,
              ),
            ),
            child: TextFieldWidget(
              controller: lastName,
              padding: 12.w,
              hintText: context.loc.enter_your_last_name,
              textInputAction: TextInputAction.done,
              isShowSearchButton: false,
              onSubmitted: (value) {},
              onChanged: (value) {
                setState(() {
                  isValid = UtilValidation.checkLengthTextIsValid(value: value);
                });
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
              press: () async {
                await _processUpdateUserName(
                  nameRepository: nameRepository,
                  updateNameProvider: updateNameProvider,
                );
              },
              text: context.loc.update,
            ),
          )
        ],
      ),
    );
  }

  Future<void> _processUpdateUserName(
      {required NameRepository nameRepository,
      required UpdateNameProvider updateNameProvider}) async {
    if (isValid) {
      final name = "${firstName.text} ${lastName.text}".trim();
      final response = await nameRepository.getData(
        body: {
          "userID": widget.userInformation.user!.sId,
          "name": name,
        },
        urlAPI: nameRepository.updateNameURL,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (ValidateUtilities.checkBaseResponse(baseResponse: response)) {
        ShowSnackbarScaffold().showSnackbar(
          content: context.loc.update_user_profile_successfully,
          context: context,
        );
        updateNameProvider.setFullname(value: name);
        firstName.clear();
        lastName.clear();
      } else {
        ShowSnackbarScaffold().showSnackbar(
          content: context.loc.update_user_profile_failed,
          context: context,
        );
      }
    }
  }
}
