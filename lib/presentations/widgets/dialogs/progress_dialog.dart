import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/core/text_styles/text_styles.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

ProgressDialog createProgressDialog(
    {required BuildContext context, required String msg}) {
  String lang = context.locale.languageCode;
  msg = msg.replaceAll('.', '');
  msg = lang=='ar'? '.... $msg':'$msg ....';
  var dialog = ProgressDialog(context, isDismissible: false,);

  dialog.style(
    backgroundColor: AppTheme.isDarkMode()?dark:Colors.white,
    message: msg,
    messageTextStyle: AppTextStyles().normalText(fontSize: 14).textColorNormal(AppTheme.isDarkMode()?Colors.white:Colors.black),
    textAlign: lang=='ar'?TextAlign.end:TextAlign.start,
    progressWidget: Container(
        padding: const EdgeInsets.all(12.0),
        child: const CircularProgressIndicator(strokeWidth: 2,color: mainColor,)),
      borderRadius: 4,
      );
  return dialog;
}
