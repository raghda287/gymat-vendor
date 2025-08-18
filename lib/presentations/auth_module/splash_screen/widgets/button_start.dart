import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/constants/constants.dart';

import '../../../../core/app_theme/theme.dart';
import '../../../../core/dimens/dimens.dart';
import '../../../widgets/custom_text/custom_text.dart';


class ButtonStart extends StatelessWidget {
  final VoidCallback onTap;
  const ButtonStart({super.key,required this.onTap});

  @override
  Widget build(BuildContext context) {
     return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: Dimens.width,
        height: 56.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
            gradient:  LinearGradient(colors: AppTheme.isDarkMode()?[mainColor,mainColor]: [startColor,mainColor],begin: Alignment.centerRight,end: Alignment.centerLeft)
        ),
        child: CustomText(
          title: 'Get started as'.tr().toUpperCase(),
          fontSize: 17,
          fontColor: white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
