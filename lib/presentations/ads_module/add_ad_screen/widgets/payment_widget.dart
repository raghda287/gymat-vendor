import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/presentations/widgets/custom_svg/CustomSvgIcon.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

class PaymentWidget extends StatelessWidget {
  final String type;
  final String? walletPrice;
  final VoidCallback onTap;
  const PaymentWidget({super.key, required this.type, this.walletPrice, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: onTap,
      leading: Container(
        width: 36,
        height: 24,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        alignment: Alignment.center,
        decoration: BoxDecoration(color: AppTheme.isDarkMode()?Colors.black.withOpacity(.2):greyColor.withOpacity(.2),borderRadius: BorderRadius.circular(4)),
        child: CustomSvgIcon(assetName: type=='wallet'?'wallet2':type=='card'?'card':'apple_pay',color: AppTheme.isDarkMode()?Colors.white:Colors.black,width: 12,height: 12,),
      ),
      title: CustomText(title: type=='wallet'?'Wallet'.tr():type=='card'?'Card'.tr():"Apple pay".tr(),fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,),

      trailing: CustomText(title:walletPrice!=null?'$walletPrice ${'SAR'.tr()}':'',fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,),
    );
  }
}
