import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/utils/preferences.dart';
import 'package:gymatvendor/data/models/notificationSetting.dart';
import 'package:gymatvendor/data/models/user_model.dart';
import 'package:gymatvendor/injection.dart';
import 'package:gymatvendor/presentations/auth_module/provider/auth_provider.dart';
import 'package:gymatvendor/presentations/widgets/dialogs/scaffold_messanger.dart';

import '../../../data/models/api_response.dart';
import '../../../data/repositories/profile_repository.dart';

class ProfileProvider with ChangeNotifier {
  ProfileRepository repository = getIt();
  Preferences preferences = Preferences();
  late UserModel? userModel = preferences.getUserData();
  num folowers = 0;

  void init() {
    if (getUserModel() != null) {
      folowers =
          getUserModel()!.providerModel?.mainAccount?.followers_count ?? 0;
      notifyListeners();
    }
  }

  void decreaseFollowers() {
    if (folowers > 0) {
      folowers--;
      userModel = getUserModel();
      if (userModel != null) {
        userModel!.providerModel?.mainAccount?.followers_count = folowers;
        preferences.saveUserData(userModel!);
      }
      notifyListeners();
    }
  }

  void updateFollowersCount(num count) {
    folowers = count;
    userModel = getUserModel();
    if (userModel != null) {
      userModel!.providerModel?.mainAccount?.followers_count = folowers;
      preferences.saveUserData(userModel!);
    }
    notifyListeners();
  }

  UserModel? getUserModel() {

    return preferences.getUserData();
  }

  void updateUserData(UserModel userModel) {
    this.userModel = userModel;
    notifyListeners();
  }

  bool isAccountProviderCompleted() {
    UserModel? userModel = getUserModel();
    bool result =userModel != null &&
        userModel.providerModel != null &&
        userModel.providerModel!.mainAccount != null &&
        userModel.providerModel!.mainAccount!.business_name != null &&
        userModel.providerModel!.mainAccount!.phone_code != null &&
        userModel.providerModel!.mainAccount!.phone != null &&
        userModel.providerModel!.mainAccount!.desc != null &&
        userModel.providerModel!.mainAccount!.address != null &&
        userModel.providerModel!.sign_info;


    return result;


  }

  bool isSelectedWorkWith() {
    UserModel? userModel = getUserModel();
    bool result=  userModel != null &&
        userModel.providerModel != null &&
        userModel.providerModel!.mainAccount != null &&
        userModel.providerModel!.mainAccount!.for_gender != null;


    return result;
  }

  bool isSelectedBio() {
    UserModel? userModel = getUserModel();
    if(userModel != null &&
        userModel.providerModel != null &&
        userModel.providerModel!.mainAccount != null && userModel.providerModel!.mainAccount!.category.type == USERTYPE.coache.name){
      return userModel.providerModel != null &&
          userModel.providerModel!.mainAccount != null &&
          userModel.providerModel!.mainAccount!.desc != null &&
          userModel.providerModel!.mainAccount!.desc!.isNotEmpty &&
          userModel.providerModel!.mainAccount!.education != null &&
          userModel.providerModel!.mainAccount!.education!.isNotEmpty &&
          userModel.providerModel!.mainAccount!.certifications != null &&
          userModel.providerModel!.mainAccount!.certifications!.isNotEmpty &&
          userModel.providerModel!.mainAccount!.experience != null &&
          userModel.providerModel!.mainAccount!.experience!.isNotEmpty;
    }else{
      return true;
    }

  }

  Future<bool> updateMainAccount(AccountsModel account) async {
    UserModel? userModel = getUserModel();
    if (userModel != null && userModel.providerModel != null) {
      userModel.providerModel!.mainAccount = account;
      Preferences().saveUserData(userModel);
      updateUserData(userModel);
      return true;
    }
    return false;
  }

  Future<bool> updateMainAccountNotificationSetting(NotificationSetting notificationSetting) async {
    UserModel? userModel = getUserModel();
    if (userModel != null && userModel.providerModel != null) {

      userModel.providerModel!.mainAccount?.is_message = notificationSetting.is_message;
      userModel.providerModel!.mainAccount?.is_notification = notificationSetting.is_notification;
      userModel.providerModel!.mainAccount?.bookable = notificationSetting.bookable;

      Preferences().saveUserData(userModel);
      updateUserData(userModel);
      return true;
    }
    return false;
  }

  void getProfile() async {
    try {
      ApiResponse response = await repository.getProfile();
      if (response.response != null && response.response!.statusCode == 200) {

        if (response.response!.data['data'] != null&&response.response!.data['code'] == 200) {
          if(response.response!.data['data']['provider']['is_accepted']!=null){
            bool isAccepted = response.response!.data['data']['provider']['is_accepted'];
            UserModel? userModel = getUserModel();
            if(userModel!=null){
              userModel.providerModel?.is_accepted = isAccepted;
              preferences.saveUserData(userModel);
              updateUserData(userModel);
            }
          }
        }
      } else {
        if (response.error != null) {
          CustomScaffoldMessanger.showScaffoledMessanger(title: response.error);
        }
      }
    } catch (e) {
      notifyListeners();
      if (e is DioException) {
        if (e.response!.statusCode != 500) {
          CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
        }
      }
      print('cards error>>>${e.toString()}');
    }
  }

}
