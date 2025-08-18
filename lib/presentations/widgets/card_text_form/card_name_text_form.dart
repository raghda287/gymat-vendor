import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../../core/text_styles/text_styles.dart';


class CardNameField extends StatelessWidget {
  final String? hint;
  final TextEditingController controller;
  final int? maxLength;
  final Color? bgColor;
  final double? borderRaduis;
  final ValueChanged<String>? onChange;

  const CardNameField({super.key,required this.controller,this.hint,this.bgColor, this.onChange, this.borderRaduis, this.maxLength});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: bgColor??(AppTheme.isDarkMode()?inputBgDark:inputBg),borderRadius: BorderRadius.circular(borderRaduis??16)),
      child: TextFormField(
        controller: controller,
        textAlignVertical: TextAlignVertical.center,
        cursorColor: mainColor,
        style: AppTextStyles().normalText().textColorNormal(AppTheme.isDarkMode()?Colors.white:Colors.black),
        keyboardType: TextInputType.text,
        maxLength: maxLength,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z\s]+$'))],

        onChanged: onChange,
        decoration: InputDecoration(

          border: InputBorder.none,
          hintText: hint,
          hintStyle: AppTextStyles().normalText().textColorNormal(hintColor),
          counterText: '',

        ),
      ),
    );
  }
}
