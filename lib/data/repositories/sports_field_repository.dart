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

class SportsFieldServiceRepository {

  Future<ApiResponse> getCategories(int? limit) async {
    try {
      DioClient dioClient = DioClient();
      Response response = await dioClient
          .get(AppUrls.sportsFieldCategories, queryParameters: {'limit': limit});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> addCategories(String title) async {
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
          await dioClient.post(AppUrls.sportsFieldCategories, formData: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> updateCategories(
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
          '${AppUrls.sportsFieldCategories}/$departmentId',
          queryParameters: {'title': title, 'market_id': markertId});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> deleteCategories(String departmentId) async {
    try {
      DioClient dioClient = DioClient();
      Response response =
          await dioClient.delete('${AppUrls.sportsFieldCategories}/$departmentId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> addService(
      num deprtmentId,
      String serviceName,
      String servicePhoto,
      String price,
      String serviceTime,
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
        'service_time': serviceTime,
        'price': price,
        'has_offer':isDiscountActive?1:0,
        'offer_type':isDiscountActive?discountType:null,
        'offer_value':isDiscountActive?discount:null
      });
      Response response =
          await dioClient.post(AppUrls.sportsFieldService, formData: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> updateService(
      num serviceId,
      num deprtmentId,
      String serviceName,
      String servicePhoto,
      String price,
      String serviceTime,
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
        'photo': multipartFile,
        'service_time': serviceTime,
        'price': price,
        'has_offer':isDiscountActive?1:0,
        'offer_type':isDiscountActive?discountType:null,
        'offer_value':isDiscountActive?discount:null,
        '_method': 'PUT',
      });
      Response response = await dioClient
          .post('${AppUrls.sportsFieldService}/$serviceId', formData: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> deleteService(String serviceId) async {
    try {
      DioClient dioClient = DioClient();
      Response response =
          await dioClient.delete('${AppUrls.sportsFieldService}/$serviceId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> getServicesByDepartment(int? page, num? category_id,
      {CancelToken? cancelToken}) async {
    try {
      UserModel? userModel = Preferences().getUserData();
      String? markertId;
      if (userModel != null &&
          userModel.providerModel != null &&
          userModel.providerModel!.mainAccount != null) {
        markertId = userModel.providerModel!.mainAccount!.id!.toString();
      }
      DioClient dioClient = DioClient();
      Response response = await dioClient.get(AppUrls.sportsFieldService,
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



}
