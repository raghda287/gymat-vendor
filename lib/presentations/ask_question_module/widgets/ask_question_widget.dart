import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

class AskQuestionWidget extends StatelessWidget {
  final VoidCallback onTap;
  const AskQuestionWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        width: 180,
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: mainColor,borderRadius: BorderRadius.circular(24)),
        child: CustomText(title: '+ ${'Ask a question'.tr()}',fontColor: Colors.white,),
      ),
    );
  }
}
