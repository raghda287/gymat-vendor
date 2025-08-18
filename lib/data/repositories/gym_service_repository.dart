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

class GymServiceRepository {


  Future<ApiResponse> getGymCategories(int? limit) async {
    try {
      DioClient dioClient = DioClient();
      Response response = await dioClient.get(AppUrls.gymCategories, queryParameters: {'limit': limit});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> addGymCategories(String title) async {
    try {
      UserModel? userModel = Preferences().getUserData();
      String? markertId;
      if (userModel != null &&
          userModel.providerModel != null &&
          userModel.providerModel!.mainAccount != null) {
        markertId = userModel.providerModel!.mainAccount!.id!.toString();
      }
      DioClient dioClient = DioClient();
      FormData data =
          FormData.fromMap({'title': title, 'market_id': markertId});
      Response response =
          await dioClient.post(AppUrls.gymCategories, formData: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> updateGymCategories(
      String departmentId, String title) async {
    try {
      UserModel? userModel = Preferences().getUserData();
      String? markertId;
      if (userModel != null &&
          userModel.providerModel != null &&
          userModel.providerModel!.mainAccount != null) {
        markertId = userModel.providerModel!.mainAccount!.id!.toString();
      }
      DioClient dioClient = DioClient();
      Response response = await dioClient.put(
          '${AppUrls.gymCategories}/$departmentId',
          queryParameters: {'title': title, 'market_id': markertId});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> deleteGymCategories(String departmentId) async {
    try {
      DioClient dioClient = DioClient();
      Response response =
      await dioClient.delete('${AppUrls.gymCategories}/$departmentId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> addGymService(
      num deprtmentId,
      String serviceName,
      String servicePhoto,
      String price,
      String duration,
      String durationUnitType,
      String description,
      String discount,
      bool isDiscountActive,
      String discountType) async {
    try {
      UserModel? userModel = Preferences().getUserData();
      String? markertId;
      if (userModel != null &&
          userModel.providerModel != null &&
          userModel.providerModel!.mainAccount != null) {
        markertId = userModel.providerModel!.mainAccount!.id!.toString();
      }
      if (servicePhoto.startsWith('fileimage:')) {
        servicePhoto = servicePhoto.replaceFirst('fileimage:', '');
      }



      DioClient dioClient = DioClient();
      FormData data = FormData.fromMap({
        'market_id': markertId,
        'category_id': deprtmentId,
        'title': serviceName,
        'text': description,
        'photo': await MultipartFile.fromFile(servicePhoto),
        'service_time': duration,
        'service_time_name': durationUnitType,
        'price': price,
        'has_offer':isDiscountActive?1:0,
        'offer_type':isDiscountActive?discountType:null,
        'offer_value':isDiscountActive?discount:null
      });
      Response response =
          await dioClient.post(AppUrls.gymService, formData: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }



  Future<ApiResponse> updateGymService(
      num serviceId,
      num deprtmentId,
      String serviceName,
      String servicePhoto,
      String price,
      String duration,
      String durationUnitType,
      String description,
      String discount,
      bool isDiscountActive,
      String discountType
      ) async {
    try {
      UserModel? userModel = Preferences().getUserData();
      String? markertId;
      if (userModel != null &&
          userModel.providerModel != null &&
          userModel.providerModel!.mainAccount != null) {
        markertId = userModel.providerModel!.mainAccount!.id!.toString();
      }
      MultipartFile? multipartFile;

      if (servicePhoto.startsWith('fileimage:')) {
        servicePhoto = servicePhoto.replaceFirst('fileimage:', '');
        multipartFile = await MultipartFile.fromFile(servicePhoto);
      }

      DioClient dioClient = DioClient();
      FormData data = FormData.fromMap({
        'market_id': markertId,
        'category_id': deprtmentId,
        'title': serviceName,
        'text': description,
        'photo':multipartFile,
        'service_time': duration,
        'service_time_name': durationUnitType,
        'price': price,
        'has_offer':isDiscountActive?1:0,
        'offer_type':isDiscountActive?discountType:null,
        'offer_value':isDiscountActive?discount:null,
        '_method': 'PUT',
      });
      Response response =
      await dioClient.post('${AppUrls.gymService}/$serviceId', formData: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> deleteGymService(String serviceId) async {
    try {
      DioClient dioClient = DioClient();
      Response response =
      await dioClient.delete('${AppUrls.gymService}/$serviceId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> addGymMembershipService(
      String serviceName,
      String serviceTime,
      String serviceTimeUnit,
      String servicePhoto,
      String description,
      List<SubscribtionModel> subscribtions
      ) async {
    try {

      List list = subscribtions.map((e) => e.toJson()).toList();
      UserModel? userModel = Preferences().getUserData();
      String? markertId;
      if (userModel != null &&
          userModel.providerModel != null &&
          userModel.providerModel!.mainAccount != null) {
        markertId = userModel.providerModel!.mainAccount!.id!.toString();
      }
      if (servicePhoto.startsWith('fileimage:')) {
        servicePhoto = servicePhoto.replaceFirst('fileimage:', '');
      }
      DioClient dioClient = DioClient();
      FormData data = FormData.fromMap({
        'market_id': markertId,
        'title':serviceName,
        'service_time': serviceTime,
        'service_time_name':serviceTimeUnit,
        'text': description,
        'photo': await MultipartFile.fromFile(servicePhoto),
        'options':list
      });
      Response response = await dioClient.post(AppUrls.gymAddMemberShipService, formData: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> updateGymMembershipService(
      num serviceId,
      String serviceName,
      String serviceTime,
      String serviceTimeUnit,
      String servicePhoto,
      String description,
      List<SubscribtionModel> subscribtions
      ) async {
    try {
      List<SubscribtionModel> dataList = [];
      for(SubscribtionModel model in subscribtions){
        if(model.id==0){
          dataList.add(model);

        }
      }

      List list = dataList.map((e) => e.toJson()).toList();

      UserModel? userModel = Preferences().getUserData();
      String? markertId;
      if (userModel != null &&
          userModel.providerModel != null &&
          userModel.providerModel!.mainAccount != null) {
        markertId = userModel.providerModel!.mainAccount!.id!.toString();
      }
      MultipartFile? multipartFile;
      if (servicePhoto.startsWith('fileimage:')) {
        servicePhoto = servicePhoto.replaceFirst('fileimage:', '');
        multipartFile = await MultipartFile.fromFile(servicePhoto);
      }
      DioClient dioClient = DioClient();
      FormData data = FormData.fromMap({
        'market_id': markertId,
        'title':serviceName,
        'service_time': serviceTime,
        'service_time_name':serviceTimeUnit,
        'text': description,
        'photo': multipartFile,
        'options':list,
        '_method':'PUT'
      });
      Response response = await dioClient.post('${AppUrls.gymAddMemberShipService}/$serviceId', formData: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> deleteGymMembershipService(String serviceId) async {
    try {
      DioClient dioClient = DioClient();
      Response response =
      await dioClient.delete('${AppUrls.gymAddMemberShipService}/$serviceId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }


  Future<ApiResponse> getGymServicesByDepartment(
      bool isMembership,
      int? page, num? category_id,{CancelToken? cancelToken}) async {
    try {
      UserModel? userModel = Preferences().getUserData();
      String? markertId;
      if (userModel != null &&
          userModel.providerModel != null &&
          userModel.providerModel!.mainAccount != null) {
        markertId = userModel.providerModel!.mainAccount!.id!.toString();
      }
      DioClient dioClient = DioClient();
      Response response = await dioClient.get(isMembership?AppUrls.gymAddMemberShipService:AppUrls.gymService,
          cancelToken: cancelToken,
          queryParameters: {
            'market_id': markertId,
            'category_id': category_id,
            'page': page,
            'limit': 20
          });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }


  Future<ApiResponse> deleteGymMembershipOption(String optionId) async {
    try {
      DioClient dioClient = DioClient();
      Response response =
      await dioClient.get('${AppUrls.gymAddMemberShipService}/$optionId/edit');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

}
