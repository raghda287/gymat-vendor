import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/presentations/widgets/custom_svg/CustomSvgIcon.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

class SocialButton extends StatelessWidget {
  final String svgIconName;
  final String? text;
  final VoidCallback onTap;

  const SocialButton(
      {super.key, required this.svgIconName, required this.onTap,this.text});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 56,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: dividerColor)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomSvgIcon(
              assetName: svgIconName,
            ),
            SizedBox(width: text!=null?16:0,),
            CustomText(title: text,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,)
          ],
        ),
      ),
    ));
  }
}
