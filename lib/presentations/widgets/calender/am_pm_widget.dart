import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

class AmPmWidget extends StatelessWidget {
  final bool selected;
  final String title;
  const AmPmWidget({super.key,required this.title,required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      constraints: const BoxConstraints(maxWidth: 42),
      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),color:selected?mainColor:Colors.transparent,border: Border.all(color: AppTheme.isDarkMode()?selected?Colors.transparent:Colors.white.withOpacity(.3):selected?Colors.transparent:greyColor)),
      child: CustomText(title: title,fontColor: AppTheme.isDarkMode()?Colors.white:selected?Colors.white:Colors.black,),
    );
  }
}
