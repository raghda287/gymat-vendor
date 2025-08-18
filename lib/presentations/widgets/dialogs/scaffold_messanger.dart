import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../main.dart';
import '../custom_text/custom_text.dart';


class CustomScaffoldMessanger{
  static void showScaffoledMessanger({required String title,Color? bg,Color? fontColor,}){
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(content:CustomText(title: title,fontColor: fontColor??white,fontSize:14,),backgroundColor: bg??mainColor,));
  }

  static void showToast({required String title,Color? bg,Color? fontColor,ToastGravity gravity = ToastGravity.CENTER}){
    Fluttertoast.showToast(msg:title,backgroundColor: bg ?? (AppTheme.isDarkMode()?Colors.white:Colors.black),textColor: fontColor??(AppTheme.isDarkMode()?Colors.black:Colors.white),gravity: gravity,toastLength: Toast.LENGTH_LONG);
  }
}