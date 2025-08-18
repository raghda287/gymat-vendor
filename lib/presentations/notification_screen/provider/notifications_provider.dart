import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/data/models/notificationModel.dart';

import 'package:gymatvendor/injection.dart';

import '../../../data/models/api_response.dart';

import '../../../data/repositories/notification_repository.dart';
import '../../widgets/dialogs/scaffold_messanger.dart';

class NotificationsProvider with ChangeNotifier{
  NotificationsRepository repository = getIt();
  List<NotificationModel?> notification = [];

  bool isLoading= true;
  bool isLoadingMore = false;

  int page = 1;

  void init(){
    page = 1;
    isLoading = true;
    isLoadingMore = false;
    notification = [];

  }

  void getNotification() async {
    page = 1;
    notification.clear();
    isLoading = true;
    isLoadingMore = false;
    notifyListeners();
    try {
      ApiResponse response = await repository.getNotification(page);
      isLoading = false;

      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          response.response!.data['data'].forEach((v) => notification.add(NotificationModel.fromJson(v)));


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
      print('notification error>>>${e.toString()}');
    }
  }


  void loadMoreNotification() async {
    isLoadingMore = true;
    notifyListeners();
    notification.add(null);
    try {
      int p = page+1;


      ApiResponse response = await repository.getNotification(p);
      isLoadingMore = false;
      if(notification.last==null){
        notification.removeLast();

      }
      notifyListeners();


      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          List<NotificationModel> list = [];
          response.response!.data['data'].forEach((v) => list.add(NotificationModel.fromJson(v)));
          if(list.isNotEmpty){

            notification.addAll(list);
            page = p;

          }
          notifyListeners();

        }else{
          notifyListeners();
        }
      }else{
        if(response.error!=null){
          CustomScaffoldMessanger.showScaffoledMessanger(title: response.error);
        }
        notifyListeners();
      }
    } catch (e) {
      isLoadingMore = false;
      if(notification.last==null){
        notification.removeLast();
      }
      notifyListeners();
      if (e is DioException) {
        if (e.response!.statusCode != 500) {
          CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
        }
      }
      print('notification load more error>>>${e.toString()}');
    }
  }


}