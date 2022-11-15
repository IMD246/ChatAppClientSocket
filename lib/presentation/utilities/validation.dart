import 'package:flutter/cupertino.dart';
import 'package:testsocketchatapp/presentation/extensions/localization.dart';

class UtilValidation {
  static String handleEmptyText(String value) {
    if (value.isEmpty) {
      return "Không được để trống";
    }
    return "";
  }

  static String handleLengthText({required String value, int length = 3,required BuildContext context}) {
    if (value.length <= length) {
      return context.loc.error_length_text(length);
    }
    return "";
  }
}
