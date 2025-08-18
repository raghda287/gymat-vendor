import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/navigator/navigator.dart';
import 'package:gymatvendor/data/models/department_model.dart';
import 'package:gymatvendor/data/models/specialist_model.dart';
import 'package:gymatvendor/data/repositories/health_club_spa_repository.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import '../../../core/app_theme/theme.dart';
import '../../../data/models/api_response.dart';
import '../../../injection.dart';
import '../../../main.dart';
import '../../widgets/dialogs/progress_dialog.dart';
import '../../widgets/dialogs/scaffold_messanger.dart';

class SpecialistProvider with ChangeNotifier {
  String? specialistPhotoPath;
  List<Specialist> specialists = [];
  List<DepartmentModel> departments = [];
  List<DepartmentModel> selectedDepartments = [];

  bool isLoading = false;
  bool isLoadingDepartments = false;
  HealthClubServiceRepository repository = getIt();

  void addSpecialistInit() {
    specialistPhotoPath = null;
    selectedDepartments = [];
    getDepartments();
  }

  void specialistInit() {
    specialists = [];

    getSpecialists();
  }

  void pickImage(ImageSource source) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? xFile = await imagePicker.pickImage(
        source: source, maxWidth: 512, maxHeight: 512, imageQuality: 50);
    if (xFile != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: xFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),

        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarWidgetColor:
                AppTheme.isDarkMode() ? Colors.white : Colors.black,
            toolbarColor: AppTheme.isDarkMode() ? Colors.black : Colors.white,
            lockAspectRatio: true,
            initAspectRatio: CropAspectRatioPreset.square,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
            ],
            cropStyle: CropStyle.circle,
          ),
          IOSUiSettings(

              title: 'Cropper',
              minimumAspectRatio: 1,
              aspectRatioLockEnabled: true,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
            ],
            cropStyle: CropStyle.circle,
          ),
        ],
      );

      if (croppedFile != null) {
        specialistPhotoPath = 'fileimage:${croppedFile.path}';

        notifyListeners();
      }
    }
  }

  void updateSelectedDepartments(List<DepartmentModel> selectedDepts){
    selectedDepartments.clear();
    selectedDepartments.addAll(selectedDepts);
    notifyListeners();
  }
  void addEmployeeDepartment(DepartmentModel model){
    bool isDepartmentAdded = isDeptInSelectedDepartmentList(model.id);
    if(isDepartmentAdded){
      CustomScaffoldMessanger.showToast(title: 'This department already added'.tr());
    }else{
      selectedDepartments.add(model);
      notifyListeners();
    }
  }

  void deleteEmployeeSelectedDepartment(int index){
    selectedDepartments.removeAt(index);
    notifyListeners();
  }
  bool isDeptInSelectedDepartmentList(num? id){
    for(DepartmentModel model in selectedDepartments){
      if(model.id==id&&id!=null){
        return true;
      }
    }

    return false;
  }

  void getSpecialists() async {
    specialists.clear();
    isLoading = true;
    notifyListeners();




    try {
      ApiResponse response = await repository.getSpecialists();
      isLoading = false;
      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          response.response!.data['data']
              .forEach((v) => specialists.add(Specialist.fromJson(v)));
          notifyListeners();
        } else {
          notifyListeners();
          //CustomScaffoldMessanger.showScaffoledMessanger(title: response.innerMessage??'Something went wrong'.tr());
        }
      }else{
        if(response.error!=null){
          CustomScaffoldMessanger.showScaffoledMessanger(title: response.error);
        }

      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      if (e is DioException) {
        if (e.response!.statusCode != 500) {
          CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
        }
      }
      print('gym specialist error>>>${e.toString()}');
    }
  }

  void getDepartments() async {
    departments.clear();
    isLoadingDepartments = true;
    notifyListeners();
    try {
      ApiResponse response = await repository.getSpaCategories(null);
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
      }else{
        if(response.error!=null){
          CustomScaffoldMessanger.showScaffoledMessanger(title: response.error);
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
      print('spa category error>>>${e.toString()}');
    }
  }

  void deleteSpecialist(Specialist model) async {
    if(specialists.length<=1){
      CustomScaffoldMessanger.showScaffoledMessanger(title: 'Cannot delete.Should be at least 1 specialist until client can book this service'.tr());
      return;
    }
    ProgressDialog dialog = createProgressDialog(
        context: navigatorKey.currentContext!, msg: 'Deleting...'.tr());
    await dialog.show();
    try {
      ApiResponse response =
      await repository.deleteSpecialists(model.id);
      await dialog.hide();
      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          specialists.remove(model);
          notifyListeners();
        } else {
          notifyListeners();
          //CustomScaffoldMessanger.showScaffoledMessanger(title: response.innerMessage??'Something went wrong'.tr());
        }
      }else{
        if(response.error!=null){
          CustomScaffoldMessanger.showScaffoledMessanger(title: response.error);
        }

      }
    } catch (e) {
      await dialog.hide();
      if (e is DioException) {
        if (e.response!.statusCode != 500) {
          CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
        }
      }
      notifyListeners();
      print('spa delete specialist error>>>${e.toString()}');
    }
  }


  void addSpecialist(String name,) async{
    ProgressDialog dialog = createProgressDialog(context: navigatorKey.currentContext!, msg: 'Adding...'.tr());
    await dialog.show();
    try {
      ApiResponse response = await repository.addSpecialists(specialistPhotoPath!,name,selectedDepartments);
      await dialog.hide();
      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          if(response.response!.data!=null){
            Specialist specialist = Specialist.fromJson(response.response!.data['data']);
            specialistPhotoPath = null;
            NavigatorHandler.pop();
            specialists.add(specialist);
            notifyListeners();
          }

        }
      }else{
        if(response.error!=null){
          CustomScaffoldMessanger.showScaffoledMessanger(title: response.error);
        }

      }
    } catch (e) {
      await dialog.hide();
      if (e is DioException) {
        if (e.response!.statusCode != 500) {
          CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
        }
      }print('spa update specialist error>>>${e.toString()}');
    }
  }


  void updateSpecialist(num spcialistId,String name) async {
    ProgressDialog dialog = createProgressDialog(context: navigatorKey.currentContext!, msg: 'Updating...'.tr());
    await dialog.show();
    try {
      ApiResponse response = await repository.updateSpecialists(spcialistId,specialistPhotoPath!,name,selectedDepartments);
      await dialog.hide();
      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          specialistPhotoPath = null;
          NavigatorHandler.pop();
          getSpecialists();
        } else {
          //CustomScaffoldMessanger.showScaffoledMessanger(title: response.innerMessage??'Something went wrong'.tr());
        }
      }else{
        if(response.error!=null){
          CustomScaffoldMessanger.showScaffoledMessanger(title: response.error);
        }

      }
    } catch (e) {
      await dialog.hide();
      if (e is DioException) {
        if (e.response!.statusCode != 500) {
          CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
        }
      }print('spa update specialist error>>>${e.toString()}');
    }
  }



}
