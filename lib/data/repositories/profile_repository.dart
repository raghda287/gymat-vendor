
import 'package:dio/dio.dart';
import '../../core/app_url/app_url.dart';
import '../../core/utils/preferences.dart';
import '../datasource/remote/dio/dio_client.dart';
import '../datasource/remote/exception/api_error_handler.dart';
import '../models/api_response.dart';
import '../models/user_model.dart';

class ProfileRepository {
  Future<ApiResponse> getProfile() async {
    try {
      DioClient dioClient = DioClient();
      Response response = await dioClient.get(AppUrls.profile);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

}
