import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../../core/number_format/numberFormat.dart';
import '../../../data/models/walletModel.dart';
import '../../widgets/custom_svg/CustomSvgIcon.dart';
import '../../widgets/custom_text/custom_text.dart';

enum WalletPaymentType{
  payment,
  retrieval
}
class WalletHistoryItem extends StatelessWidget {
  final WalletDetails model;

  const WalletHistoryItem({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          color: AppTheme.isDarkMode()?dark:Colors.white,
          surfaceTintColor: Colors.transparent,
          margin: EdgeInsets.zero,
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(

            padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CustomText(title: '${model.type == WalletPaymentType.retrieval.name?'- ':''}${CustomNumberFormat.format(model.value??0.00)}',fontColor: model.type == WalletPaymentType.payment.name?mainColor:Colors.red,fontSize: 15,fontWeight: FontWeight.bold,),
                    const SizedBox(width: 4,),
                    CustomSvgIcon(assetName: 'sar',width: 14,height: 14,color: model.type == WalletPaymentType.payment.name?mainColor:Colors.red,)
                  ],
                ),
                CustomText(title: model.type == WalletPaymentType.retrieval.name? 'Withdraw'.tr():'Transfer'.tr(),fontColor: model.type == WalletPaymentType.retrieval.name?Colors.red:mainColor,fontSize: 12,),

              ],
            ),
          ),
        ),
        const SizedBox(height: 4,),
        CustomText(title: model.date??'',fontColor: AppTheme.isDarkMode()?Colors.white.withOpacity(.5):greyColor.withOpacity(.8),),
        const SizedBox(height: 8,),

      ],
    );
  }
}
