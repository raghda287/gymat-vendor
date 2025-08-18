import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:gymatvendor/core/utils/preferences.dart';
import '../../core/app_url/app_url.dart';
import '../datasource/remote/dio/dio_client.dart';
import '../datasource/remote/exception/api_error_handler.dart';
import '../models/api_response.dart';
import '../models/user_model.dart';

class CoachHomeRepository {

  Future<ApiResponse> getStatistics() async {
    try {
      UserModel? userModel = Preferences().getUserData();
      String? markertId;
      if (userModel != null &&
          userModel.providerModel != null &&
          userModel.providerModel!.mainAccount != null) {
        markertId = userModel.providerModel!.mainAccount!.id!.toString();
      }

      DioClient dioClient = DioClient();
      Response response = await dioClient.get(AppUrls.marketHomeData, queryParameters: {'market_id': markertId});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> scanQrCode(num? orderId) async {
    try {
      DioClient dioClient = DioClient();
      num? mareket_id;
      Preferences preferences = Preferences();
      var userData = preferences.getUserData();
      if(userData!=null){
        mareket_id = userData.providerModel?.mainAccount?.id;
      }
      Response response = await dioClient.get('${AppUrls.scanQrCode}/$orderId',
        queryParameters: {'market_id':mareket_id}
      );

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }


}
