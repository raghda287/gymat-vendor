import 'dart:io';

import 'package:dio/dio.dart';
import 'package:gymatvendor/core/utils/preferences.dart';
import 'package:gymatvendor/data/models/user_model.dart';

import '../../core/app_url/app_url.dart';
import '../../injection.dart';
import '../../presentations/profile_module/provider/profile_provider.dart';
import '../datasource/remote/dio/dio_client.dart';
import '../datasource/remote/exception/api_error_handler.dart';
import '../models/api_response.dart';


class ChatRepository {
  Future<ApiResponse> createAndGetMessages(num? userId) async{
    try{
      DioClient dioClient = DioClient();
      num? marketId;
      Preferences preferences = Preferences();

      UserModel? userModel = preferences.getUserData();
      if(userModel!=null){
        marketId = userModel.providerModel?.mainAccount?.id;

      }


      var queryParameters = {
        'market_id':marketId,
        'user_id':userId,
        'limit':40
      };
      Response response = await dioClient.get(AppUrls.chatCreateGetRoomDataMessages,queryParameters:queryParameters);

      return ApiResponse.withSuccess(response);
    }catch (e){
      return ApiResponse.withError(ApiErrorHandler.handleError(e));

    }
  }

  Future<ApiResponse> sendMessage(num? roomId,String type,String message,int seconds,num? aspectRatio) async{
    try{
      String? messageContent;
      MultipartFile? file;
      if(type=='text'){
        messageContent = message;
        file = null;
      }else if(type=='image'||type=='record'){
        messageContent = null;
        file = await MultipartFile.fromFile(message);
      }
      DioClient dioClient = DioClient();

      var form = FormData.fromMap({
        'room_id':roomId,
        'type':type,
        'message':messageContent,
        'file':file,
        'seconds':seconds,
        'dimensions':aspectRatio

      });


      Response response = await dioClient.post(AppUrls.chatRooms,formData: form);

      return ApiResponse.withSuccess(response);
    }catch (e){
      return ApiResponse.withError(ApiErrorHandler.handleError(e));

    }
  }

  Future<ApiResponse> getRooms(int page) async{
    num? marketId;
    Preferences preferences = Preferences();

    UserModel? userModel = preferences.getUserData();
    if(userModel!=null){
      marketId = userModel.providerModel?.mainAccount?.id;

    }
    try{
      DioClient dioClient = DioClient();
      var queryParameters = {
        'market_id':marketId,
        'page':page,
        'limit':40
      };
      Response response = await dioClient.get(AppUrls.chatRooms,queryParameters: queryParameters);

      return ApiResponse.withSuccess(response);
    }catch (e){
      return ApiResponse.withError(ApiErrorHandler.handleError(e));

    }
  }

  Future<ApiResponse> loadMoreMessages(int page,num? roomId) async{
    try{
      DioClient dioClient = DioClient();
      var queryParameters = {
        'page':page,
        'limit':40
      };
      Response response = await dioClient.get('${AppUrls.chatPaginationMessages}/$roomId',queryParameters: queryParameters);

      return ApiResponse.withSuccess(response);
    }catch (e){
      return ApiResponse.withError(ApiErrorHandler.handleError(e));

    }
  }


  Future<ApiResponse> getAllRoomsIds() async{
    try{
      num? marketId;
      Preferences preferences = Preferences();

      UserModel? userModel = preferences.getUserData();
      if(userModel!=null){
        marketId = userModel.providerModel?.mainAccount?.id;

      }

      DioClient dioClient = DioClient();

      Response response = await dioClient.get(AppUrls.allRoomsIds,queryParameters: {'market_id':marketId});

      return ApiResponse.withSuccess(response);
    }catch (e){
      return ApiResponse.withError(ApiErrorHandler.handleError(e));

    }
  }

  Future<ApiResponse> createVideoChatUrl(num? userId) async{
    try{
      DioClient dioClient = DioClient();
      num? marketId;
      Preferences preferences = Preferences();

      UserModel? userModel = preferences.getUserData();
      if(userModel!=null){
        marketId = userModel.providerModel?.mainAccount?.id;

      }


      var queryParameters = {
        'market_id':marketId,
        'user_id':userId};
      Response response = await dioClient.post(AppUrls.createVideoChatUrl,queryParameters:queryParameters);

      return ApiResponse.withSuccess(response);
    }catch (e){
      return ApiResponse.withError(ApiErrorHandler.handleError(e));

    }
  }

  Future<ApiResponse> getUserProfile(num? userId,String? date) async{

    try{
      DioClient dioClient = DioClient();
      var queryParameters = {
        'user_id':userId,
        'date':date
      };
      Response response = await dioClient.get(AppUrls.userProfile,queryParameters: queryParameters);

      return ApiResponse.withSuccess(response);
    }catch (e){
      return ApiResponse.withError(ApiErrorHandler.handleError(e));

    }
  }

}