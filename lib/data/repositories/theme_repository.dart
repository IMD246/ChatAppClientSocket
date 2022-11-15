import 'dart:developer';

import 'package:testsocketchatapp/data/interfaces/i_service_api.dart';
import 'package:testsocketchatapp/data/models/base_response.dart';
import 'package:testsocketchatapp/data/models/environment.dart';
import 'package:testsocketchatapp/data/network/base_api_services.dart';
import 'package:testsocketchatapp/data/network/network_api_services.dart';

class ThemeModeRepository implements IServiceAPI {
  String themeModeURL = "user/changeThemeMode";
  BaseApiServices apiServices = NetworkApiService();
  ThemeModeRepository({required Environment env}) {
    themeModeURL = env.apiURL + themeModeURL;
  }
  @override
  Future<BaseResponse?> getData(
      {required body,
      required String urlAPI,
      required,
      required headers}) async {
    try {
      final response = await apiServices.getPostApiResponse(
        urlAPI,
        body,
        headers,
      );
      return BaseResponse.fromJson(response);
    } on Exception catch (e) {
      log(e.toString());
      return null;
    }
  }

  @override
  List convertDynamicToList({required BaseResponse value}) {
    throw UnimplementedError();
  }

  @override
  convertDynamicToObject(value) {
    throw UnimplementedError();
  }
}
