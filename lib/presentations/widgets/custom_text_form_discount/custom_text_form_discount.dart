import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/core/constants/constants.dart';
import 'package:gymatvendor/core/text_styles/text_styles.dart';


class CustomTextFormFieldDiscount extends StatelessWidget {
  final String? hint;
  final TextEditingController controller;
  final bool readOnly;
  final Color? bgColor;
  final double? fontSize;
  final double? height;

  const CustomTextFormFieldDiscount({super.key,required this.controller,this.hint,this.readOnly = false,this.bgColor, this.fontSize, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: height??54,
      alignment: Alignment.center,
      child: TextFormField(
        readOnly:readOnly ,
        controller: controller,
        textAlignVertical: TextAlignVertical.center,
        cursorColor: mainColor,
        style: AppTextStyles().normalText(fontSize: fontSize??14).textColorNormal(AppTheme.isDarkMode()?Colors.white:Colors.black),
        keyboardType: TextInputType.number,
        maxLength: 4,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),],
        decoration: InputDecoration(
          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: mainColor)),
          border: UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.isDarkMode()?dark:inputBg)),
          hintText: hint,
          hintStyle: AppTextStyles().normalText(fontSize: fontSize??14).textColorNormal(hintColor),
          counterText: '',

        ),
      ),
    );
  }
}
