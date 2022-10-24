// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import 'package:testsocketchatapp/data/models/environment.dart';

class ConfigAppProvider extends ChangeNotifier {
  final Environment env;
  ConfigAppProvider({
    required this.env,
  });
}
