import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';

import '../../../core/constants/constants.dart';
import '../../../core/dimens/dimens.dart';
import '../custom_text/custom_text.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final double fontSize;
  final Color fontColor;
  final FontWeight? fontWeight;

  final Color bg;
  final VoidCallback onTap;
  final double? width;
  final double? height;
  final double? radius;
  final double? borderWidth;
  final Color? borderColor;

  const CustomButton(
      {super.key,
      required this.title,
      this.fontSize = 14,
      this.fontWeight = FontWeight.normal,
      this.fontColor = white,
      this.bg = mainColor,
      required this.onTap,
      this.width,
      this.radius, this.height, this.borderWidth, this.borderColor
      });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: width ?? Dimens.width,
        height: height??56.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius??12),
          color: bg,
          border: Border.all(width: borderWidth??0,color: borderColor??Colors.transparent)
        ),
        child: CustomText(
          title: title,
          fontSize: fontSize,
          fontColor: fontColor,
          fontWeight: fontWeight??FontWeight.normal,
        ),
      ),
    );
  }
}
