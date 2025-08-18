import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';

import 'package:permission_handler/permission_handler.dart';

import '../../../core/text_styles/text_styles.dart';
import '../../../injection.dart';
import '../../../main.dart';
import '../custom_text/custom_text.dart';

class MicroPhoneDialog{

  static void showMicrophoneDialogPermission(VoidCallback onAllow,VoidCallback onNotAllow){
    showDialog(context: navigatorKey.currentContext!,barrierDismissible: true, builder: (context){
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        backgroundColor: dark,
        surfaceTintColor: Colors.transparent,
        content:  Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text.rich(TextSpan(text: 'Allow'.tr(),style: AppTextStyles().normalText(fontSize: 14).textColorNormal(Colors.white),children: [
             TextSpan(text: ' ${'app_name'.tr()} ',style: AppTextStyles().normalText(fontSize: 15).textColorNormal(mainColor)),
             TextSpan(text: 'to access camera and microphone permission'.tr(),style: AppTextStyles().normalText(fontSize: 14).textColorNormal(Colors.white))

            ]))

          ],),
        actions: [
          InkWell(
              onTap: onAllow,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: CustomText(title: 'Allow'.tr(),fontSize: 14,fontColor:Colors.white,),
              )),
          InkWell(
              onTap: onNotAllow,
              child: CustomText(title: 'Not allow'.tr(),fontSize: 14,fontColor: Colors.white)),

        ],
      );
    });
  }
}


