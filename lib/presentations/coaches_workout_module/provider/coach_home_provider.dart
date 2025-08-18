import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/utils/preferences.dart';
import 'package:gymatvendor/data/models/user_model.dart';
import 'package:gymatvendor/data/repositories/auth_repository.dart';
import 'package:gymatvendor/data/repositories/coach_workout_repository.dart';
import 'package:gymatvendor/injection.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import '../../../data/models/api_response.dart';
import '../../../data/models/department_model.dart';
import '../../../data/models/statisticsHomeModel.dart';
import '../../../data/models/workout_model.dart';
import '../../../data/repositories/coach_home_repository.dart';
import '../../../data/repositories/coach_service_repository.dart';
import '../../../main.dart';
import '../../widgets/dialogs/progress_dialog.dart';
import '../../widgets/dialogs/scaffold_messanger.dart';

class CoachHomeProvider with ChangeNotifier{
  AuthRepository authRepository = getIt();
  CoachWorkoutRepository workoutRepository = getIt();
  List<DepartmentModel> departments = [];
  Preferences preferences = Preferences();
  List<WorkoutModel> workouts = [];

  bool isLoadingDepartments = true;
  bool isLoadingWorkouts = false;

  bool isLoadingStatistics = true;
  StatisticsHomeModel? statisticsHomeModel;

  void getDepartments() async{
    CoachServiceRepository repository = getIt();
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
        } else {
          notifyListeners();
          //CustomScaffoldMessanger.showScaffoledMessanger(title: response.innerMessage??'Something went wrong'.tr());
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
      print('coach home category error>>>${e.toString()}');

    }
  }

  void addNewDepartment(DepartmentModel departmentModel) {
    if(departments.length<6){
      departments.add(departmentModel);
      notifyListeners();
    }
  }

  void updateToken() async{
    try{

      String? token = await FirebaseMessaging.instance.getToken();
      if(token!=null){
        authRepository.updateFirebaseToken(token);
      }
    }catch (e){
      print('error=>>>>$e');
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

  void getWorkouts() async {
    workouts.clear();
    isLoadingWorkouts = true;
    notifyListeners();
    try {
      ApiResponse response = await workoutRepository.getWorkouts(null,null);
      isLoadingWorkouts = false;

      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          response.response!.data['data'].forEach((v) => workouts.add(WorkoutModel.fromJson(v)));

          notifyListeners();

        }
      }else{
        if(response.error!=null){
          CustomScaffoldMessanger.showScaffoledMessanger(title: response.error);
        }
      }
    } catch (e) {
      isLoadingWorkouts = false;
      notifyListeners();
      if (e is DioException) {
        if (e.response!.statusCode != 500) {
          CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
        }
      }
      print('coach workout home error>>>${e.toString()}');
    }
  }

  void addWorkout(WorkoutModel workoutModel){
    if(workouts.length<6){
      workouts.add(workoutModel);
      notifyListeners();
    }
  }

  void updateWorkout(WorkoutModel workoutModel){
    int? index = getWorkoutIndex(workoutModel.id!);
    if(index!=null){
      workouts[index] = workoutModel;
      notifyListeners();
    }
  }

  void deleteWorkout(WorkoutModel workoutModel){
    int? index = getWorkoutIndex(workoutModel.id!);
    if(index!=null){
      workouts.removeAt(index);
      notifyListeners();
    }
  }

  int? getWorkoutIndex(num workoutId){
    for(int index = 0; index<workouts.length;index++){
      if(workouts[index].id==workoutId){
        return index;
      }
    }

    return null;
  }
  void getStatistics() async {
    CoachHomeRepository repository = getIt();
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
      print('coach home statistics error>>>${e.toString()}');
    }
  }

  Future<ApiResponse> scanQrCode(num? orderId) async {
    ProgressDialog dialog =createProgressDialog(context: navigatorKey.currentContext!, msg: 'Scanning ...'.tr());
    await dialog.show();
    CoachHomeRepository coachHomeRepository = getIt();
    ApiResponse response = await coachHomeRepository.scanQrCode(orderId);
    await dialog.hide();
    return response;
  }



}