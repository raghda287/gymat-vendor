import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:gymatvendor/core/utils/preferences.dart';
import '../../core/app_url/app_url.dart';
import '../datasource/remote/dio/dio_client.dart';
import '../datasource/remote/exception/api_error_handler.dart';
import '../models/api_response.dart';
import '../models/user_model.dart';

class FollowersRepository {
  Future<ApiResponse> getFollowers(int page) async {
    try {
      UserModel? userModel = Preferences().getUserData();
      String? markertId;
      if (userModel != null &&
          userModel.providerModel != null &&
          userModel.providerModel!.mainAccount != null) {
        markertId = userModel.providerModel!.mainAccount!.id!.toString();
      }

      DioClient dioClient = DioClient();
      Response response = await dioClient.get(AppUrls.marketFollowers,
          queryParameters: {'market_id': markertId, 'page': page, 'limit': 40});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> deleteFollower(num? userId) async {
    try {
      UserModel? userModel = Preferences().getUserData();
      String? markertId;
      if (userModel != null &&
          userModel.providerModel != null &&
          userModel.providerModel!.mainAccount != null) {
        markertId = userModel.providerModel!.mainAccount!.id!.toString();
      }

      var formData =
          FormData.fromMap({'market_id': markertId, 'user_id': userId});

      DioClient dioClient = DioClient();
      Response response = await dioClient.post(AppUrls.marketFollowerDelete,
          formData: formData);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }
}
