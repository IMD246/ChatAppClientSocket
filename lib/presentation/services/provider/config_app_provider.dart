// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import 'package:testsocketchatapp/data/models/environment.dart';

import '../notification/notification.dart';

class ConfigAppProvider extends ChangeNotifier {
  final Environment env;
  NotificationService noti;
  ConfigAppProvider({required this.env, required this.noti});
  setNoti({required NotificationService value}) {
    noti = value;
    notifyListeners();
  }
}
