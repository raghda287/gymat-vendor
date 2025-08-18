import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/core/constants/constants.dart';
import 'package:gymatvendor/main.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/presentations/widgets/custom_svg/CustomSvgIcon.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';
class AppSheet{
  static void showPhotoSheet({required VoidCallback onTapCamera,required VoidCallback onTapGallery}){
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(24),topRight: Radius.circular(24)),),
        backgroundColor: AppTheme.isDarkMode()?cardDark:Colors.white,
        isScrollControlled: true,
        context: navigatorKey.currentContext!, builder: (context){
          return Padding(
            padding:  EdgeInsets.only(bottom: MediaQuery.of(navigatorKey.currentContext!).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 24),
                  child: CustomText(title: 'Choose photo'.tr(),fontSize: 20,fontWeight: FontWeight.bold,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,),
                ),
                Divider(color: AppTheme.isDarkMode()?inputBgDark:inputBg,),
                const SizedBox(height: 36,),
                InkWell(
                  onTap: onTapCamera,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  child: Container(
                    alignment: Alignment.center,
                    height: 54,
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(border: Border.all(color: greyColor),borderRadius: BorderRadius.circular(8)),
                    child: Row(mainAxisSize: MainAxisSize.min,children: [
                      const CustomSvgIcon(assetName: 'camera',width: 16,height: 16,color: greyColor,),
                      const SizedBox(width: 16,),
                      CustomText(title: 'Camera'.tr(),fontSize: 17,fontColor: greyColor,)
                    ],),
                  ),
                ),
                const SizedBox(height: 16,),
                InkWell(
                  onTap: onTapGallery,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  child: Container(
                    alignment: Alignment.center,
                    height: 54,
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(border: Border.all(color: greyColor),borderRadius: BorderRadius.circular(8)),
                    child: Row(mainAxisSize: MainAxisSize.min,children: [
                      const CustomSvgIcon(assetName: 'gallery',width: 16,height: 16,color: greyColor,),
                      const SizedBox(width: 16,),
                      CustomText(title: 'Gallery'.tr(),fontSize: 17,fontColor: greyColor,)
                    ],),
                  ),
                ),
                const SizedBox(height: 24,),


              ],),
          );
    });
  }
}