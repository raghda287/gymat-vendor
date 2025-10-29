import 'package:dio/dio.dart';

class ApiResponse {
  final Response? response;
  final int? code;
  final dynamic error;
  final String? innerMessage;

  ApiResponse(this.response, this.error, this.code, this.innerMessage);

  ApiResponse.withError(dynamic errorValue)
      : response = null,
        error = errorValue,
        innerMessage = null,
        code = 0;

  ApiResponse.withSuccess(Response responseValue)
      : response = responseValue,
        code = responseValue.data['code'],
        innerMessage = responseValue.data['message'],
        error = null;
}
