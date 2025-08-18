
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/main.dart';

import '../../../../core/app_colors/app_colors.dart';
import '../../../../core/app_theme/theme.dart';


Future<TimeOfDay?> showTimePickerDialog([TimeOfDay? initTime]) async {
  TimeOfDay time = initTime??TimeOfDay.now();

  return await showTimePicker(
      context: navigatorKey.currentContext!,
      initialTime: time,


      builder: (context, child) {
        return Theme(data:Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
                primary: mainColor,
                onPrimary: AppTheme.isDarkMode()?Colors.white:Colors.black,
                secondary: mainColor,
                onSecondary: Colors.white,
                primaryContainer: Colors.transparent,
                surfaceTint: Colors.transparent,
                onBackground: AppTheme.isDarkMode()?Colors.black:inputBg,
                surface:AppTheme.isDarkMode()?inputBgDark:Colors.white ,
                onSurface: AppTheme.isDarkMode()?Colors.white:Colors.black),
            textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: AppTheme.isDarkMode()?Colors.white:mainColor))


        ) , child: child!);
      });

/*
  if(timeOfDay!=null){
    DateTime now = DateTime.now();

    if(type=='from'){
      DateTime from = DateTime(now.year,now.month,now.day,timeOfDay.hour,timeOfDay.minute);
      bool isOld = from.isBefore(now);
      if(!isOld){
        adProvider.updateFromTime(from);
        adProvider.updateToTime(null);
      }else{
        CustomScaffoldMessanger.showToast(title: 'Invalid time you choosed an old time'.tr(),bg: Colors.red);
      }



    }else{
      DateTime to = DateTime(now.year,now.month,now.day,timeOfDay.hour,timeOfDay.minute);
      bool isOld = to.isBefore(now);
      if(isOld){
        adProvider.updateToTime(null);

        CustomScaffoldMessanger.showToast(title: 'Invalid time you choosed an old time'.tr(),bg: Colors.red);
      }else if(to.isBefore(adProvider.fromTime!)){
        adProvider.updateToTime(null);
        CustomScaffoldMessanger.showToast(title: 'To time must be greater than from time'.tr(),bg: Colors.red);

      }else{
        adProvider.updateToTime(to);

      }



    }
  }
*/
}
