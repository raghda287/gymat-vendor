import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/presentations/widgets/custom_svg/CustomSvgIcon.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

class NoQuestionsWidget extends StatelessWidget {
  const NoQuestionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 106,
            height: 106,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: mainColor,borderRadius: BorderRadius.circular(53)),
            child: const CustomSvgIcon(assetName: 'ask_question',width: 36,height: 36,),
          ),
          const SizedBox(height: 8,),
          CustomText(title: 'Never asked yet! , Ask now'.tr(),fontSize: 16,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,)
        ],),
    );
  }
}
