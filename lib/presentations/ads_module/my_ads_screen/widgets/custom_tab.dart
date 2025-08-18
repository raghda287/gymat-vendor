import 'package:flutter/material.dart';
import '../../../../core/app_colors/app_colors.dart';
import '../../../../core/app_theme/theme.dart';
import '../../../widgets/custom_text/custom_text.dart';

class CustomTab extends StatelessWidget {
  final String title;
  final bool selected;

  const CustomTab({super.key,required this.title,required this.selected});

  @override
  Widget build(BuildContext context) {
    return Tab(icon: Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(color: selected?AppTheme.isDarkMode()?mainColor:Colors.white:Colors.transparent,borderRadius: BorderRadius.circular(23)),
      child: CustomText(title: title,fontColor: selected?AppTheme.isDarkMode()?Colors.white:mainColor:Colors.white,),
    ),);
  }
}
