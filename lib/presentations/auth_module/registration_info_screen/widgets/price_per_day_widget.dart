import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/app_colors/app_colors.dart';
import '../../../../core/app_theme/theme.dart';
import '../../../widgets/custom_text/custom_text.dart';
import '../../../widgets/custom_text_form/custom_text_form.dart';

class PricePerDayWidget extends StatelessWidget {
  final TextEditingController controller;
  const PricePerDayWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 12,
        ),
        CustomText(
          title: 'Subscribtion per day'.tr(),
          fontSize: 14,
          fontColor: AppTheme.isDarkMode() ? Colors.white : mainColor,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(
          height: 12,
        ),
        CustomTextFormField(controller: controller,textInputType: const TextInputType.numberWithOptions(signed: false,decimal: true),maxLength: 6,minPrefixSuffixWidth: 32,suffix: CustomText(title: 'SAR'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,fontWeight: FontWeight.bold,fontSize: 17,),),
      ],
    );
  }
}
