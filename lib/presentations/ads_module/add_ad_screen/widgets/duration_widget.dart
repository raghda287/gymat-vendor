import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

import '../../../../core/app_colors/app_colors.dart';
import '../../../../core/app_theme/theme.dart';
import '../../../../core/text_styles/text_styles.dart';

class DurationWidget extends StatelessWidget {
  final TextEditingController controller;
  const DurationWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: AppTheme.isDarkMode()?inputBgDark:inputBg,borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              textAlignVertical: TextAlignVertical.center,
              cursorColor: mainColor,
              style: AppTextStyles().normalText().textColorNormal(AppTheme.isDarkMode()?Colors.white:Colors.black),
              keyboardType: TextInputType.number,
              maxLength: 2,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: AppTextStyles().normalText().textColorNormal(hintColor),
                counterText: ''
              ),
            ),
          ),
          CustomText(title: 'Seconds'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,fontSize: 13,)
        ],
      ),
    );

  }
}
