import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/core/dimens/dimens.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

class CreateNewAdWidget extends StatelessWidget {
  final VoidCallback onTap;
  const CreateNewAdWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        height:42,
        width: 250,
        alignment: Alignment.center,
        decoration: BoxDecoration(color:mainColor,borderRadius: BorderRadius.circular(21)),
        child: CustomText(title: 'Add a new ad'.tr(),fontColor:Colors.white,),
      ),
    );
  }
}
