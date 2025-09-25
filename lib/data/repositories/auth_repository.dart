import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gymatvendor/data/models/api_response.dart';
import 'package:gymatvendor/data/models/certificate_file_model.dart';
import 'package:gymatvendor/data/models/location.dart';
import 'package:gymatvendor/main.dart';
import 'package:gymatvendor/presentations/auth_module/registration_info_screen/widgets/shop_category_widget.dart';

import '../../core/app_url/app_url.dart';
import '../../core/utils/preferences.dart';
import '../datasource/remote/dio/dio_client.dart';
import '../datasource/remote/exception/api_error_handler.dart';
import '../models/local_work_time.dart';


class AuthRepository {

  Future<ApiResponse> getMainCategories() async{
    try{
      DioClient dioClient =DioClient();
      Response response =await dioClient.get(AppUrls.mainCategory);
      return ApiResponse.withSuccess(response);
    }catch (e){
      return ApiResponse.withError(ApiErrorHandler.handleError(e));

    }


  }

  Future<ApiResponse> getShopCategories() async{
    try{
      DioClient dioClient =DioClient();
      Response response =await dioClient.get(AppUrls.mainShopCategories);
      return ApiResponse.withSuccess(response);
    }catch (e){
      return ApiResponse.withError(ApiErrorHandler.handleError(e));

    }


  }

  Future<ApiResponse> login(String phoneCode,String phone) async{
    try{
      var formData = FormData.fromMap({
        'phone_code':phoneCode,
        'phone':phone
      });
      DioClient dioClient =DioClient();
      Response response =await dioClient.post(
          AppUrls.login,formData:formData);
      return ApiResponse.withSuccess(response);
    }catch (e){
      return ApiResponse.withError(ApiErrorHandler.handleError(e));

    }


  }

  Future<ApiResponse> confirmCode(String phoneCode,String phone,String code)async{
    try{
      FormData formData = FormData.fromMap({
        'phone_code':phoneCode,
        'phone':phone,
        'code':code
      });
      DioClient dioClient = DioClient();
      Response response = await dioClient.post(AppUrls.confirmCode,formData: formData);
      return ApiResponse.withSuccess(response);
    }catch(e){
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> signUp(String name,String email,String phoneCode,String phone,String gender,List<String> categoryIds,String? social_type,String? social_id) async{
    try{
      var formData = FormData.fromMap({
        'name':name,
        'email':email,
        'phone_code':phoneCode,
        'phone':phone,
        'gender':gender,
        'categories[]':categoryIds,
        'social_type':social_type,
        'social_id':social_id
      });
      DioClient dioClient =DioClient();
      Response response =await dioClient.post(
          AppUrls.signUp,formData:formData);
      return ApiResponse.withSuccess(response);
    }catch (e){
      return ApiResponse.withError(ApiErrorHandler.handleError(e));

    }


  }

  Future<ApiResponse> updateProviderCertificatesFiles(String id,String idPhoto,String passportPhoto,String commercialPhoto,List<CertificateFileModel> certificates) async{
    try{
      List<MultipartFile> certificatesList = [];
      for(CertificateFileModel model in certificates){
        if(!model.filePath.startsWith('http')){
          certificatesList.add(await MultipartFile.fromFile(model.filePath));

        }
      }

      var formData = FormData.fromMap({
        'id_number':id,
        'id_photo': await MultipartFile.fromFile(idPhoto),
        'passport':await MultipartFile.fromFile(passportPhoto),
        'com_register':await MultipartFile.fromFile(commercialPhoto),
        'certificates[]':certificatesList,
      });
      DioClient dioClient =DioClient();
      Response response =await dioClient.post(
          AppUrls.updateSignUpInfo,formData:formData);
      return ApiResponse.withSuccess(response);
    }catch (e){
      return ApiResponse.withError(ApiErrorHandler.handleError(e));

    }



  }

  Future<ApiResponse> updateAccountInfo(String marketId,String logoPath,String photoPath,LocationModel locationModel,String name,String phoneCode,String phone,String description,List<LocalWorkTime> workList,String? email,String? website,String? gymPricePerday,List<String> shopCategories,bool? isDelivery) async{
    try{
      List times = [];
      if(workList.isNotEmpty){
        times = workList.map((e) => e.toJson()).toList();
      }


      String? logo = logoPath.startsWith('fileimage:')?logoPath.replaceFirst('fileimage:', ''):logoPath.startsWith('http')?null:logoPath;
      String? photo = photoPath.startsWith('fileimage:')?photoPath.replaceFirst('fileimage:', ''):photoPath.startsWith('http')?null:photoPath;
      int delivery = 0;
      if(isDelivery!=null&&isDelivery){
        delivery = 1;
      }
      FormData formData = FormData.fromMap({
        'market_id':marketId,
        'logo':logo!=null?await MultipartFile.fromFile(logo):null,
        'background':photo!=null?await MultipartFile.fromFile(photo):null,
        'address':locationModel.address!,
        'latitude':locationModel.latitude,
        'longitude':locationModel.longitude,
        'business_name':name,
        'phone_code':phoneCode,
        'phone':phone,
        'desc':description,
        'email':email,
        'website':website,
        'work_times':times,
        'price_day':gymPricePerday,
        'categories[]':shopCategories,
        'is_delivery':delivery

      });

      DioClient dioClient =DioClient();
      Response response =await dioClient.post(AppUrls.updateAccountInfo,formData:formData);
      return ApiResponse.withSuccess(response);
    }catch (e){
      return ApiResponse.withError(ApiErrorHandler.handleError(e));

    }



  }

  Future<ApiResponse> updateAccountWorkWith(String marketId,String workWith) async{
    try{

      FormData formData = FormData.fromMap({
        'market_id':marketId,
        'for_gender':workWith

      });

      DioClient dioClient =DioClient();
      Response response =await dioClient.post(AppUrls.updateAccountWorkWith,formData:formData);
      return ApiResponse.withSuccess(response);
    }catch (e){
      return ApiResponse.withError(ApiErrorHandler.handleError(e));

    }



  }


  Future<ApiResponse> socialLogin(String social_type, String social_id) async {
    try{
      DioClient dioClient = DioClient();
      var form = FormData.fromMap({
        'social_type': social_type,
        'social_id': social_id
      });
      Response response = await dioClient.post(AppUrls.socialLogin, formData: form);

      return ApiResponse.withSuccess(response);
    }catch (e){
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }


Future<ApiResponse> updateFirebaseToken(String token) async {
  try {
    String lang = navigatorKey.currentContext!.locale.languageCode;
    FormData formData = FormData.fromMap({
      'token': token,
      'lang': lang
    });
    DioClient dioClient = DioClient();
    Response response = await dioClient.post(
        AppUrls.updateFirebaseToken, formData: formData);
    return ApiResponse.withSuccess(response);

  } catch (e) {

    return ApiResponse.withError(ApiErrorHandler.handleError(e));

  }
}

  Future<ApiResponse> logout() async{
    try{
      Preferences preferences = Preferences();
      String? token = preferences.getFirebaseToken();


      DioClient dioClient = DioClient();
      var form = FormData.fromMap({
        'token': token,
      });
      Response response = await dioClient.post(AppUrls.logout, formData: form);

      return ApiResponse.withSuccess(response);
    }catch (e){
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> deleteAccount() async{
    try{
      DioClient dioClient = DioClient();
      Response response = await dioClient.get(AppUrls.deleteAccount,);
      return ApiResponse.withSuccess(response);
    }catch (e){
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> updateCoachBioData(num marketId,String bio,String education,String experience,String certificates,List<CertificateFileModel> certificatesFiles) async{
    try{
      List<MultipartFile> certificatesList = [];
      for(CertificateFileModel model in certificatesFiles){
        if(!model.filePath.startsWith('http')){
          certificatesList.add(await MultipartFile.fromFile(model.filePath));

        }
      }
      FormData formData = FormData.fromMap({
        'market_id':marketId,
        'desc':bio,
        'education':education,
        'certifications':certificates,
        'experience':experience,
        'certificates[]':certificatesList

      });

      DioClient dioClient =DioClient();
      Response response =await dioClient.post(AppUrls.updateCoachAccountBioData,formData:formData);
      return ApiResponse.withSuccess(response);
    }catch (e){
      return ApiResponse.withError(ApiErrorHandler.handleError(e));

    }



  }

  Future<ApiResponse> deleteCertificate(num? id) async{
    try{
      DioClient dioClient = DioClient();
      Response response = await dioClient.post('${AppUrls.deleteCertificate}/$id',);
      return ApiResponse.withSuccess(response);
    }catch (e){
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

}