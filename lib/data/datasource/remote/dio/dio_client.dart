import 'dart:io';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gymatvendor/core/app_url/app_url.dart';
import 'package:gymatvendor/data/models/user_model.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/utils/preferences.dart';
import '../../../../injection.dart';
import '../../../../main.dart';
import 'logging_interceptor.dart';

class DioClient {
  final LoggingInterceptor loggingInterceptor = getIt();
  final SharedPreferences sharedPreferences = getIt();
  late Dio dio;

  DioClient() {
    dio = Dio();
    dio
      ..options.baseUrl = AppUrls.baseUrlApi
      ..options.connectTimeout = const Duration(minutes: 5)
      ..options.receiveTimeout = const Duration(minutes: 5)
      ..httpClientAdapter;
    dio.interceptors.add(loggingInterceptor);
  }

  Future<Response> get(
    String uri, {
    Map<String, dynamic>? queryParameters, CancelToken? cancelToken,
        FormData? formData,
  }) async {
    try {
      UserModel? userModel = Preferences().getUserData();
      if(userModel!=null){
        print('AuthToken=>>>${userModel.auth}');
        dio.options.headers ={
          "lang":navigatorKey.currentContext!.locale.languageCode,
          "Authorization":userModel.auth,

        };
      }else{
        dio.options.headers ={
          "lang":navigatorKey.currentContext!.locale.languageCode,
        };
      }
      var response = await dio.get(
        uri,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        data: formData??FormData.fromMap({})
      );
      return response;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {

      throw const FormatException("Unable to process the data");
    } catch (e) {
      throw e;

    }
  }

  Future<Response> getUrl(String url) async {
    try {
      UserModel? userModel = Preferences().getUserData();
      if(userModel!=null){
        dio.options.headers ={
          "lang":navigatorKey.currentContext!.locale.languageCode,
          "Authorization":userModel.auth,

        };
      }else{
        dio.options.headers ={
          "lang":navigatorKey.currentContext!.locale.languageCode,
        };
      }
      var response = await dio.get("");
      return response;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(
    String uri, {
    FormData? formData,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      UserModel? userModel = Preferences().getUserData();
      if(userModel!=null){
        dio.options.headers ={
          "lang":navigatorKey.currentContext!.locale.languageCode,
          "Authorization":userModel.auth,

        };
      }else{
        dio.options.headers ={
          "lang":navigatorKey.currentContext!.locale.languageCode,
        };
      }


      var data = queryParameters ?? {};
      var response = await dio.post(uri, data: formData ?? FormData.fromMap(data));
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> put(
      String uri,
      {
        Map<String, dynamic>? queryParameters,
      }) async {
    try {
      UserModel? userModel = Preferences().getUserData();
      if(userModel!=null){
        dio.options.headers ={
          "lang":navigatorKey.currentContext!.locale.languageCode,
          "Authorization":userModel.auth,

        };
      }else{
        dio.options.headers ={
          "lang":navigatorKey.currentContext!.locale.languageCode,
        };
      }

      var response = await dio.put(uri, queryParameters: queryParameters);
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(
      String uri,
      {
        Map<String, dynamic>? queryParameters,
      }) async {
    try {
      UserModel? userModel = Preferences().getUserData();
      if(userModel!=null){
        dio.options.headers ={
          "lang":navigatorKey.currentContext!.locale.languageCode,
          "Authorization":userModel.auth,

        };
      }else{
        dio.options.headers ={
          "lang":navigatorKey.currentContext!.locale.languageCode,
        };
      }


      var data = queryParameters ?? {};
      var response = await dio.delete(uri, queryParameters:queryParameters);
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }
}
