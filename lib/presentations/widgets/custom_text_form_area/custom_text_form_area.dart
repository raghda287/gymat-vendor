import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/core/text_styles/text_styles.dart';

class CustomTextFormFieldArea extends StatelessWidget {
  final String? hint;
  final TextEditingController controller;
  final Color? bgColor;
  final double? height;

  const CustomTextFormFieldArea({super.key,required this.controller,this.hint,this.bgColor, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: height??100,
      decoration: BoxDecoration(color: bgColor??(AppTheme.isDarkMode()?inputBgDark:inputBg),borderRadius: BorderRadius.circular(16)),
      child: TextFormField(
        controller: controller,
        cursorColor: mainColor,
        maxLines: null,
        textAlignVertical: TextAlignVertical.top,
        style: AppTextStyles().normalText().textColorNormal(AppTheme.isDarkMode()?Colors.white:Colors.black),
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: AppTextStyles().normalText().textColorNormal(hintColor),


        ),
      ),
    );
  }
}
