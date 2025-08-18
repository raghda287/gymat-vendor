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
import '../models/add_addition_model.dart';
import '../models/local_work_time.dart';
import '../models/subscribtion_model.dart';

class ShopServiceRepository {
  Future<ApiResponse> getCategories(int? limit, num? parentId,[CancelToken? cancelToken]) async {
    try {
      DioClient dioClient = DioClient();
      Response response = await dioClient.get(AppUrls.shopCategories,
          queryParameters: {'parent_id': parentId, 'limit': limit},cancelToken: cancelToken);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> getShopCategories() async {
    try {
      DioClient dioClient = DioClient();
      Response response = await dioClient.get(AppUrls.mainShopCategories);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> addCategories(String title, num parent_id) async {
    try {
      UserModel? userModel = Preferences().getUserData();
      String? markertId;
      if (userModel != null &&
          userModel.providerModel != null &&
          userModel.providerModel!.mainAccount != null) {
        markertId = userModel.providerModel!.mainAccount!.id!.toString();
      }
      DioClient dioClient = DioClient();
      FormData data = FormData.fromMap(
          {'title': title, 'market_id': markertId, "parent_id": parent_id});
      Response response =
          await dioClient.post(AppUrls.shopCategories, formData: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> updateCategories(
      String departmentId, String title, num parentId) async {
    try {
      UserModel? userModel = Preferences().getUserData();
      String? markertId;
      if (userModel != null &&
          userModel.providerModel != null &&
          userModel.providerModel!.mainAccount != null) {
        markertId = userModel.providerModel!.mainAccount!.id!.toString();
      }
      DioClient dioClient = DioClient();
      Response response = await dioClient
          .put('${AppUrls.shopCategories}/$departmentId', queryParameters: {
        'title': title,
        'market_id': markertId,
        "parent_id": parentId
      });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> deleteCategories(String departmentId) async {
    try {
      DioClient dioClient = DioClient();
      Response response =
          await dioClient.delete('${AppUrls.shopCategories}/$departmentId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> addShopService(
      num main_category_id,
      num category_id,
      String serviceName,
      List<String> servicePhotos,
      String description,
      List<AddAditionModel> additions) async {
    try {
      UserModel? userModel = Preferences().getUserData();
      String? markertId;
      if (userModel != null &&
          userModel.providerModel != null &&
          userModel.providerModel!.mainAccount != null) {
        markertId = userModel.providerModel!.mainAccount!.id!.toString();
      }
      List<MultipartFile> photosParts = [];
      for (String path in servicePhotos) {
        if (path.startsWith('fileimage:')) {
          path = path.replaceFirst('fileimage:', '');
          photosParts.add(await MultipartFile.fromFile(path));
        }
      }

      var details = additions.map((e) => e.toJson()).toList();

      DioClient dioClient = DioClient();
      FormData data = FormData.fromMap({
        'market_id': markertId,
        'main_category_id': main_category_id,
        'category_id': category_id,
        'title': serviceName,
        'text': description,
        'images[]': photosParts,
        'details': details
      });
      Response response =
          await dioClient.post(AppUrls.shopService, formData: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> updateShopService(
      num serviceId,
      num main_category_id,
      num category_id,
      String serviceName,
      List<String> servicePhotos,
      String description,
      List<AddAditionModel> additions) async {
    try {
      UserModel? userModel = Preferences().getUserData();
      String? markertId;
      if (userModel != null &&
          userModel.providerModel != null &&
          userModel.providerModel!.mainAccount != null) {
        markertId = userModel.providerModel!.mainAccount!.id!.toString();
      }
      List<MultipartFile> photosParts = [];
      for (String path in servicePhotos) {
        if (path.startsWith('fileimage:')) {
          path = path.replaceFirst('fileimage:', '');
          photosParts.add(await MultipartFile.fromFile(path));
        }
      }

      var details = additions.map((e) => e.toJson()).toList();

      DioClient dioClient = DioClient();
      FormData data = FormData.fromMap({
        'market_id': markertId,
        'main_category_id': main_category_id,
        'category_id': category_id,
        'title': serviceName,
        'text': description,
        'images[]': photosParts,
        'details': details,
        '_method': 'PUT'
      });
      Response response = await dioClient
          .post('${AppUrls.shopService}/$serviceId', formData: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> getShopService(
      num categoryId, int limit, page, CancelToken? cancelToken) async {
    try {
      UserModel? userModel = Preferences().getUserData();
      String? markertId;
      if (userModel != null &&
          userModel.providerModel != null &&
          userModel.providerModel!.mainAccount != null) {
        markertId = userModel.providerModel!.mainAccount!.id!.toString();
      }
      DioClient dioClient = DioClient();
      Response response = await dioClient
          .get(AppUrls.shopService, cancelToken: cancelToken, queryParameters: {
        'market_id': markertId,
        'category_id': categoryId,
        'limit': limit,
        'page': page,
      });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> deleteService(String serviceId) async {
    try {
      DioClient dioClient = DioClient();
      Response response =
          await dioClient.delete('${AppUrls.shopService}/$serviceId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> deleteServiceImage(num imageId) async {
    try {
      DioClient dioClient = DioClient();
      Response response =
      await dioClient.get('${AppUrls.shopService}/$imageId/edit');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }
}
