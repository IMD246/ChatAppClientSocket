import 'package:testsocketchatapp/data/models/base_response.dart';

class ValidateUtilities {
  static bool checkBaseResponse({required BaseResponse? baseResponse}) {
    if (baseResponse == null) {
      return false;
    } else {
      if (baseResponse.result != 1) {
        return false;
      } else {
        return true;
      }
    }
  }
}
  