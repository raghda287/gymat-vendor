import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/navigator/navigator.dart';
import 'package:gymatvendor/core/utils/preferences.dart';
import 'package:gymatvendor/data/models/user_model.dart';
import 'package:gymatvendor/main.dart';
import 'package:gymatvendor/presentations/auth_module/provider/auth_provider.dart';
import 'package:gymatvendor/presentations/gym_module/provider/gym_home_provider.dart';

import '../../../../core/constants/constants.dart';
import '../../../../injection.dart';


class LanguageProvider with ChangeNotifier{
  int? selectedIndex;
  void init(){
    selectedIndex = getDefaultSelectedLanguageIndex();

  }


  void saveLanguage(int index) {
    navigatorKey.currentContext!.setLocale(Locale(appLanguage[index].languageCode,appLanguage[index].countryCode));
    UserModel? userModel = Preferences().getUserData();
    if(userModel!=null){
      String type = userModel.providerModel!.mainAccount!.category.type!;
      if(type==USERTYPE.gym.name){
        GymHomeProvider gymHomeProvider =getIt();
        gymHomeProvider.getDepartments();
      }
    }
    notifyListeners();

  }



  int? getDefaultSelectedLanguageIndex (){
    for(int index = 0;index<appLanguage.length;index++){
      String lang = navigatorKey.currentContext!.locale.languageCode;
      if(navigatorKey.currentContext!.locale.countryCode!=null&&navigatorKey.currentContext!.locale.countryCode!.isNotEmpty){
        lang = '${lang}_${navigatorKey.currentContext!.locale.countryCode}';
      }

      String appLang = appLanguage[index].languageCode;
      if(appLanguage[index].countryCode.isNotEmpty){
        appLang = '${appLang}_${appLanguage[index].countryCode}';
      }

      if(lang == appLang){
        return index;
      }
    }
    return null;
  }
}