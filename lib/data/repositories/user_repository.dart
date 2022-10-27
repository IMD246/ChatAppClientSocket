import 'dart:developer';

import 'package:testsocketchatapp/data/interfaces/i_service_api.dart';
import 'package:testsocketchatapp/data/models/base_response.dart';
import 'package:testsocketchatapp/data/models/chat_user_and_presence.dart';
import 'package:testsocketchatapp/data/network/base_api_services.dart';
import 'package:testsocketchatapp/data/network/network_api_services.dart';

class UserRepository implements IServiceAPI {
  String getChatsURL = "user/getchats";
  BaseApiServices apiServices = NetworkApiService();
  UserRepository({required String baseUrl}) {
    getChatsURL = baseUrl + getChatsURL;
  }

  @override
  List<ChatUserAndPresence> convertDynamicToList({required dynamic value}) {
    if (value.data == null) {
      return [];
    } else {
      return (value.data as List)
          .map(
            (e) => convertDynamicToObject(e),
          )
          .toList();
    }
  }

  @override
  ChatUserAndPresence convertDynamicToObject(value) {
    return ChatUserAndPresence.fromJson(value);
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
}
