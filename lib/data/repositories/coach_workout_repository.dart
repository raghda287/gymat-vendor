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

class CoachWorkoutRepository {
  Future<ApiResponse> getWorkouts(int? page,int? limit,{CancelToken? cancelToken}) async {
    try {
      UserModel? userModel = Preferences().getUserData();
      String? markertId;
      if (userModel != null &&
          userModel.providerModel != null &&
          userModel.providerModel!.mainAccount != null) {
        markertId = userModel.providerModel!.mainAccount!.id!.toString();
      }
      DioClient dioClient = DioClient();
      Response response = await dioClient.get(AppUrls.coachWorkouts,
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

  Future<ApiResponse> addWorkout(
      String workoutName,
      String workoutPhoto,
      String description,
      String duration,
      String calories,
      List<LocalWorkoutVideoModel> videos
      ) async {
    try {

      UserModel? userModel = Preferences().getUserData();
      String? markertId;
      if (userModel != null &&
          userModel.providerModel != null &&
          userModel.providerModel!.mainAccount != null) {
        markertId = userModel.providerModel!.mainAccount!.id!.toString();
      }
      if (workoutPhoto.startsWith('fileimage:')) {
        workoutPhoto = workoutPhoto.replaceFirst('fileimage:', '');
      }


      List<Map<String,dynamic>> videosMapList = [];

      for(LocalWorkoutVideoModel model in videos){
        videosMapList.add(await model.toJson());
      }

      print('mapList=>>>${videosMapList}');



    /*  int index = 0;
      for(LocalWorkoutVideoModel model in videos) {
        MultipartFile? imageFile;
        if(!model.videoThumbnail.videoImagePath.startsWith('http')){
          model.videoThumbnail.videoImagePath = model.videoThumbnail.videoImagePath.replaceAll('fileimage:', '');
          imageFile = await MultipartFile.fromFile(model.videoThumbnail.videoImagePath);
        }
        MultipartFile? videoFile;
        if(!model.videoThumbnail.videoPath.startsWith('http')){
          videoFile = await MultipartFile.fromFile(model.videoThumbnail.videoPath);

        }

        Map<String,dynamic> map ={
          'videos[$index][image]': imageFile,
          'videos[$index][duration]': model.duration,
          'videos[$index][name]': model.videoTitle,
          'videos[$index][video]': videoFile,
          'videos[$index][aspect_ratio]': model.aspectRatio
        };
        videosMapList.add(map);
        index++;
      }*/



      DioClient dioClient = DioClient();
      FormData data = FormData.fromMap({
        'market_id': markertId,
        'title': workoutName,
        'text': description,
        'photo': await MultipartFile.fromFile(workoutPhoto),
        'time': duration,
        'calories': calories,
        'videos':videosMapList
      });
      Response response =
      await dioClient.post(AppUrls.coachWorkouts, formData: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> updateWorkout(
      num? workoutId,
      String workoutName,
      String workoutPhoto,
      String description,
      String duration,
      String calories,
      List<LocalWorkoutVideoModel> videos
      ) async {
    try {

      UserModel? userModel = Preferences().getUserData();
      String? markertId;
      if (userModel != null &&
          userModel.providerModel != null &&
          userModel.providerModel!.mainAccount != null) {
        markertId = userModel.providerModel!.mainAccount!.id!.toString();
      }
      MultipartFile? workoutImagePart;
      if (workoutPhoto.startsWith('fileimage:')) {
        workoutPhoto = workoutPhoto.replaceFirst('fileimage:', '');
        workoutImagePart = await MultipartFile.fromFile(workoutPhoto);
      }
      List<Map<String,dynamic>> videosMapList = [];

      for(LocalWorkoutVideoModel model in videos){
        if(!model.videoThumbnail.videoPath.startsWith('http')){
          videosMapList.add(await model.toJson());

        }
      }


      DioClient dioClient = DioClient();
      FormData data = FormData.fromMap({
        'market_id': markertId,
        'title': workoutName,
        'text': description,
        'photo':workoutImagePart,
        'time': duration,
        'calories': calories,
        'videos':videosMapList,
        '_method':'PUT'
      });
      Response response =
      await dioClient.post('${AppUrls.coachWorkouts}/$workoutId', formData: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> deleteWorkout(String workoutId) async {
    try {
      DioClient dioClient = DioClient();
      Response response =
      await dioClient.delete('${AppUrls.coachWorkouts}/$workoutId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }
  Future<ApiResponse> deleteWorkoutVideo(num workoutVideoId) async {
    try {
      DioClient dioClient = DioClient();
      Response response =
      await dioClient.get('${AppUrls.coachWorkouts}/$workoutVideoId/edit');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> updateWorkoutVideo(num workoutVideoId,String videoTitle,String duration,num aspectRatio,String? videoImage,String? videoPath) async {
    try {
      DioClient dioClient = DioClient();
      MultipartFile? image;
      MultipartFile? video;

      if(videoImage!=null&&!videoImage.startsWith('http')){
        image = await MultipartFile.fromFile(videoImage);
      }

      if(videoPath!=null&&!videoPath.startsWith('http')){
        video = await MultipartFile.fromFile(videoPath);
      }
      FormData data = FormData.fromMap({
        'video_id': workoutVideoId,
        'name': videoTitle,
        'image': image,
        'video':video,
        'duration': duration,
        'aspect_ratio': aspectRatio,

      });

      Response response =
      await dioClient.post(AppUrls.coachWorkoutsUpdateVideo,formData: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

}
