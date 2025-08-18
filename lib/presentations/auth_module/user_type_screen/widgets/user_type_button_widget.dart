import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

class UserTypeButtonWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool selected;
  const UserTypeButtonWidget({super.key,required this.title,required this.onTap, required this.selected});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.isDarkMode()?greyColor.withOpacity(0.4):greyColor.withOpacity(0.5))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Checkbox(
                checkColor: Colors.white,
                activeColor: mainColor,
                side: BorderSide(color: AppTheme.isDarkMode()?Colors.white:greyColor),
                value: selected, onChanged: (value){
                  onTap();
            }),
            CustomText(title: title,fontColor: AppTheme.isDarkMode()?Colors.white:mainColor,fontSize: 20,fontWeight: FontWeight.bold,),
            const SizedBox(width: 36,)
          ],
        ),
      ),
    );
  }
}
