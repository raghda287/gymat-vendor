import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/navigator/navigator.dart';
import 'package:gymatvendor/data/models/course_details_response.dart';
import 'package:gymatvendor/data/models/course_response.dart';
import 'package:gymatvendor/data/models/service_model.dart';
import 'package:gymatvendor/injection.dart';
import 'package:gymatvendor/main.dart';
import 'package:gymatvendor/presentations/widgets/dialogs/progress_dialog.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../core/app_theme/theme.dart';
import '../../../data/models/api_response.dart';
import '../../../data/models/department_model.dart';
import '../../../data/repositories/coach_service_repository.dart';
import '../../widgets/dialogs/scaffold_messanger.dart';
import 'coach_home_provider.dart';

class CoachServicesProvider with ChangeNotifier {
  ItemScrollController? serviceDepartmentItemController;
  TextEditingController courseTitleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  List<DepartmentModel> departments = [];
  List<ServiceModel?> services = [];
  int selectedCategoryIndex = 0;

  bool isSessionFree = false;

  CourseResponse? courseResponse;
  CourseDetailsResponse? courseDetailsResponse;
  String? servicePhotoPath;
  CoachServiceRepository repository = getIt();
  bool isLoading = true;
  int serviceCurrentPage = 1;
  bool isLoadingDepartment = false;
  bool isLoadingMoreService = false;
  CancelToken? serviceCancelToken;
  File? uploadCourseImage;
  bool isCourseFree = false;
  void init() {
    isLoading = true;
    selectedCategoryIndex = 0;
    serviceCurrentPage = 1;
    isLoadingMoreService = false;
    isLoadingDepartment = false;
    departments = [];
    services = [];
    serviceCancelToken = null;
  }

  void initAddService() {
    servicePhotoPath = null;
    serviceDepartmentItemController = ItemScrollController();
    getDepartments(null);
  }

  void updateUploadeCourseImage(File file){
    uploadCourseImage = file;
    notifyListeners();
  }
  void updateIsCourseFree(bool value){
    isCourseFree = value;
    notifyListeners();
  }


  void updateSelectedCategory(index) {
    selectedCategoryIndex = index;
    notifyListeners();
    getServiceByDepartment(false);
  }


  void updateIsFree(bool value){
    isSessionFree = value;
  }

  void pickImage(ImageSource source,) async
  {
    ImagePicker imagePicker = ImagePicker();
    XFile? xFile = await imagePicker.pickImage(
        source: source, maxWidth: 512, maxHeight: 512, imageQuality: 50);
    if (xFile != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: xFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 3),

        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarWidgetColor:
            AppTheme.isDarkMode() ? Colors.white : Colors.black,
            toolbarColor: AppTheme.isDarkMode() ? Colors.black : Colors.white,
            initAspectRatio: CropAspectRatioPreset.ratio4x3,
            lockAspectRatio: true,
            aspectRatioPresets: [
              CropAspectRatioPreset.ratio4x3
            ],
          ),
          IOSUiSettings(title: 'Cropper', aspectRatioLockEnabled: true,
            aspectRatioPresets: [
              CropAspectRatioPreset.ratio4x3
            ],
          ),
        ],
      );

      if (croppedFile != null) {
        servicePhotoPath = 'fileimage:${croppedFile.path}';

        notifyListeners();
      }
    }
  }

  /// call apis
  void getDepartments(DepartmentModel? homeDepartmentModel) async
  {
    departments.clear();
    isLoading = true;
    isLoadingDepartment = true;
    notifyListeners();
    try {
      ApiResponse response = await repository.getCategories(null);
      isLoadingDepartment = false;
      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          response.response!.data['data']
              .forEach((v) => departments.add(DepartmentModel.fromJson(v)));
          notifyListeners();
          await Future.delayed(const Duration(milliseconds: 50));
          if (homeDepartmentModel != null) {
            for (int index = 0; index < departments.length; index++) {
              if (departments[index].id == homeDepartmentModel.id) {
                selectedCategoryIndex = index;
                serviceDepartmentItemController?.jumpTo(index: index);
                getServiceByDepartment(false);

                break;
              }
            }
          } else {
            getServiceByDepartment(false);
          }
        }
      }else{
        if(response.error!=null){
          CustomScaffoldMessanger.showScaffoledMessanger(title: response.error);
        }
      }
    } catch (e) {
      isLoading = false;
      isLoadingDepartment = false;
      notifyListeners();
      if (e is DioException) {
        if (e.response!.statusCode != 500) {
          CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
        }
      }
      print('coach category error>>>${e.toString()}');
    }
  }

  void addDepartment(String title) async
  {
    ProgressDialog dialog = createProgressDialog(
        context: navigatorKey.currentContext!, msg: 'Adding...'.tr());
    await dialog.show();
    try {
      ApiResponse response = await repository.addCategories(title);
      await dialog.hide();
      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          if (response.response!.data != null &&
              response.response!.data['data'] != null) {
            DepartmentModel departmentModel = DepartmentModel.fromJson(response.response!.data['data']);
            departments.add(departmentModel);
            notifyListeners();
            CoachHomeProvider coachHomeProvider = getIt();
            coachHomeProvider.addNewDepartment(departmentModel);

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
      }
      print('Coach add category error>>>${e.toString()}');
    }
  }

  void updateDepartment(DepartmentModel model, String title, index) async
  {
    ProgressDialog dialog = createProgressDialog(
        context: navigatorKey.currentContext!, msg: 'Updating...'.tr());
    await dialog.show();
    try {
      ApiResponse response =
          await repository.updateCategories(model.id.toString(), title);
      await dialog.hide();

      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          if (response.response!.data != null &&
              response.response!.data['data'] != null) {
            DepartmentModel departmentModel = DepartmentModel.fromJson(response.response!.data['data']);
            departments[index] = departmentModel;
            notifyListeners();
            CoachHomeProvider coachHomeProvider = getIt();
            coachHomeProvider.updateDepartmentItem(departmentModel);

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
      }
      print('coach update category error>>>${e.toString()}');
    }
  }

  void deleteDepartment(DepartmentModel model) async
  {
    ProgressDialog dialog = createProgressDialog(
        context: navigatorKey.currentContext!, msg: 'Deleting...'.tr());
    await dialog.show();
    try {
      ApiResponse response =
          await repository.deleteCategories(model.id.toString());
      await dialog.hide();
      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          departments.remove(model);

          if(departments.isNotEmpty){
            selectedCategoryIndex = departments.length-1;
            getServiceByDepartment(false);
          }else{
            notifyListeners();

          }
          CoachHomeProvider coachHomeProvider = getIt();
          coachHomeProvider.getDepartments();

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
      print('Coach delete category error>>>${e.toString()}');
    }
  }

  /// add update delete service call apis
  void getServiceByDepartment(bool isLoadMore) async
  {
    isLoadingMoreService = isLoadMore;

    if (!isLoadingMoreService) {
      serviceCurrentPage = 1;
      services.clear();
      isLoading = true;
      notifyListeners();
      if (serviceCancelToken != null) {
        serviceCancelToken!.cancel('canceled');
        serviceCancelToken = null;
      }
    } else {
      services.add(null);
    }

    try {
      serviceCancelToken ??= CancelToken();

      ApiResponse response = await repository.getServicesByDepartment(serviceCurrentPage, departments[selectedCategoryIndex].id,
          cancelToken: serviceCancelToken);
      if (!isLoadingMoreService) {
        isLoading = false;
      }
      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          if (isLoadingMoreService) {
            isLoadingMoreService = false;
            if (services.last == null) {
              services.removeLast();
            }

            List<ServiceModel> list = [];
            response.response!.data['data']
                .forEach((v) => list.add(ServiceModel.fromJson(v)));
            if (list.isNotEmpty) {
              serviceCurrentPage = serviceCurrentPage + 1;
            }
            services.addAll(list);
          } else {
            response.response!.data['data']
                .forEach((v) => services.add(ServiceModel.fromJson(v)));
          }

          notifyListeners();
        } else {
          notifyListeners();
          //CustomScaffoldMessanger.showScaffoledMessanger(title: response.innerMessage??'Something went wrong'.tr());
        }
      }else{
        if(response.error!=null){
          CustomScaffoldMessanger.showScaffoledMessanger(title: response.error);
        }

        if (!isLoadingMoreService) {
          isLoading = false;
          notifyListeners();
        } else {
          isLoadingMoreService = false;
          if (services.last == null) {
            services.removeLast();
          }
          notifyListeners();
        }

      }
    } catch (e) {
      if (!isLoadingMoreService) {
        isLoading = false;
        notifyListeners();
      } else {
        isLoadingMoreService = false;
        if (services.last == null) {
          services.removeLast();
        }
        notifyListeners();
      }

      if (e is DioException) {
        if (e.response!.statusCode != 500) {
          CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
        }
      }
      print('coach services error>>>${e.toString()}');
    }
  }

  void addService(num departmentId, String serviceName, String servicePrice, String description,String discount,bool isDiscountActive,String discountType) async
  {
    ProgressDialog dialog = createProgressDialog(
        context: navigatorKey.currentContext!, msg: 'Adding...'.tr());
    await dialog.show();
    try {
      ApiResponse response = await repository.addService(
          departmentId,
          serviceName,
          servicePhotoPath!,
          servicePrice,
          description,
          discount,
          isDiscountActive,
          discountType
      );
      await dialog.hide();
      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          if (response.response!.data != null) {
            servicePhotoPath = null;
            NavigatorHandler.pop();
            getServiceByDepartment(false);
          }
        }
      } else {
        if (response.error != null) {
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
      print('coach Service add error>>>${e.toString()}');
    }
  }

  void updateService(
      num serviceId,
      num departmentId,
      String serviceName,
      String servicePrice,
      String description,String discount,bool isDiscountActive,String discountType) async {
    ProgressDialog dialog = createProgressDialog(
        context: navigatorKey.currentContext!, msg: 'Updating...'.tr());
    await dialog.show();
    try {
      ApiResponse response = await repository.updateService(
          serviceId,
          departmentId,
          serviceName,
          servicePhotoPath!,
          servicePrice,
          description,
          discount,
          isDiscountActive,
          discountType
      );
      await dialog.hide();
      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          if (response.response!.data != null) {
            servicePhotoPath = null;
            NavigatorHandler.pop();
            getServiceByDepartment(false);
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
      }
      print('coach Service update error>>>${e.toString()}');
    }
  }

  void deleteService(ServiceModel model) async {
    ProgressDialog dialog = createProgressDialog(
        context: navigatorKey.currentContext!, msg: 'Deleting...'.tr());
    await dialog.show();
    try {
      ApiResponse response =
      await repository.deleteService(model.id.toString());
      await dialog.hide();
      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          services.remove(model);
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
      print('coach delete service error>>>${e.toString()}');
    }
  }

  void getCourses()async{
    ProgressDialog dialog = createProgressDialog(
        context: navigatorKey.currentContext!, msg: 'Wait...'.tr());
    await dialog.show();
    try{
      ApiResponse apiResponse = await repository.getCourses();
      if(apiResponse.response!.statusCode==200 || apiResponse.response!.statusCode==201){
        courseResponse = CourseResponse.fromJson(apiResponse.response!.data);
        await dialog.hide();
        notifyListeners();
      }
    }catch(e){
      CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
    }
  }

  void clearCourses(){
    courseResponse = null;
  }
  void addCourse() async {
    if (courseTitleController.text.isEmpty ||
        descriptionController.text.isEmpty) {
      CustomScaffoldMessanger.showScaffoledMessanger(
          title: 'Please fill all fields'.tr());
      Navigator.pop(navigatorKey.currentContext!);
      return;
    }

    ProgressDialog dialog = createProgressDialog(
        context: navigatorKey.currentContext!, msg: 'Wait ...'.tr());
    await dialog.show();

    try {
      ApiResponse apiResponse = await repository.addCourse(
          courseTitleController.text,
          descriptionController.text,
          priceController.text.isEmpty?0.0:double.parse(priceController.text),uploadCourseImage==null?"":uploadCourseImage!.path,isCourseFree);

      if (apiResponse.response!.statusCode == 200 ||
          apiResponse.response!.statusCode == 201) {
        if (apiResponse.response!.data['message'] == "done successfully"|| apiResponse.response!.data['message']=="تم بنجاح") {
          CustomScaffoldMessanger.showScaffoledMessanger(
              title: 'Course added successfully'.tr());
          Navigator.pop(navigatorKey.currentContext!);
        } else {
          CustomScaffoldMessanger.showScaffoledMessanger(
              title: apiResponse.response!.data['message']);
        }
      }
    } catch (e) {
      CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
    } finally {
      await dialog.hide();
    }
  }


  void getCourseDetails(int courseId)async{
    ProgressDialog dialog = createProgressDialog(
        context: navigatorKey.currentContext!, msg: 'Wait ...'.tr());
    await dialog.show();
    try{
      ApiResponse apiResponse = await repository.getCourseDetails(courseId);
      if(apiResponse.response!.statusCode==200||apiResponse.response!.statusCode==201){
        if(apiResponse.response!.data['message']=="done successfully"||apiResponse.response!.data['message']=="تم بنجاح"){
          courseDetailsResponse = CourseDetailsResponse.fromJson(apiResponse.response!.data);
        }
      }
      await dialog.hide();
      notifyListeners();
    }catch(e){
      CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
    }
  }

  void uploadeSessionVideo(int courseId,String fileName,File file)async{
    ProgressDialog dialog = createProgressDialog(
        context: navigatorKey.currentContext!, msg: 'Wait ...'.tr());
    try{
      await dialog.show();
      ApiResponse apiResponse = await repository.uploadSessionVideo(courseId, fileName, fileName, isSessionFree,
          DateFormat('yyyy-MM-dd').format(DateTime.now()),
          "${TimeOfDay.now().hour.toString().padLeft(2, '0')}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}",
          "${TimeOfDay.now().hour.toString().padLeft(2, '0')}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}"
          ,"recorded", file);
      if(apiResponse.response!.statusCode==200 || apiResponse.response!.statusCode==201){
        if(apiResponse.response!.data['message'] == "done successfully" || apiResponse.response!.data['message']=="تم بنجاح"){
          if(dialog.isShowing()){
            await dialog.hide();
          }
          CustomScaffoldMessanger.showScaffoledMessanger(
              title: "Session created successfully");
          Navigator.pop(navigatorKey.currentContext!);
        }else{
          CustomScaffoldMessanger.showScaffoledMessanger(
              title: "Something went wrong".tr());
        }
      }else{
        CustomScaffoldMessanger.showScaffoledMessanger(
            title: "Something went wrong".tr());
      }
    }catch (e) {
      CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
    } finally {
      if (dialog.isShowing() && navigatorKey.currentContext != null) {
        await dialog.hide();
      }
    }
  }

  Future<void> deleteSession(int sessionId)async{
    ProgressDialog dialog = createProgressDialog(
        context: navigatorKey.currentContext!, msg: 'Wait ...'.tr());
    try{
      await dialog.show();
      ApiResponse apiResponse = await repository.deleteSession(sessionId);
      if(apiResponse.response!.statusCode==200 || apiResponse.response!.statusCode==201){
        if(apiResponse.response!.data['message']=="Session Deleted Successfully"|| apiResponse.response!.data['message']=="تم حذف المحاضرة بنجاح"){
          if(dialog.isShowing()){
            await dialog.hide();
          }

          CustomScaffoldMessanger.showScaffoledMessanger(title: "Session Deleted Successfully".tr());
        }else{
          if(dialog.isShowing()){
            await dialog.hide();
          }
          CustomScaffoldMessanger.showScaffoledMessanger(title: "Something went wrong".tr());
        }
      }
    }catch(e){
      CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
    }finally{
      if(dialog.isShowing()){
        await dialog.hide();
      }
    }
  }

  Future<void> deleteCourse(int courseId)async{
    ProgressDialog dialog = createProgressDialog(
        context: navigatorKey.currentContext!, msg: 'Wait ...'.tr());
    try{
      await dialog.show();
      ApiResponse apiResponse = await repository.deleteCourse(courseId);
      if(apiResponse.response!.statusCode==200||apiResponse.response!.statusCode==201){
        if(apiResponse.response!.data['message']=="done successfully"||apiResponse.response!.data['message']=="تم بنجاح"){
          if(dialog.isShowing()){
            await dialog.hide();
          }
          CustomScaffoldMessanger.showScaffoledMessanger(title: "Course deleted successfully".tr());
        }else{
          CustomScaffoldMessanger.showScaffoledMessanger(title: "Something went wrong".tr());
        }
      }else{
        CustomScaffoldMessanger.showScaffoledMessanger(title: "Something went wrong".tr());
      }
    }catch(e){
      CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
    }finally{
      if(dialog.isShowing()){
        await dialog.hide();
      }
    }
  }
}
