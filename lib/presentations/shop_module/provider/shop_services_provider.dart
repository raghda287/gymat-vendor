import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/navigator/navigator.dart';
import 'package:gymatvendor/core/utils/preferences.dart';
import 'package:gymatvendor/data/models/add_addition_model.dart';
import 'package:gymatvendor/data/models/service_model.dart';
import 'package:gymatvendor/data/models/shop_service_model.dart';
import 'package:gymatvendor/data/models/user_model.dart';
import 'package:gymatvendor/data/repositories/gym_service_repository.dart';
import 'package:gymatvendor/data/repositories/shop_repository.dart';
import 'package:gymatvendor/injection.dart';
import 'package:gymatvendor/main.dart';
import 'package:gymatvendor/presentations/healthcub_spa_module/provider/healthyclub_spa_home_provider.dart';
import 'package:gymatvendor/presentations/shop_module/provider/shop_home_provider.dart';
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

class ShopServicesProvider with ChangeNotifier {
  ShopServiceRepository repository = getIt();
  ItemScrollController? shopServiceDepartmentItemController;
  List<DepartmentModel> departments = [];
  int selectedCategoryIndex = 0;
  int selectedShopCategoryIndex = 0;

  bool isLoading = false;
  List<ShopCategory> shopCategoryList = [];
  List<String> photoPaths = [];
  List<AddAditionModel> additions =[];
  List<ShopServiceModel?> services = [];
  int serviceCurrentPage = 1;
  bool isLoadingMoreService = false;
  CancelToken? serviceCancelToken;
  CancelToken? departmentCancelToken;

  Map<String,num> serviceImagesMap ={};

  void init(DepartmentModel? homeDepartmentModel) {
    isLoading = false;
    selectedCategoryIndex = 0;
    shopCategoryList =[];
    departments = [];
    services = [];
    serviceCancelToken = null;
    departmentCancelToken = null;
    getShopCategory(homeDepartmentModel);

  }

  void initAddService(ShopServiceModel? shopServiceModel){
    photoPaths =[];
    additions =[];
    serviceImagesMap = {};
    if(shopServiceModel!=null){
      for(Photo photo in shopServiceModel.images){
        if(photo.image!=null){
          photoPaths.add(photo.image!);
          serviceImagesMap[photo.image!] = photo.id!;
        }
      }

      if(shopServiceModel.details.isNotEmpty){
        for(Details details in shopServiceModel.details){
          if(details.title!=null&&details.title!.isNotEmpty&&details.price!=null){
            additions.add(AddAditionModel(details.title!, details.price!,details.has_offer,details.offer_value,details.offer_type,details.new_price));

          }
        }
      }


    }

  }

  void pickImage(ImageSource source,) async {
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
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            aspectRatioPresets: [
              CropAspectRatioPreset.square
            ],
          ),
          IOSUiSettings(title: 'Cropper', aspectRatioLockEnabled: true,
            aspectRatioPresets: [
              CropAspectRatioPreset.square
            ],
          ),
        ],
      );

      if (croppedFile != null) {
        String servicePhotoPath = 'fileimage:${croppedFile.path}';
        photoPaths.add(servicePhotoPath);
        notifyListeners();
      }
    }
  }

  void updateSelectedCategory(index) {
    if(index==selectedCategoryIndex){
      return;
    }
    selectedCategoryIndex = index;
    notifyListeners();

    getService(false);
  }

  void updateSelectedShopCategory(int index,DepartmentModel? homeDepartmentModel) {
    if(index==selectedShopCategoryIndex){
      return;
    }else{
      homeDepartmentModel = null;
    }
    selectedShopCategoryIndex = index;
    selectedCategoryIndex=0;
    departments = [];
    services =[];
    notifyListeners();
    getDepartments(homeDepartmentModel);
  }


  /// call apis

  void removeServicePhotoPath(int index) {
    String path = photoPaths[index];
    if(path.startsWith('http')){
      if(getOnlineImageCount()>1){
        deleteServiceImage(serviceImagesMap[path]!, index,path);
      }else{
        CustomScaffoldMessanger.showScaffoledMessanger(title: 'Cannot delete this photo. should have at least 1 photo'.tr());
      }
    }else{
      photoPaths.removeAt(index);
      notifyListeners();
    }

  }

  void addAddition(AddAditionModel model) {
    additions.add(model);
    notifyListeners();
  }

  void removeAddition(int index) {
    additions.removeAt(index);
    notifyListeners();
  }

  void checkAddService(ShopServiceModel? shopServiceModel,DepartmentModel? shopDepartmentModel,DepartmentModel? departmentModel, String name, String describtion,String price,String discount,bool isDiscountActive,String discountType) {
    RegExp regExp = RegExp(r'^\d*\.?\d{1,2}$');
    if(shopDepartmentModel!=null){
      if(departmentModel!=null&&name.isNotEmpty&&photoPaths.isNotEmpty&&describtion.isNotEmpty){
        if(additions.isNotEmpty){
          if(shopServiceModel==null){
            addService(shopDepartmentModel,departmentModel,name,describtion,price,null,null,null);

          }else{
            updateService(shopServiceModel,shopDepartmentModel,departmentModel,name,describtion,price,discount,isDiscountActive,discountType);

          }
        }else if(regExp.hasMatch(price)&&num.parse(price)!=0){

          if(isDiscountActive){

            if(!regExp.hasMatch(discount)){
              CustomScaffoldMessanger.showToast(title: 'Invalid discount value'.tr());
              return;
            }else if(num.parse(discount)==0){

              CustomScaffoldMessanger.showToast(title: 'Invalid discount value'.tr());
              return;
            }else if((discountType=='value'&&num.parse(discount)>=num.parse(price))||((discountType=='per'&&num.parse(discount)>=100))){

              CustomScaffoldMessanger.showToast(title: 'Invalid discount value'.tr());
              return;
            }

          }

          if(shopServiceModel==null){
            addService(shopDepartmentModel,departmentModel,name,describtion,price,discount,isDiscountActive,discountType);

          }else{
            updateService(shopServiceModel,shopDepartmentModel,departmentModel,name,describtion,price,discount,isDiscountActive,discountType);

          }
        }else{
          CustomScaffoldMessanger.showToast(title: 'Invalid price'.tr());
        }
      }else if(departmentModel ==null){
        CustomScaffoldMessanger.showToast(title: 'Choose department2'.tr());
      }else if(name.isEmpty){
        CustomScaffoldMessanger.showToast(title: 'Name is required'.tr());
      }else if(photoPaths.isEmpty){
        CustomScaffoldMessanger.showToast(title: 'Choose at least 1 photo'.tr());
      }else if(additions.isEmpty&&(!regExp.hasMatch(price)||num.parse(price)==0)){
        CustomScaffoldMessanger.showToast(title: 'Invalid price'.tr());
      }else if(describtion.isEmpty){
        CustomScaffoldMessanger.showToast(title: 'Description is required'.tr());
      }
    }else{
      CustomScaffoldMessanger.showToast(title: 'Shop department is required.please go to update account page and select your department'.tr());

    }

  }

  void getShopCategory(DepartmentModel? homeDepartmentModel) async{
    UserModel? userModel = Preferences().getUserData();
    if(userModel!=null&&userModel.providerModel!=null&&userModel.providerModel!.mainAccount!=null&&userModel.providerModel!.mainAccount!.shop_categories.isNotEmpty){
      shopCategoryList.clear();
      shopCategoryList = userModel.providerModel!.mainAccount!.shop_categories;

      if(homeDepartmentModel==null){
        selectedShopCategoryIndex = 0;
        notifyListeners();

        getDepartments(homeDepartmentModel);
      }else{
        for (int index = 0; index < shopCategoryList.length; index++) {
          if (shopCategoryList[index].category_id == homeDepartmentModel.parent_id) {
            selectedShopCategoryIndex = index;
            notifyListeners();
            getDepartments(homeDepartmentModel);
            break;
          }
        }
      }
    }
  }

  void getDepartments(DepartmentModel? homeDepartmentModel) async {
    departments.clear();
    isLoading = true;
    notifyListeners();

    if(departmentCancelToken!=null){
      departmentCancelToken!.cancel();
      departmentCancelToken = null;
    }


    try {

      departmentCancelToken ??= CancelToken();

      if(shopCategoryList.isEmpty){
        isLoading = false;
        notifyListeners();
        return;
      }

      num parent_id = shopCategoryList[selectedShopCategoryIndex].category_id!;

      ApiResponse response = await repository.getCategories(null,parent_id,departmentCancelToken);
      if (response.response != null && response.response!.statusCode == 200) {



        if (response.code == 200) {
          response.response!.data['data'].forEach((v) => departments.add(DepartmentModel.fromJson(v)));
          notifyListeners();
          await Future.delayed(const Duration(milliseconds: 50));
          if (homeDepartmentModel != null) {

            for (int index = 0; index < departments.length; index++) {
              if (departments[index].id == homeDepartmentModel.id) {
                selectedCategoryIndex = index;
                shopServiceDepartmentItemController?.jumpTo(index: index);
                notifyListeners();
                getService(false);
                break;
              }
            }

          } else {
            getService(false);

          }
        } else {
          isLoading = false;
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
      notifyListeners();
      if (e is DioException) {
        if (e.response!.statusCode != 500) {
          CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
        }
      }
      print('shop category error>>>${e.toString()}');
    }
  }

  void addDepartment(String title) async {
    ProgressDialog dialog = createProgressDialog(
        context: navigatorKey.currentContext!, msg: 'Adding...'.tr());
    await dialog.show();
    try {

      if(shopCategoryList.isEmpty){
        dialog.hide();
        return;
      }

      num parent_id = shopCategoryList[selectedShopCategoryIndex].category_id!;
      print('parentID=>>>>${parent_id}');


      ApiResponse response = await repository.addCategories(title,parent_id);
      await dialog.hide();
      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          if (response.response!.data != null &&
              response.response!.data['data'] != null) {
            DepartmentModel departmentModel =
            DepartmentModel.fromJson(response.response!.data['data']);
            departments.add(departmentModel);
            notifyListeners();

            ShopHomeProvider shopHomeProvider = getIt();
            shopHomeProvider.addNewDepartment(departmentModel);
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
      print('shop add category error>>>${e.toString()}');
    }
  }

  void updateDepartment(DepartmentModel model, String title, index) async {
    ProgressDialog dialog = createProgressDialog(
        context: navigatorKey.currentContext!, msg: 'Updating...'.tr());
    await dialog.show();
    try {
      ApiResponse response = await repository.updateCategories(model.id.toString(), title,(selectedCategoryIndex+1));
      await dialog.hide();

      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          if (response.response!.data != null &&
              response.response!.data['data'] != null) {
            DepartmentModel departmentModel = DepartmentModel.fromJson(response.response!.data['data']);
            departments[index] = departmentModel;
            notifyListeners();
            ShopHomeProvider shopHomeProvider = getIt();
            shopHomeProvider.updateDepartmentItem(departmentModel);
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
      print('shop update category error>>>${e.toString()}');
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
            notifyListeners();
            getService(false);
          }else{
/*
            notifyListeners();
*/
            getService(false);
          }
          ShopHomeProvider shopHomeProvider = getIt();
          shopHomeProvider.getDepartments();
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
      print('shop delete category error>>>${e.toString()}');
    }
  }

  void addService(DepartmentModel shopDepartmentModel,DepartmentModel departmentModel, String name, String describtion, String price,String? discount,bool? isDiscountActive,String? discountType) async{
    ProgressDialog dialog = createProgressDialog(context: navigatorKey.currentContext!, msg: 'Adding...'.tr());
    await dialog.show();
    try {
      if(additions.isEmpty){
        additions.add(AddAditionModel('', num.parse(price),isDiscountActive,isDiscountActive!=null&&isDiscountActive?discount!=null?num.parse(discount):null:null,isDiscountActive!=null&&isDiscountActive?discountType:null,null));
      }
      ApiResponse response = await repository.addShopService(shopDepartmentModel.id!,departmentModel.id!,name,photoPaths,describtion,additions);
      await dialog.hide();
      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          if (response.response!.data != null) {
            photoPaths.clear();
            additions.clear();
            NavigatorHandler.pop();
            ShopServiceModel shopServiceModel = ShopServiceModel.fromJson(response.response!.data['data']);
            if(shopCategoryList[selectedShopCategoryIndex].id==shopServiceModel.main_category_id&&departments[selectedCategoryIndex].id == shopServiceModel.category_id){
              services.insert(0, shopServiceModel);
              notifyListeners();
            }else{
              getService(false);
            }

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
      print('Service shop add error>>>${e.toString()}');
    }
  }

  void updateService(ShopServiceModel shopServiceModel,DepartmentModel shopDepartmentModel,DepartmentModel departmentModel, String name, String describtion, String price,String? discount,bool? isDiscountActive,String? discountType) async{
    ProgressDialog dialog = createProgressDialog(
        context: navigatorKey.currentContext!, msg: 'Updating...'.tr());
    await dialog.show();
    try {
      if(additions.isEmpty){
        additions.add(AddAditionModel('', num.parse(price),isDiscountActive,isDiscountActive!=null&&isDiscountActive?discount!=null?num.parse(discount):null:null,isDiscountActive!=null&&isDiscountActive?discountType:null,null));
      }
      ApiResponse response = await repository.updateShopService(shopServiceModel.id!,shopDepartmentModel.id!,departmentModel.id!,name,photoPaths,describtion,additions);
      await dialog.hide();
      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          if (response.response!.data != null) {
            ShopServiceModel model = ShopServiceModel.fromJson(response.response!.data['data']);

            photoPaths.clear();
            additions.clear();
            int serviceIndex = getServiceIndex(shopServiceModel.id!);
            if(serviceIndex!=-1){
              services[serviceIndex] = model;
              notifyListeners();
            }
            NavigatorHandler.pop();


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
      print('Service shop update error>>>${e.toString()}');
    }
  }

  void getService(bool isLoadMore) async{
    if(departments.isEmpty){

      isLoading = false;
      isLoadingMoreService = false;
      serviceCurrentPage = 1;
      services.clear();
      notifyListeners();
      if (serviceCancelToken != null) {
        serviceCancelToken!.cancel('canceled');
        serviceCancelToken = null;
      }
      return;
    }



    isLoadingMoreService = isLoadMore;

    if (!isLoadingMoreService) {
      isLoading = true;

      serviceCurrentPage = 1;
      services.clear();
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

      ApiResponse response = await repository.getShopService(departments[selectedCategoryIndex].id!,10,serviceCurrentPage,serviceCancelToken);
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


            List<ShopServiceModel> list = [];
            response.response!.data['data'].forEach((v) => list.add(ShopServiceModel.fromJson(v)));
            if (list.isNotEmpty) {
              serviceCurrentPage = serviceCurrentPage + 1;
            }
            services.addAll(list);
          } else {
            response.response!.data['data']
                .forEach((v) => services.add(ShopServiceModel.fromJson(v)));
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
      print('shop services error>>>${e.toString()}');
    }
  }

  void deleteService(ShopServiceModel model) async {
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
      print('shop delete service error>>>${e.toString()}');
    }
  }

  void deleteServiceImage(num imageId,index,String path) async {
    ProgressDialog dialog = createProgressDialog(
        context: navigatorKey.currentContext!, msg: 'Deleting...'.tr());
    await dialog.show();
    try {
      ApiResponse response =
      await repository.deleteServiceImage(imageId);
      await dialog.hide();
      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          photoPaths.removeAt(index);
          serviceImagesMap.remove(path);
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
      print('shop delete service image error>>>${e.toString()}');
    }
  }

  int getServiceIndex(num serviceId){
    for(int index = 0;index<services.length;index++){
      ShopServiceModel? model = services[index];
      if(model!=null&&model.id==serviceId){
        return index;
      }
    }
    return -1;
  }

  int getOnlineImageCount(){
    int count = 0;
    for(String path in photoPaths){
      if(path.startsWith('http')){
        count++;
      }
    }
    return count;
  }



}
