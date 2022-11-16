import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class UtilHandlerInternet {
  static Future<bool> checkInternet(
      {required ConnectivityResult result}) async {
    if (result != ConnectivityResult.none) {
      return await InternetConnectionChecker().hasConnection;
    }
    return false;
  }
}
