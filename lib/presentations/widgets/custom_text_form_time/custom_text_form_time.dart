import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/core/constants/constants.dart';
import 'package:gymatvendor/core/text_styles/text_styles.dart';

import 'time_formater.dart';

class CustomTextFormFieldTime extends StatelessWidget {
  final String? hint;
  final TextEditingController controller;
  final Color? bgColor;
  final Color? borderColor;
  final double? fontSize;
  final double? height;

  const CustomTextFormFieldTime({super.key,required this.controller,this.bgColor, this.borderColor, this.fontSize, this.height, this.hint});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: height??54,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: bgColor??(AppTheme.isDarkMode()?inputBgDark:inputBg),borderRadius: BorderRadius.circular(16),border: Border.all(color: borderColor??Colors.transparent)),
      child: TextFormField(
        controller: controller,
        textAlignVertical: TextAlignVertical.center,
        cursorColor: mainColor,
        style: AppTextStyles().normalText(fontSize: fontSize??14).textColorNormal(AppTheme.isDarkMode()?Colors.white:Colors.black),
        keyboardType: TextInputType.number,
        inputFormatters: [LengthLimitingTextInputFormatter(5),TimeTextFormatter(),FilteringTextInputFormatter.allow(RegExp("[0-9:]"))],
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '00 : 00',
          hintStyle: AppTextStyles().normalText(fontSize: fontSize??14).textColorNormal(hintColor),


        ),
      ),
    );
  }
}
