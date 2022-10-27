import 'dart:developer';

import 'package:testsocketchatapp/data/interfaces/i_service_api.dart';
import 'package:testsocketchatapp/data/models/friend.dart';
import 'package:testsocketchatapp/data/network/base_api_services.dart';
import 'package:testsocketchatapp/data/network/network_api_services.dart';

class FriendRepository implements IServiceAPI {
  String getFriendKeywordURL = "user/getchatkeyword";
  String createOrURL = "user/getchatkeyword";
  BaseApiServices apiServices = NetworkApiService();
  FriendRepository({required String baseUrl}) {
    getFriendKeywordURL = baseUrl + getFriendKeywordURL;
  }

  @override
  List<Friend> convertDynamicToList({required dynamic value}) {
    if (value == null) {
      return [];
    } else {
      return (value as List)
          .map(
            (e) => convertDynamicToObject(e),
          )
          .toList();
    }
  }

  @override
  Friend convertDynamicToObject(value) {
    return Friend.fromJson(value);
  }

  @override
  Future<List<Friend>> getData(
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
      return convertDynamicToList(value: response);
    } on Exception catch (e) {
      log(e.toString());
      return [];
    }
  }
}
