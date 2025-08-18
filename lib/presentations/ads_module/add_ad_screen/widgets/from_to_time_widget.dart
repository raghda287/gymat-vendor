import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

class FromTomTimeWidget extends StatelessWidget {
  final String? title;
  final VoidCallback onTap;
  const FromTomTimeWidget({super.key, this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        height: 54,
        decoration: BoxDecoration(color: AppTheme.isDarkMode()?inputBgDark:inputBg,borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(title: title??'',fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,),
            Icon(Icons.arrow_forward_ios_rounded,size: 16,color: AppTheme.isDarkMode()?Colors.white:greyColor,)
          ],
        ),
      ),
    );
  }
}
