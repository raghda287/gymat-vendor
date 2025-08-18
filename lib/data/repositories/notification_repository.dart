import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:gymatvendor/core/utils/preferences.dart';
import '../../core/app_url/app_url.dart';
import '../datasource/remote/dio/dio_client.dart';
import '../datasource/remote/exception/api_error_handler.dart';
import '../models/api_response.dart';
import '../models/user_model.dart';

class NotificationsRepository {
  Future<ApiResponse> getNotification(int page) async {
    try {
      UserModel? userModel = Preferences().getUserData();
      String? markertId;
      if (userModel != null &&
          userModel.providerModel != null &&
          userModel.providerModel!.mainAccount != null) {
        markertId = userModel.providerModel!.mainAccount!.id!.toString();
      }

      DioClient dioClient = DioClient();
      Response response = await dioClient.get(AppUrls.notification,
          queryParameters: {'market_id': markertId, 'page': page, 'limit': 40});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

}
