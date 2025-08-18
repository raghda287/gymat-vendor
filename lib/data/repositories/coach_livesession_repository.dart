import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gymatvendor/core/utils/preferences.dart';
import 'package:gymatvendor/data/models/api_response.dart';
import 'package:gymatvendor/data/models/certificate_file_model.dart';
import 'package:gymatvendor/data/models/local_workout_video_model.dart';
import 'package:gymatvendor/data/models/location.dart';
import 'package:gymatvendor/data/models/user_model.dart';
import 'package:gymatvendor/data/models/workout_model.dart';
import 'package:gymatvendor/main.dart';

import '../../core/app_url/app_url.dart';
import '../datasource/remote/dio/dio_client.dart';
import '../datasource/remote/exception/api_error_handler.dart';
import '../models/local_work_time.dart';
import '../models/subscribtion_model.dart';

class CoachLiveSessionRepository {
  Future<ApiResponse> getLiveSession(int? page,int? limit,{CancelToken? cancelToken}) async {
    try {
      UserModel? userModel = Preferences().getUserData();
      String? markertId;
      if (userModel != null &&
          userModel.providerModel != null &&
          userModel.providerModel!.mainAccount != null) {
        markertId = userModel.providerModel!.mainAccount!.id!.toString();
      }
      DioClient dioClient = DioClient();
      Response response = await dioClient.get(AppUrls.coachLiveSession,
          cancelToken: cancelToken,
          queryParameters: {
            'market_id': markertId,
            'page': page,
            'limit': limit
          });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }


  Future<ApiResponse> addLiveSession(String topic,String describtion,String price,bool hasOffer,String offer_type,String offer_value,String photo,String date,String from_time,String to_time) async {
    try {
      UserModel? userModel = Preferences().getUserData();
      String? markertId;
      if (userModel != null &&
          userModel.providerModel != null &&
          userModel.providerModel!.mainAccount != null) {
        markertId = userModel.providerModel!.mainAccount!.id!.toString();
      }
      photo = photo.replaceFirst('fileimage:', '');

      MultipartFile photoPart = await MultipartFile.fromFile(photo);
      DioClient dioClient = DioClient();

      final formData = FormData.fromMap({
        'market_id':markertId,
        'title':topic,
        'text':describtion,
        'price':price,
        'has_offer':hasOffer?1:0,
        'offer_type':offer_type,
        'offer_value':offer_value,
        'date':date,
        'from_time':from_time,
        'to_time':to_time,
        'photo':photoPart,

      });

      Response response = await dioClient.post(AppUrls.coachLiveSession,formData: formData);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> updateLiveSession(num? sessionId,String topic,String describtion,String price,bool hasOffer,String offer_type,String offer_value,String photo,String date,String from_time,String to_time) async {
    try {
      UserModel? userModel = Preferences().getUserData();
      String? markertId;
      if (userModel != null &&
          userModel.providerModel != null &&
          userModel.providerModel!.mainAccount != null) {
        markertId = userModel.providerModel!.mainAccount!.id!.toString();
      }
      MultipartFile? photoPart;
      if(!photo.startsWith('http')){
        photoPart = await MultipartFile.fromFile(photo);
      }
      DioClient dioClient = DioClient();

      final formData = FormData.fromMap({
        'market_id':markertId,
        'title':topic,
        'text':describtion,
        'price':price,
        'has_offer':hasOffer?1:0,
        'offer_type':offer_type,
        'offer_value':offer_value,
        'date':date,
        'from_time':from_time,
        'to_time':to_time,
        'photo':photoPart,
        '_method':"PUT"

      });

      Response response = await dioClient.post('${AppUrls.coachLiveSession}/$sessionId',formData: formData);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }


  Future<ApiResponse> deleteLiveSession(num? liveSessionId) async {
    try {
      DioClient dioClient = DioClient();
      Response response =
      await dioClient.delete('${AppUrls.coachLiveSession}/$liveSessionId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> startLiveSession(num sessionId) async {
    try {

      DioClient dioClient = DioClient();
      Response response = await dioClient.get('${AppUrls.coachLiveSession}/$sessionId/edit',);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

}
