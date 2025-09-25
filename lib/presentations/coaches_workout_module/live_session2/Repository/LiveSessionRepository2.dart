import 'package:dio/dio.dart';
import 'package:gymatvendor/core/app_url/app_url.dart';
import 'package:gymatvendor/data/datasource/remote/dio/dio_client.dart';
import 'package:gymatvendor/data/models/api_response.dart';

import '../../../../data/datasource/remote/exception/api_error_handler.dart';

class LiveSessionRepository2{
  Future<ApiResponse> createSession(int courseId,String title,String description,
      bool isFree,String date,String fromTime,String toTime,String type)async{
    try{
      var formData = FormData.fromMap({
        'course_id':courseId,
        'title':title,
        'description':description,
        'is_free':isFree?"1" : "0",
        'date':date,
        'from_time':fromTime,
        'to_time':toTime,
        "type":type
      });
      DioClient dioClient = DioClient();
      Response response=await dioClient.post(AppUrls.createLiveSession,formData: formData);
      return ApiResponse.withSuccess(response);
    }catch(e){
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

}