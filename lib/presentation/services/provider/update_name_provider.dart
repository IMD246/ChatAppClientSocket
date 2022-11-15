import 'package:flutter/material.dart';

class UpdateNameProvider extends ChangeNotifier {
  late String fullName;
  UpdateNameProvider({
    required this.fullName,
  });
  void setFullname({required String value}) {
    fullName = value;
    notifyListeners();
  }
}
