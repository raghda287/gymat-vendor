import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/core/utils/preferences.dart';
import 'package:gymatvendor/data/models/notificationSetting.dart';
import 'package:gymatvendor/injection.dart';
import 'package:gymatvendor/main.dart';
import 'package:gymatvendor/presentations/profile_module/provider/profile_provider.dart';
import 'package:gymatvendor/presentations/widgets/dialogs/progress_dialog.dart';
import 'package:gymatvendor/theme_provider.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import '../../../../data/models/api_response.dart';
import '../../../../data/repositories/general_setting_repository.dart';
import '../../../widgets/dialogs/scaffold_messanger.dart';

class GeneralSettingProvider with ChangeNotifier{
  GeneralSettingRepository repository = getIt();

  late bool isDarkModel = AppTheme.isDarkMode();
  bool isLoadingNotificationSetting = true;
  bool isLoadingChatSetting = true;
  bool isLoadingBookingsSetting = true;
  NotificationSetting? notificationSetting;


  void init(){
    isLoadingChatSetting = true;
    isLoadingNotificationSetting = true;
    isLoadingBookingsSetting = true;
  }


  void getNotificationSetting() async{
    try {
      isLoadingNotificationSetting = true;
      isLoadingChatSetting = true;
      isLoadingBookingsSetting = true;
      ApiResponse response = await repository.getNotificationSetting();

      isLoadingNotificationSetting = false;
      isLoadingChatSetting = false;
      isLoadingBookingsSetting = false;

      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          notificationSetting = NotificationSetting.fromJson(response.response!.data['data']);

          if(notificationSetting!=null){
            ProfileProvider profileProvider = getIt();

            await profileProvider.updateMainAccountNotificationSetting(notificationSetting!);
          }

          notifyListeners();

        }
      }else{
        if(response.error!=null){
          CustomScaffoldMessanger.showScaffoledMessanger(title: response.error);
        }
      }
    } catch (e) {
      isLoadingNotificationSetting = false;
      isLoadingChatSetting = false;
      isLoadingBookingsSetting = isLoadingBookingsSetting;

      notifyListeners();
      if (e is DioException) {
        if (e.response!.statusCode != 500) {
          CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
        }
      }
      print('notification settings error>>>${e.toString()}');
    }
  }


  void changeNotificationAction() async{
    ProgressDialog dialog = createProgressDialog(context: navigatorKey.currentContext!, msg: 'Updating...'.tr());

    try {
      await dialog.show();
      ApiResponse response = await repository.updateNotificationStatus();

      await dialog.hide();

      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          notificationSetting = NotificationSetting.fromJson(response.response!.data['data']);
          if(notificationSetting!=null){
            ProfileProvider profileProvider = getIt();

            await profileProvider.updateMainAccountNotificationSetting(notificationSetting!);
          }
          notifyListeners();

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
      print('change notification settings error>>>${e.toString()}');
    }


  }

  void changeMessageNotificationAction() async{

    ProgressDialog dialog = createProgressDialog(context: navigatorKey.currentContext!, msg: 'Updating...'.tr());

    try {
      await dialog.show();
      ApiResponse response = await repository.updateChatStatus();

      await dialog.hide();

      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          notificationSetting = NotificationSetting.fromJson(response.response!.data['data']);
          if(notificationSetting!=null){
            ProfileProvider profileProvider = getIt();

            await profileProvider.updateMainAccountNotificationSetting(notificationSetting!);
          }
          notifyListeners();

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
      print('change notification settings error>>>${e.toString()}');
    }

  }

  void changeReceiveBookingAction() async{

    ProgressDialog dialog = createProgressDialog(context: navigatorKey.currentContext!, msg: 'Updating...'.tr());

    try {
      await dialog.show();
      ApiResponse response = await repository.updateReceiveBookingStatus();

      await dialog.hide();

      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          notificationSetting = NotificationSetting.fromJson(response.response!.data['data']);
          if(notificationSetting!=null){
            ProfileProvider profileProvider = getIt();

            await profileProvider.updateMainAccountNotificationSetting(notificationSetting!);
          }
          notifyListeners();

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
      print('change notification settings error>>>${e.toString()}');
    }

  }


  void changeDarkMode(bool value){
    isDarkModel = value;
    notifyListeners();
    ThemeProvider provider = getIt();
    provider.changeDarkMode();
  }
}