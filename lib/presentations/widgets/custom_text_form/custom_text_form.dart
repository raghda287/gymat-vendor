import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/core/constants/constants.dart';
import 'package:gymatvendor/core/text_styles/text_styles.dart';

import '../custom_text_form_time/time_formater.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hint;
  final TextInputType? textInputType;
  final TextEditingController controller;
  final Widget? prefix;
  final Widget? suffix;
  final int? maxLength;
  final bool readOnly;
  final Color? bgColor;
  final double minPrefixSuffixWidth;
  final Color? borderColor;
  final double? fontSize;
  final double? height;
  final double? borderRaduis;
  final FocusNode? focusNode;
  final ValueChanged<String>? onValueChange;

  const CustomTextFormField({super.key,required this.controller,this.hint,this.prefix,this.suffix,this.textInputType = TextInputType.text,this.maxLength,this.readOnly = false,this.bgColor,this.minPrefixSuffixWidth=45, this.borderColor, this.fontSize, this.height, this.onValueChange, this.borderRaduis, this.focusNode});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: height??54,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: bgColor??(AppTheme.isDarkMode()?inputBgDark:inputBg),borderRadius: BorderRadius.circular(borderRaduis??16),border: Border.all(color: borderColor??Colors.transparent)),
      child: TextFormField(
        focusNode: focusNode,
        readOnly:readOnly ,
        controller: controller,
        textAlignVertical: TextAlignVertical.center,
        onChanged: onValueChange,
        cursorColor: mainColor,
        style: AppTextStyles().normalText(fontSize: fontSize??14).textColorNormal(AppTheme.isDarkMode()?Colors.white:Colors.black),
        keyboardType: textInputType,
        maxLength: textInputType==TextInputType.phone?10:maxLength,
        inputFormatters: textInputType==TextInputType.phone||textInputType==const TextInputType.numberWithOptions(signed: false,decimal: false)?[FilteringTextInputFormatter.digitsOnly]:textInputType==const TextInputType.numberWithOptions(signed: false,decimal: true)?[FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),]:[],
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: AppTextStyles().normalText(fontSize: fontSize??14).textColorNormal(hintColor),
          suffixIcon: suffix,
          prefixIcon: prefix,
          suffixIconConstraints:   BoxConstraints(maxHeight: 24,maxWidth:minPrefixSuffixWidth,minWidth: minPrefixSuffixWidth),
          prefixIconConstraints:  BoxConstraints(maxHeight: 24,maxWidth:minPrefixSuffixWidth,minWidth: minPrefixSuffixWidth),
          counterText: '',

        ),
      ),
    );
  }
}
