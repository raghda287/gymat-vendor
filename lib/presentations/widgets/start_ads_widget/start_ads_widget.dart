import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/constants/constants.dart';
import 'package:gymatvendor/core/dimens/dimens.dart';
import 'package:gymatvendor/core/navigator/navigator.dart';
import 'package:gymatvendor/presentations/ads_module/add_ad_screen/add_ad_screen.dart';
import 'package:gymatvendor/presentations/widgets/custom_button/custom_button.dart';
import 'package:gymatvendor/presentations/widgets/custom_rounded_image/custom_rounded_image.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

import '../../../injection.dart';
import '../../profile_module/provider/profile_provider.dart';
import '../dialogs/scaffold_messanger.dart';

class StartAdsWidget extends StatelessWidget {
  const StartAdsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    String lang = context.locale.languageCode;
    double height = (Dimens.width*9/16)+12;
    return Container(
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 4,vertical: 4),
      child: Stack(
        children: [
        AspectRatio(aspectRatio: 16/9,
        child: CustomRoundedImage(width: Dimens.width, height: Dimens.height*.19,elevation: 1,radius: 12,url: 'assets/images/icons/start_ads.png',)),
        Positioned(
            left: 24,
            right: 24,
            bottom: 0,
            child: CustomButton(
              height: 48,
              title: 'Advertise with gymat now'.tr(), onTap: (){

              ProfileProvider providerProfile = getIt();

              if(providerProfile.getUserModel() != null &&!providerProfile.getUserModel()!.providerModel!.is_accepted){
                CustomScaffoldMessanger.showToast(title: 'Please wait, your information is being reviewed.'.tr());
              }else{
                NavigatorHandler.push(const AddAdScreen());
              }

            },fontWeight: FontWeight.bold,radius: 24,fontSize: 17,)),
         Positioned(
           top:height*.2,
           left: 0,
           right: 0,
           child: Column(
             mainAxisSize: MainAxisSize.min,
             children: [
              CustomText(title: lang=='ar'?'جمات':'RUN',fontSize: 32,fontColor: Colors.white,fontWeight: FontWeight.bold,),
              CustomText(title: lang=='ar'?'للدعاية و الاعلان':'G  y  m  a  t',fontSize: 14,fontColor: Colors.white,fontWeight: FontWeight.bold,),
              if(lang=='en')const CustomText(title: 'Advertising',fontSize: 14,fontColor: Colors.white,fontWeight: FontWeight.bold,),

            ],
                   ),
         )
      ],),
    );
  }
}
