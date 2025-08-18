import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:gymatvendor/core/utils/preferences.dart';
import '../../core/app_url/app_url.dart';
import '../datasource/remote/dio/dio_client.dart';
import '../datasource/remote/exception/api_error_handler.dart';
import '../models/api_response.dart';

class CoachOrderRepository {
  Future<ApiResponse> getOrders() async {
    try {
      DioClient dioClient = DioClient();
      num? mareket_id;
      Preferences preferences = Preferences();
      var userData = preferences.getUserData();
      if(userData!=null){
        mareket_id = userData.providerModel?.mainAccount?.id;
      }
      Response response = await dioClient.get(
        AppUrls.coachOrders,
        queryParameters: {'market_id':mareket_id}
      );

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> getCoachOrderDetails(
    num orderId,
  ) async {
    try {
      DioClient dioClient = DioClient();
      Response response = await dioClient.get(
        '${AppUrls.coachOrders}/$orderId',
      );

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> updateOrderStatus(
      num orderId, String status, String? startDate,String? endDate) async {
    try {
      DioClient dioClient = DioClient();
      var parameter = {'status': status, 'start_at': startDate,'end_at':endDate};

      Response response = await dioClient.put('${AppUrls.coachOrders}/$orderId',
          queryParameters: parameter);

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }
}
