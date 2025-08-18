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
import '../models/department_model.dart';
import '../models/local_work_time.dart';
import '../models/subscribtion_model.dart';

class HealthClubServiceRepository {
  Future<ApiResponse> getSpecialists() async {
    try {
      DioClient dioClient = DioClient();
      Response response = await dioClient.get(AppUrls.spaSpecialists);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> addSpecialists(String photoPath, String name, List<DepartmentModel> list) async {
    try {
      UserModel? userModel = Preferences().getUserData();
      String? markertId;
      if (userModel != null &&
          userModel.providerModel != null &&
          userModel.providerModel!.mainAccount != null) {
        markertId = userModel.providerModel!.mainAccount!.id!.toString();
      }
      MultipartFile? multipartFile;

      if (photoPath.startsWith('fileimage:')) {
        photoPath = photoPath.replaceFirst('fileimage:', '');
        multipartFile = await MultipartFile.fromFile(photoPath);
      }
      List<num?> depts = [];
      for(DepartmentModel model in list){
        depts.add(model.id);
      }

      DioClient dioClient = DioClient();
      Response response = await dioClient
          .post(AppUrls.spaSpecialists, queryParameters: {
        'market_id': markertId,
        'category_id[]': depts,
        'name': name,
        'image': multipartFile});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }


  Future<ApiResponse> updateSpecialists(
      num specialistId, String photoPath, String name, List<DepartmentModel> list) async {
    try {
      UserModel? userModel = Preferences().getUserData();
      String? markertId;
      if (userModel != null &&
          userModel.providerModel != null &&
          userModel.providerModel!.mainAccount != null) {
        markertId = userModel.providerModel!.mainAccount!.id!.toString();
      }
      MultipartFile? multipartFile;

      if (photoPath.startsWith('fileimage:')) {
        photoPath = photoPath.replaceFirst('fileimage:', '');
        multipartFile = await MultipartFile.fromFile(photoPath);
      }
      List<num?> depts = [];
      for(DepartmentModel model in list){
        depts.add(model.id);
      }

      DioClient dioClient = DioClient();
      Response response = await dioClient
          .put('${AppUrls.spaSpecialists}/$specialistId', queryParameters: {
        'market_id': markertId,
        'category_id[]': depts,
        'name': name,
        'photo': multipartFile,
        '_method': 'PUT',
      });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> deleteSpecialists(num? specialistId) async {
    try {
      DioClient dioClient = DioClient();
      Response response =
          await dioClient.delete('${AppUrls.spaSpecialists}/$specialistId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> getSpaCategories(int? limit) async {
    try {
      DioClient dioClient = DioClient();
      Response response = await dioClient
          .get(AppUrls.spaCategories, queryParameters: {'limit': limit});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> addSpaCategories(String title) async {
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
          await dioClient.post(AppUrls.spaCategories, formData: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> updateSpaCategories(
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
          '${AppUrls.spaCategories}/$departmentId',
          queryParameters: {'title': title, 'market_id': markertId});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> deleteSpaCategories(String departmentId) async {
    try {
      DioClient dioClient = DioClient();
      Response response =
          await dioClient.delete('${AppUrls.spaCategories}/$departmentId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> addSpaService(
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
          await dioClient.post(AppUrls.spaService, formData: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> updateSpaService(
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
      String discountType) async {
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
        'service_time': duration,
        'service_time_name': durationUnitType,
        'price': price,
        'has_offer':isDiscountActive?1:0,
        'offer_type':isDiscountActive?discountType:null,
        'offer_value':isDiscountActive?discount:null,
        '_method': 'PUT',
      });
      Response response = await dioClient
          .post('${AppUrls.spaService}/$serviceId', formData: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> deleteSpaService(String serviceId) async {
    try {
      DioClient dioClient = DioClient();
      Response response =
          await dioClient.delete('${AppUrls.spaService}/$serviceId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> getSpaServicesByDepartment(int? page, num? category_id,
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
      Response response = await dioClient.get(AppUrls.spaService,
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
