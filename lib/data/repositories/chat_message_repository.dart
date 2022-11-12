import 'dart:developer';

import 'package:testsocketchatapp/data/interfaces/i_service_api.dart';
import 'package:testsocketchatapp/data/models/base_response.dart';
import 'package:testsocketchatapp/data/models/chat_message.dart';
import 'package:testsocketchatapp/data/network/base_api_services.dart';
import 'package:testsocketchatapp/data/network/network_api_services.dart';

class ChatMessageRepository implements IServiceAPI {
  String getChatMessagesURL = "message/getMessages";
  BaseApiServices apiServices = NetworkApiService();
  ChatMessageRepository({required String baseUrl}) {
    getChatMessagesURL = baseUrl + getChatMessagesURL;
  }

  @override
  List<ChatMessage> convertDynamicToList({required dynamic value}) {
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
  ChatMessage convertDynamicToObject(value) {
    return ChatMessage.fromJson(value);
  }

  @override
  Future<BaseResponse?> getData(
      {required body,
      required String urlAPI,
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
