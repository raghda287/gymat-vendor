import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../widgets/custom_svg/CustomSvgIcon.dart';
import '../../widgets/custom_text/custom_text.dart';


class VisaTypeCheckBox extends StatelessWidget {
  final bool isChecked;
  final VoidCallback onChecked;
  final String title;

  const VisaTypeCheckBox({super.key, required this.isChecked, required this.onChecked,required this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap:onChecked,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(title: title,fontColor: isChecked?mainColor:AppTheme.isDarkMode()?Colors.white:Colors.black,fontSize: 15,),
          if(isChecked)const CustomSvgIcon(assetName: 'checked',color: mainColor,)
        ],
      ),
    );
  }
}
