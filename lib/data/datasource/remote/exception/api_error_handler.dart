import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

class ApiErrorHandler {
  static String handleError(e) {
    String errorDescription = "";
    if (e is Exception) {
      if (e is DioException) {
        if (e.type == DioExceptionType.unknown) {
          //inter net connection
          errorDescription = 'Check internet connection'.tr();
        } else {
          print("errorApiHandler=>>>>>>>${e.toString()}");
          if (e.response != null) {
            if (e.response!.statusCode == 500) {
              throw e;
            } else if (e.response!.statusCode == 401) {
              errorDescription = 'Unauthorized'.tr();
            } else if (e.response!.statusCode == 404) {
            } else if (e.type == DioExceptionType.connectionTimeout) {
              errorDescription = 'Check internet connection'.tr();
            } else if (e.type == DioExceptionType.receiveTimeout) {
              errorDescription = 'Check internet connection'.tr();
            } else if (e.type == DioExceptionType.sendTimeout) {
              errorDescription = 'Check internet connection'.tr();
            }
          } else {
            errorDescription = 'Check internet connection'.tr();
          }

          //print("error=>>>${e.response!.data['code']}-----${e.response!.data['data']}-----${e.response!.data['message']}");
        }
      }
    } else {
      print("error=>${e.toString()}");
      errorDescription = '';
    }
    return errorDescription;
  }
}
