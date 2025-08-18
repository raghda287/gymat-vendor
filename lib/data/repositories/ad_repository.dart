import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gymatvendor/core/utils/preferences.dart';
import 'package:gymatvendor/data/models/api_response.dart';
import 'package:gymatvendor/data/models/certificate_file_model.dart';
import 'package:gymatvendor/data/models/location.dart';
import 'package:gymatvendor/data/models/user_model.dart';
import 'package:gymatvendor/main.dart';

import '../../core/app_url/app_url.dart';
import '../datasource/remote/dio/dio_client.dart';
import '../datasource/remote/exception/api_error_handler.dart';
import '../models/local_work_time.dart';
import '../models/subscribtion_model.dart';

class AdRepository {
  Future<ApiResponse> getAds(int? limit,CancelToken? cancelToken) async {
    try {
      UserModel? userModel = Preferences().getUserData();

      String? markertId;
      if (userModel != null &&
          userModel.providerModel != null &&
          userModel.providerModel!.mainAccount != null) {
        markertId = userModel.providerModel!.mainAccount!.id!.toString();
      }

      DioClient dioClient = DioClient();
      Response response =
          await dioClient.get(AppUrls.ad, queryParameters: {'market_id':markertId,'limit': limit},cancelToken: cancelToken);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }
  Future<ApiResponse> getAdDetails(num adId) async {
    try {
      DioClient dioClient = DioClient();
      Response response =
      await dioClient.get('${AppUrls.ad}/$adId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }


  Future<ApiResponse> addAd(
    String photo,
    String from_date,
    String to_date,
    num latitude,
    num longitude,
    String address,
    String page,
      num? payment_card_id,
      String? cvv
  ) async {
    try {
      UserModel? userModel = Preferences().getUserData();
      String? markertId;
      String? category_id;
      if (userModel != null &&
          userModel.providerModel != null &&
          userModel.providerModel!.mainAccount != null) {
        markertId = userModel.providerModel!.mainAccount!.id!.toString();
        category_id =
            userModel.providerModel!.mainAccount!.category_id.toString();
      }
      if (photo.startsWith('fileimage:')) {
        photo = photo.replaceFirst('fileimage:', '');
      }
      DioClient dioClient = DioClient();
      FormData data = FormData.fromMap({
        'market_id': markertId,
        'category_id': category_id,
        'from_date': from_date,
        'to_date': to_date,
        'photo': await MultipartFile.fromFile(photo),
        'latitude': latitude,
        'longitude': longitude,
        'address':address,
        'page': page,
        'payment_card_id': payment_card_id,
        'cvv':cvv
      });
      Response response = await dioClient.post(AppUrls.ad, formData: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> deleteAd(String adId) async {
    try {
      DioClient dioClient = DioClient();
      Response response = await dioClient.delete('${AppUrls.ad}/$adId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> calculateAdPrice(String startDate,String endDate,String page) async {
    try {

      DioClient dioClient = DioClient();
      Response response =
      await dioClient.post(AppUrls.calculateAdPrice, queryParameters: {
        'from_date':startDate,
        'to_date':endDate,
        'page':page
      },);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }
}
