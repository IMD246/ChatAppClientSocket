import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'base_api_services.dart';

import 'app_exception.dart';

class NetworkApiService extends BaseApiServices {
  @override
  Future getPostApiResponse(String url, dynamic body, dynamic headers) async {
    dynamic responseJson;
    try {
      final response = await http
          .post(
            Uri.parse(url),
            body: jsonEncode(body),
            headers: headers,
          )
          .timeout(
            const Duration(seconds: 10),
          );
      responseJson = returnResponse(response);
    } on SocketException {
      log("No Internet Connection");
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        log(response.body);
        final responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        log("400 ${response.body}");
        final responseJson = jsonDecode(response.body);
        return responseJson;
      case 404:
      case 500:
        log("404 || 500 ${response.body}");
        final responseJson = jsonDecode(response.body);
        return responseJson;
      default:
        log(response.body);
        final responseJson = jsonDecode(response.body);
        return responseJson;
    }
  }
}
