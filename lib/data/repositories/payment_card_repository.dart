
import 'package:dio/dio.dart';
import '../../core/app_url/app_url.dart';
import '../../core/utils/preferences.dart';
import '../datasource/remote/dio/dio_client.dart';
import '../datasource/remote/exception/api_error_handler.dart';
import '../models/api_response.dart';

class PaymentCardRepository {
  Future<ApiResponse> getCards() async {
    try {

      DioClient dioClient = DioClient();
      Response response = await dioClient.get(AppUrls.paymentCards);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }
  Future<ApiResponse> addCard(String card_number,String card_holder,String year,String month,String type) async {
    try {

      DioClient dioClient = DioClient();
      var formData= FormData.fromMap({
        'card_number':card_number,
        'card_holder':card_holder,
        'year':year,
        'month':month,
        'type':type,
      });

      Response response = await dioClient.post(AppUrls.paymentCards,formData: formData);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> deleteCard(num? cardId) async {
    try {

      DioClient dioClient = DioClient();

      Response response = await dioClient.delete('${AppUrls.paymentCards}/$cardId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> updateCard(num? cardId,String card_number,String card_holder,String year,String month,String type) async {
    try {

      DioClient dioClient = DioClient();

      Response response = await dioClient.put('${AppUrls.paymentCards}/$cardId',queryParameters: {
        'card_number':card_number,
        'card_holder':card_holder,
        'year':year,
        'month':month,
        'type':type,
      });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

 /* Future<ApiResponse> payOrder(String paymentType,num orderId,num? payment_card_id,String? cvv) async {
    try {
      var formData= FormData.fromMap({
        'type':paymentType,
        'payment_card_id':payment_card_id,
        'order_id':orderId,
        'cvv':cvv
      });
      DioClient dioClient = DioClient();
      Response response = await dioClient.post(AppUrls.payOrder,formData: formData);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }*/

}
