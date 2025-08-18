import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

class CardOrderWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String orderCount;
  final String title;
  const CardOrderWidget({super.key, required this.onTap, required this.orderCount, required this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      onTap: onTap,
      child:Card(
        elevation: 2,
        surfaceTintColor: Colors.transparent,
        color: Theme.of(context).cardColor,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 90,
            height:60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  title: title,
                  fontSize: 11,
                  fontColor: AppTheme.isDarkMode() ? Colors.white : mainColor,
                ),
                CustomText(
                  title: orderCount,
                  fontSize: 16,
                  fontColor: AppTheme.isDarkMode() ? mainColor : Colors.black,
                ),
                CustomText(
                  title: 'Booking'.tr(),
                  fontSize: 11,
                  fontColor: greyColor,
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}
