import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/navigator/navigator.dart';
import 'package:gymatvendor/data/models/service_model.dart';
import 'package:gymatvendor/data/repositories/gym_service_repository.dart';
import 'package:gymatvendor/injection.dart';
import 'package:gymatvendor/main.dart';
import 'package:gymatvendor/presentations/healthcub_spa_module/provider/healthyclub_spa_home_provider.dart';
import 'package:gymatvendor/presentations/widgets/dialogs/progress_dialog.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../core/app_theme/theme.dart';
import '../../../data/models/api_response.dart';
import '../../../data/models/department_model.dart';
import '../../../data/models/subscribtion_model.dart';
import '../../../data/repositories/health_club_spa_repository.dart';
import '../../../data/repositories/health_food_repository.dart';
import '../../widgets/dialogs/scaffold_messanger.dart';
import 'healthy_food_home_provider.dart';

class HealthyFoodServicesProvider with ChangeNotifier {
  ItemScrollController? gymServiceDepartmentItemController;

  List<DepartmentModel> departments = [];
  List<ServiceModel?> services = [];
  int selectedCategoryIndex = 0;

  //add edit service screen
  String? servicePhotoPath;
  HealthFoodServiceRepository repository = getIt();
  bool isLoading = true;

  // service pagination
  int serviceCurrentPage = 1;
  bool isLoadingDepartment = false;
  bool isLoadingMoreService = false;
  CancelToken? serviceCancelToken;
  List<SubscribtionModel> subscribtions = [];

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
    gymServiceDepartmentItemController = ItemScrollController();
    getDepartments(null);
  }

  void updateSelectedCategory(index) {
    selectedCategoryIndex = index;
    notifyListeners();
    getServiceByDepartment(false);
  }

  void addSubscribtionItem(SubscribtionModel model) {
    subscribtions.add(model);
    notifyListeners();
  }

  void deleteSubscribtionItem(int index) {
    subscribtions.removeAt(index);
    notifyListeners();
  }

  void pickImage(ImageSource source, ) async {
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
  void getDepartments(DepartmentModel? homeDepartmentModel) async {
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
                gymServiceDepartmentItemController?.jumpTo(index: index);
                getServiceByDepartment(false);
                break;
              }
            }
          } else {
            getServiceByDepartment(false);
          }
        } else {
          notifyListeners();
          //CustomScaffoldMessanger.showScaffoledMessanger(title: response.innerMessage??'Something went wrong'.tr());
        }
      } else {
        if (response.error != null) {
          CustomScaffoldMessanger.showScaffoledMessanger(title: response.error);
        }
        notifyListeners();
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
      print('food category error>>>${e.toString()}');
    }
  }

  void addDepartment(String title) async {
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
            DepartmentModel departmentModel =
                DepartmentModel.fromJson(response.response!.data['data']);
            departments.add(departmentModel);
            notifyListeners();

            HealthyFoodHomeProvider healthyFoodHomeProvider = getIt();
            healthyFoodHomeProvider.addNewDepartment(departmentModel);
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
      print('food add category error>>>${e.toString()}');
    }
  }

  void updateDepartment(DepartmentModel model, String title, index) async {
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
            HealthyFoodHomeProvider healthyFoodHomeProvider = getIt();
            healthyFoodHomeProvider.updateDepartmentItem(departmentModel);
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
      print('food update category error>>>${e.toString()}');
    }
  }

  void deleteDepartment(DepartmentModel model) async {
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
          HealthyClubSpaHomeProvider healthyClubSpaHomeProvider = getIt();
          healthyClubSpaHomeProvider.getDepartments();
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
      print('food delete category error>>>${e.toString()}');
    }
  }

  /// add update delete service call apis
  void getServiceByDepartment(bool isLoadMore) async {
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

      ApiResponse response = await repository.getServicesByDepartment(
          serviceCurrentPage, departments[selectedCategoryIndex].id,
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
        }
      } else {
        if (response.error != null) {
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
      print('food services error>>>${e.toString()}');
    }
  }

  void addService(num departmentId, String serviceName, String servicePrice,
      String duration, String calories, String description,String discount,bool isDiscountActive,String discountType) async {
    ProgressDialog dialog = createProgressDialog(
        context: navigatorKey.currentContext!, msg: 'Adding...'.tr());
    await dialog.show();
    try {
      ApiResponse response = await repository.addService(
          departmentId,
          serviceName,
          servicePhotoPath!,
          servicePrice,
          duration,
          calories,
          description,
          discount,
          isDiscountActive,
          discountType);
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
      print('food service add error>>>${e.toString()}');
    }
  }

  void updateService(
      num serviceId,
      num departmentId,
      String serviceName,
      String servicePrice,
      String duration,
      String durationUnitType,
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
          duration,
          durationUnitType,
          description,discount,
          isDiscountActive,
          discountType);
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
      print('food service update error>>>${e.toString()}');
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
      print('food delete service error>>>${e.toString()}');
    }
  }
}
