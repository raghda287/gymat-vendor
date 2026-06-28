import 'dart:io';

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gymatvendor/core/utils/preferences.dart';
import 'package:gymatvendor/data/models/api_response.dart';

import 'package:gymatvendor/data/models/user_model.dart';


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
  Future<ApiResponse> addCourse(String courseTitle,String descrition,double price,String image,bool isCourseFree)async{
    DioClient dioClient = DioClient();
    late FormData formData;
    if(image.isNotEmpty){
      formData = FormData.fromMap({
        "title":courseTitle,
        "description":descrition,
        "price":price,
        "image":await MultipartFile.fromFile(image),
        "is_free":isCourseFree?"1":"0"

      });
    }else{
      formData = FormData.fromMap({
        "title":courseTitle,
        "description":descrition,
        "price":price,
        "is_free":isCourseFree?"1":"0"
      });
    }
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
      print('getCourseDetails${response.data}');
      return ApiResponse.withSuccess(response);
    }catch(e){
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }


  Future<ApiResponse> uploadSessionVideo(
      int courseId,
      String title,
      String description,
      bool isFree,
      String date,
      String fromTime,
      String toTime,
      String type,
      File file,
      ) async {
    try {
      if (!await file.exists()) {
        return ApiResponse.withError('ملف الفيديو غير موجود');
      }

      final int fileSizeBytes = await file.length();
      final double fileSizeMb = fileSizeBytes / (1024 * 1024);

      print('REPOSITORY VIDEO EXISTS: ${await file.exists()}');
      print('REPOSITORY VIDEO PATH: ${file.path}');
      print('REPOSITORY VIDEO SIZE MB: ${fileSizeMb.toStringAsFixed(2)}');

      final String ext = file.path.split('.').last.toLowerCase();

      MediaType mediaType;

      switch (ext) {
        case 'mp4':
          mediaType = MediaType('video', 'mp4');
          break;
        case 'mov':
          mediaType = MediaType('video', 'quicktime');
          break;
        case 'avi':
          mediaType = MediaType('video', 'x-msvideo');
          break;
        case 'mkv':
          mediaType = MediaType('video', 'x-matroska');
          break;
        case 'webm':
          mediaType = MediaType('video', 'webm');
          break;
        default:
          mediaType = MediaType('video', 'mp4');
      }

      final String uploadFileName =
          'session_${DateTime.now().millisecondsSinceEpoch}.$ext';

      final MultipartFile multipartFile = await MultipartFile.fromFile(
        file.path,
        filename: uploadFileName,
        contentType: mediaType,
      );

      final FormData formData = FormData();

      formData.fields.addAll([
        MapEntry('course_id', courseId.toString()),
        MapEntry('title', title),
        MapEntry('description', description),
        MapEntry('is_free', isFree ? '1' : '0'),
        MapEntry('date', date),
        MapEntry('from_time', fromTime),
        MapEntry('to_time', toTime),
        MapEntry('type', type),
      ]);

      formData.files.add(
        MapEntry('file', multipartFile),
      );

      print('FORM DATA FIELDS: ${formData.fields}');
      print('FORM DATA FILES LENGTH: ${formData.files.length}');
      print('FORM DATA FILES: ${formData.files}');
      print('UPLOAD FILE NAME: $uploadFileName');
      print('UPLOAD FILE CONTENT TYPE: $mediaType');

      DioClient dioClient = DioClient();

      Response response = await dioClient.post(
        AppUrls.createLiveSession,
        formData: formData,
      );

      print('UPLOAD SESSION RESPONSE STATUS: ${response.statusCode}');
      print('UPLOAD SESSION RESPONSE BODY: ${response.data}');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('UPLOAD SESSION ERROR: $e');
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

  Future<ApiResponse> deleteCourse(int courseId)async{
    try{
      DioClient dioClient = DioClient();
          Response response = await dioClient.delete("${AppUrls.deleteCourse}/$courseId");
          return ApiResponse.withSuccess(response);
    }catch(e){
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }
}
