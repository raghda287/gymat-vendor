import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/presentations/widgets/custom_svg/CustomSvgIcon.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

class CardScanQrWidget extends StatelessWidget {
  final VoidCallback onTap;
  const CardScanQrWidget({super.key, required this.onTap,});

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
          padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 8),
          child: SizedBox(
            width: 75,
            height: 60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 CustomSvgIcon(assetName: 'qr_scanner',color: AppTheme.isDarkMode()?Colors.white:Colors.black,),
                const SizedBox(height: 8,),
                
                CustomText(
                  title: 'Scan Qr'.tr(),
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
