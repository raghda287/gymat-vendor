import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/navigator/navigator.dart';
import 'package:gymatvendor/core/text_styles/text_styles.dart';
import 'package:gymatvendor/presentations/auth_module/registration_info_screen/registration_info_screen.dart';
import 'package:gymatvendor/presentations/auth_module/registration_step2_screen/registration_step2_screen.dart';
import 'package:gymatvendor/presentations/profile_module/account_info_screen.dart';
import 'package:gymatvendor/presentations/profile_module/profile_screen.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

import '../../../profile_module/complete_account_info_screen.dart';

class UnAuthWidget extends StatelessWidget {
  const UnAuthWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 12,right: 12,top: 8,bottom: 8),
      child: Text.rich(TextSpan(text: 'Un authorized account, please complete your account information'.tr(),style: AppTextStyles().normalText().textColorNormal(Colors.white),children: [
        const TextSpan(text: ' '),
        TextSpan(text: 'Complete account info'.tr(),style: const TextStyle(fontSize: 12,color: mainColor,fontFamily: 'font_regular',decoration: TextDecoration.underline,decorationColor: mainColor),recognizer: TapGestureRecognizer()..onTap=(){
          NavigatorHandler.push(const RegistrationStep2Screen());
        })
      ]),)
    );
  }
}

//CustomText(title: ,fontColor: Colors.white,),