import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/presentations/widgets/custom_bordered_container/custom_bordered_container.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

class ServiceTimeItem extends StatelessWidget {
  final String title;
  final bool selected;
  const ServiceTimeItem({super.key, required this.title, required this.selected});
  @override
  Widget build(BuildContext context) {
    return CustomBorderedContainer(
        borderColor: Colors.transparent,
        bg: selected?mainColor:AppTheme.isDarkMode()?inputBgDark:inputBg,
        borderRadius: 12,
        child: Center(child: CustomText(title: title,fontColor: selected?Colors.white:(AppTheme.isDarkMode()?greyColor:greyColor.withOpacity(.5)),),));
  }
}
