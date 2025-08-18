import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../../core/constants/constants.dart';
import '../../../core/text_styles/text_styles.dart';
import 'card_formatter.dart';

class CardNumberWidget extends StatelessWidget {
  final String? hint;
  final TextEditingController controller;
  final Color? bgColor;
  final Color? borderColor;
  final double? fontSize;
  final double? height;
  final ValueChanged<String> onChange;

  const CardNumberWidget({super.key, this.hint, required this.controller, this.bgColor, this.borderColor, this.fontSize, this.height, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: height??54,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: bgColor ?? (AppTheme.isDarkMode()?inputBgDark:inputBg),borderRadius: BorderRadius.circular(16),border: Border.all(color: borderColor??Colors.transparent)),
      child: TextFormField(
        controller: controller,
        textAlignVertical: TextAlignVertical.center,
        cursorColor: mainColor,
        style: AppTextStyles().normalText(fontSize: fontSize??14).textColorNormal(AppTheme.isDarkMode()?Colors.white:Colors.black),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly,LengthLimitingTextInputFormatter(16),CardNumberInputFormatter()],
        onChanged: onChange,

        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: AppTextStyles().normalText(fontSize: fontSize??14).textColorNormal(hintColor),
          counterText: '',

        ),
      ),
    );
  }
}
