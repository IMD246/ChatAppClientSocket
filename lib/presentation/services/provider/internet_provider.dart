import 'package:flutter/cupertino.dart';

class InternetProvider extends ChangeNotifier {
  bool isConnectedInternet = false;  
  InternetProvider({
    required this.isConnectedInternet,
  });
  void setStatusInternet({required bool value}) {
    isConnectedInternet = value;
    notifyListeners();
  }
}
