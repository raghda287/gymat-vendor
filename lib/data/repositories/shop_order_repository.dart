import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import '../../core/app_url/app_url.dart';
import '../../core/utils/preferences.dart';
import '../datasource/remote/dio/dio_client.dart';
import '../datasource/remote/exception/api_error_handler.dart';
import '../models/api_response.dart';

class ShopOrderRepository {
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
        AppUrls.shopOrders,
        queryParameters: {
          'market_id':mareket_id
        }
      );

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> getShopOrderDetails(
    num orderId,
  ) async {
    try {
      DioClient dioClient = DioClient();
      Response response = await dioClient.get(
        '${AppUrls.shopOrders}/$orderId',
      );

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> updateOrderStatus(num orderId, String status,String? deliveryDate) async {
    try {
      DioClient dioClient = DioClient();
      var parameter = {'status': status,
        'delivery_date':deliveryDate
      };

      Response response = await dioClient.put('${AppUrls.shopOrders}/$orderId',
          queryParameters: parameter);

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }
}
