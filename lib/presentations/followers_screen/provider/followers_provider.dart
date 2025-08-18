import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/utils/preferences.dart';
import 'package:gymatvendor/data/models/followerModel.dart';
import 'package:gymatvendor/data/models/user_model.dart';
import 'package:gymatvendor/data/repositories/auth_repository.dart';
import 'package:gymatvendor/data/repositories/coach_workout_repository.dart';
import 'package:gymatvendor/data/repositories/followers_repository.dart';
import 'package:gymatvendor/injection.dart';
import 'package:gymatvendor/main.dart';
import 'package:gymatvendor/presentations/profile_module/provider/profile_provider.dart';
import 'package:gymatvendor/presentations/widgets/dialogs/progress_dialog.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import '../../../data/models/api_response.dart';
import '../../../data/models/department_model.dart';
import '../../../data/models/statisticsHomeModel.dart';
import '../../../data/models/workout_model.dart';
import '../../../data/repositories/coach_home_repository.dart';
import '../../../data/repositories/coach_service_repository.dart';
import '../../widgets/dialogs/scaffold_messanger.dart';

class FollowersProvider with ChangeNotifier{
  FollowersRepository followersRepository = getIt();
  List<FollowerModel?> followers = [];

  bool isLoading= true;
  bool isLoadingMore = false;

  int page = 1;


  void getFollowers() async {
    page = 1;
    followers.clear();
    isLoading = true;
    isLoadingMore = false;
    notifyListeners();
    try {
      ApiResponse response = await followersRepository.getFollowers(page);
      isLoading = false;

      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          response.response!.data['data'].forEach((v) => followers.add(FollowerModel.fromJson(v)));


          ProfileProvider profileProvider = getIt();
          profileProvider.updateFollowersCount(followers.length);
          notifyListeners();

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
      print('followers error>>>${e.toString()}');
    }
  }


  void loadMoreFollowers() async {
    isLoadingMore = true;
    notifyListeners();
    followers.add(null);
    try {
      int p = page+1;


      ApiResponse response = await followersRepository.getFollowers(p);
      isLoadingMore = false;
      if(followers.last==null){
        followers.removeLast();
      }


      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          response.response!.data['data'].forEach((v) => followers.add(FollowerModel.fromJson(v)));


        }
      }else{
        if(response.error!=null){
          CustomScaffoldMessanger.showScaffoledMessanger(title: response.error);
        }
      }
    } catch (e) {
      isLoadingMore = false;
      if(followers.last==null){
        followers.removeLast();
      }
      notifyListeners();
      if (e is DioException) {
        if (e.response!.statusCode != 500) {
          CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
        }
      }
      print('followers error>>>${e.toString()}');
    }
  }

  void deleteFollower(num? userId,int index) async{
    ProgressDialog dialog = createProgressDialog(context: navigatorKey.currentContext!, msg: 'Deleting...'.tr());
    try {
      await dialog.show();

      ApiResponse response = await followersRepository.deleteFollower(userId);
      await dialog.hide();

      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          followers.removeAt(index);
          ProfileProvider profileProvider = getIt();
          profileProvider.decreaseFollowers();

          notifyListeners();
        }
      }else{
        if(response.error!=null){
          CustomScaffoldMessanger.showScaffoledMessanger(title: response.error);
        }
      }
    } catch (e) {
      await dialog.show();

      if (e is DioException) {
        if (e.response!.statusCode != 500) {
          CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
        }
      }
      print('delete followers error>>>${e.toString()}');
    }
  }

}