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

class UnAcceptedWidget extends StatelessWidget {
  const UnAcceptedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 12,right: 12,top: 8,bottom: 8),
      child: Text.rich(TextSpan(text: 'Your request has been successfully submitted. Please wait while your information is being reviewed by the administration.'.tr(),style: AppTextStyles().normalText().textColorNormal(Colors.white)),)
    );
  }
}

//CustomText(title: ,fontColor: Colors.white,),