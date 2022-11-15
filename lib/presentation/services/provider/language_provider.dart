import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:testsocketchatapp/data/repositories/language_repository.dart';
import 'package:testsocketchatapp/presentation/utilities/validate.dart';

class LanguageProvider extends ChangeNotifier {
  late Locale locale;
  final LanguageRepository languageRepository;
  LanguageProvider(List<String> localeString, this.languageRepository) {
    locale = Locale(localeString[0], localeString[1]);
  }
  Future<void> changeLocale(
      {required String languageCode,
      required String? countryCode,
      required String userID}) async {
    final response = await languageRepository.getData(
        body: {
          "userID": userID,
          "languageCode": languageCode,
          "countryCode": countryCode
        },
        urlAPI: languageRepository.languageURL,
        headers: {"Content-Type": "application/json"});
    if (ValidateUtilities.checkBaseResponse(baseResponse: response)) {
      locale = Locale(languageCode, countryCode);
    }
    notifyListeners();
  }

  void setLocale(
      {required String? languageCode, required String? countryCode}) {
    if (languageCode == null && countryCode == null) {
      locale = Locale(Platform.localeName);
    } else {
      locale = Locale(languageCode ?? "vi", countryCode ?? "VN");
    }
    notifyListeners();
  }
}
