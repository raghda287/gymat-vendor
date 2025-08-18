import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/utils/preferences.dart';
import 'package:gymatvendor/data/models/user_model.dart';
import 'package:gymatvendor/data/repositories/auth_repository.dart';
import 'package:gymatvendor/injection.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import '../../../data/models/api_response.dart';
import '../../../data/models/department_model.dart';
import '../../../data/models/statisticsHomeModel.dart';
import '../../../data/repositories/sports_field_home_repository.dart';
import '../../../data/repositories/sports_field_repository.dart';
import '../../../main.dart';
import '../../widgets/dialogs/progress_dialog.dart';
import '../../widgets/dialogs/scaffold_messanger.dart';

class SportsFieldHomeProvider with ChangeNotifier{
  Preferences preferences = Preferences();
  AuthRepository authRepository = getIt();
  List<DepartmentModel> departments = [];
  bool isLoadingDepartments = true;

  bool isLoadingStatistics = true;
  StatisticsHomeModel? statisticsHomeModel;

  void updateToken() async{
   String? token = await FirebaseMessaging.instance.getToken();
   if(token!=null){
     print('fireToken=>>>>>$token');
     authRepository.updateFirebaseToken(token);
   }
  }


  void addNewDepartment(DepartmentModel departmentModel) {
    if(departments.length<6){
      departments.add(departmentModel);
      notifyListeners();
    }
  }

  void updateDepartmentItem(DepartmentModel departmentModel) {
    for(int index=0;index<departments.length;index++){
      if(departments[index].id==departmentModel.id){
        departments[index] = departmentModel;
        notifyListeners();
        return;
      }
    }
  }

  void getDepartments() async{
    SportsFieldServiceRepository repository = getIt();
    departments.clear();
    isLoadingDepartments = true;
    notifyListeners();
    try {
      ApiResponse response = await repository.getCategories(6);
      isLoadingDepartments = false;
      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          response.response!.data['data'].forEach((v) => departments.add(DepartmentModel.fromJson(v)));
          notifyListeners();
        }
      }else{
        if(response.error!=null){
          CustomScaffoldMessanger.showScaffoledMessanger(title: response.error);
        }
      }
    } catch (e) {

      isLoadingDepartments = false;
      notifyListeners();
      if(e is DioException){
        if(e.response!.statusCode!=500){
          CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());

        }
      }
      print('sports field category error>>>${e.toString()}');

    }
  }


  Future<ApiResponse> scanQrCode(num? orderId) async {
    ProgressDialog dialog =createProgressDialog(context: navigatorKey.currentContext!, msg: 'Scanning ...'.tr());
    await dialog.show();
    SportsFieldHomeRepository repository = getIt();

    ApiResponse response = await repository.scanQrCode(orderId);
    await dialog.hide();
    return response;
  }

  void getStatistics() async {
    SportsFieldHomeRepository repository = getIt();
    statisticsHomeModel = null;
    isLoadingStatistics = true;
    notifyListeners();
    try {
      ApiResponse response = await repository.getStatistics();
      isLoadingStatistics = false;
      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {

          statisticsHomeModel = StatisticsHomeModel.fromJson(response.response!.data['data']);
          notifyListeners();
        } else {
          notifyListeners();
          //CustomScaffoldMessanger.showScaffoledMessanger(title: response.innerMessage??'Something went wrong'.tr());
        }
      }
    } catch (e) {
      isLoadingStatistics = false;
      notifyListeners();
      if (e is DioException) {
        if (e.response!.statusCode != 500) {
          CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
        }
      }
      print('sports field statistics error>>>${e.toString()}');
    }
  }


}