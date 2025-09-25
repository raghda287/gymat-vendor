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

class CoachServiceRepository {
  Future<ApiResponse> getCategories(int? limit) async {
    try {
      DioClient dioClient = DioClient();
      Response response = await dioClient.get(AppUrls.coachCategories, queryParameters: {'limit': limit});
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
          await dioClient.post(AppUrls.coachCategories, formData: data);
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
          '${AppUrls.coachCategories}/$departmentId',
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
      await dioClient.delete('${AppUrls.coachCategories}/$departmentId');
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
        'price': price,
        'has_offer':isDiscountActive?1:0,
        'offer_type':isDiscountActive?discountType:null,
        'offer_value':isDiscountActive?discount:null
      });
      Response response =
          await dioClient.post(AppUrls.coachService, formData: data);
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
        'price': price,
        'has_offer':isDiscountActive?1:0,
        'offer_type':isDiscountActive?discountType:null,
        'offer_value':isDiscountActive?discount:null,
        '_method': 'PUT',
      });
      Response response =
      await dioClient.post('${AppUrls.coachService}/$serviceId', formData: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> deleteService(String serviceId) async {
    try {
      DioClient dioClient = DioClient();
      Response response =
      await dioClient.delete('${AppUrls.coachService}/$serviceId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }




  Future<ApiResponse> getServicesByDepartment(int? page, num? category_id,{CancelToken? cancelToken}) async {
    try {
      UserModel? userModel = Preferences().getUserData();
      String? markertId;
      if (userModel != null &&
          userModel.providerModel != null &&
          userModel.providerModel!.mainAccount != null) {
        markertId = userModel.providerModel!.mainAccount!.id!.toString();
      }
      DioClient dioClient = DioClient();
      Response response = await dioClient.get(AppUrls.coachService,
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

  Future<ApiResponse> getCourses()async{
    try{
      DioClient dioClient = DioClient();
      Response response = await dioClient.get(AppUrls.getCourses);
      return ApiResponse.withSuccess(response);
    }catch(e){
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }
  Future<ApiResponse> addCourse(String courseTitle,String descrition,String price)async{
    DioClient dioClient = DioClient();
    FormData formData = FormData.fromMap({
      "title":courseTitle,
      "description":descrition,
      "price":price
    });
    try{
      Response response = await dioClient.post(AppUrls.addCourse,formData: formData);
      return ApiResponse.withSuccess(response);
    }catch(e){
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> getCourseDetails(int courseId)async{
    DioClient dioClient = DioClient();
    try{
      Response response = await dioClient.get("${AppUrls.getCourseDetails}/$courseId");
      return ApiResponse.withSuccess(response);
    }catch(e){
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> uploadSessionVideo(int courseId,String title,String description,
      bool isFree,String date,String fromTime,String toTime,String type,File file)async{
    try{
      final String fileName = file.path.split(Platform.pathSeparator).last;
      var formData = FormData.fromMap({
        'course_id':courseId,
        'title':title,
        'description':description,
        'is_free':isFree?"1" : "0",
        'date':date,
        'from_time':fromTime,
        'to_time':toTime,
        "type":type,
        "file": await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        )
      });
      DioClient dioClient = DioClient();
      Response response=await dioClient.post(AppUrls.createLiveSession,formData: formData);
      return ApiResponse.withSuccess(response);
    }catch(e){
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> deleteSession(int sesseionId)async{
    try{
      DioClient dioClient = DioClient();
      Response response = await dioClient.delete("${AppUrls.deleteSession}/$sesseionId");
      return ApiResponse.withSuccess(response);
    }catch(e){
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }
}
