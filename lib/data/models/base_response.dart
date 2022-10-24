import 'package:testsocketchatapp/data/models/errors.dart';

class BaseResponse {
  int? result = -1;
  int? time;
  Errors? error;
  dynamic data = [];

  BaseResponse({
    this.result,
    this.time,
    this.data,
    this.error,
  });

  BaseResponse.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    time = json['time'];
    if (json['data'] != null) {
      data = json['data'];
    }
    error = (json['error'] != null ? Errors.fromJson(json['error']) : null)!;
  }
}
