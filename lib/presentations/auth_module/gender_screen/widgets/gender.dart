import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/presentations/widgets/custom_svg/CustomSvgIcon.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

class Gender extends StatelessWidget {
  final String iconName;
  final String title;
  final bool selected;
  const Gender({super.key,required this.iconName,required this.title,required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 124,
      height: 124,
      decoration: BoxDecoration(color: selected?mainColor:AppTheme.isDarkMode()?dark:genderColor,borderRadius: BorderRadius.circular(62)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        CustomSvgIcon(assetName: iconName,color: selected?white:mainColor,),
        CustomText(title: title,fontColor: selected?white:mainColor,fontSize: 16,fontWeight: FontWeight.bold,)
      ],),
    );
  }
}
