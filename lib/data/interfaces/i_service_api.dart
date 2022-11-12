import '../models/base_response.dart';

abstract class IServiceAPI {
  Future<dynamic> getData({required dynamic body,required String urlAPI,required dynamic headers});
  List<dynamic> convertDynamicToList({required BaseResponse value});
  dynamic convertDynamicToObject(dynamic value);
}
