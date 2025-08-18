import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/utils/preferences.dart';
import 'package:gymatvendor/data/repositories/auth_repository.dart';
import 'package:gymatvendor/data/repositories/gym_home_repository.dart';
import 'package:gymatvendor/data/repositories/gym_service_repository.dart';
import 'package:gymatvendor/injection.dart';
import 'package:gymatvendor/main.dart';
import 'package:gymatvendor/presentations/widgets/dialogs/progress_dialog.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import '../../../data/models/api_response.dart';
import '../../../data/models/department_model.dart';
import '../../../data/models/statisticsHomeModel.dart';
import '../../widgets/dialogs/scaffold_messanger.dart';

class GymHomeProvider with ChangeNotifier {
  List<DepartmentModel> departments = [];
  bool isLoadingDepartments = true;
  Preferences preferences = Preferences();
  AuthRepository authRepository = getIt();
  bool isLoadingStatistics = true;
  StatisticsHomeModel? statisticsHomeModel;

  void getDepartments() async {
    GymServiceRepository repository = getIt();
    departments.clear();
    isLoadingDepartments = true;
    notifyListeners();
    try {
      ApiResponse response = await repository.getGymCategories(6);
      isLoadingDepartments = false;
      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          response.response!.data['data']
              .forEach((v) => departments.add(DepartmentModel.fromJson(v)));

          notifyListeners();
        } else {
          notifyListeners();
          //CustomScaffoldMessanger.showScaffoledMessanger(title: response.innerMessage??'Something went wrong'.tr());
        }
      }
    } catch (e) {
      isLoadingDepartments = false;
      notifyListeners();
      if (e is DioException) {
        if (e.response!.statusCode != 500) {
          CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
        }
      }
      print('gym category error>>>${e.toString()}');
    }
  }

  void addNewDepartment(DepartmentModel departmentModel) {
    if (departments.length < 6) {
      departments.add(departmentModel);
      notifyListeners();
    }
  }

  void updateToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        authRepository.updateFirebaseToken(token);
      }
    } catch (e) {
      print('errorToken=>>>>$e');
    }
  }

  void updateDepartmentItem(DepartmentModel departmentModel) {
    for (int index = 0; index < departments.length; index++) {
      if (departments[index].id == departmentModel.id) {
        departments[index] = departmentModel;
        notifyListeners();
        return;
      }
    }
  }

  Future<ApiResponse> scanQrCode(num? orderId) async {
    ProgressDialog dialog =createProgressDialog(context: navigatorKey.currentContext!, msg: 'Scanning ...'.tr());
    await dialog.show();
    GymHomeRepository gymHomeRepository = getIt();
    ApiResponse response = await gymHomeRepository.scanQrCode(orderId);
    await dialog.hide();
    return response;
  }

  void getStatistics() async {
    GymHomeRepository repository = getIt();
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
      print('gym statistics error>>>${e.toString()}');
    }
  }

}
