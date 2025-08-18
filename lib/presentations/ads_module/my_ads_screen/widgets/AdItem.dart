import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/core/constants/constants.dart';
import 'package:gymatvendor/core/utils/date_utils.dart';
import 'package:gymatvendor/data/models/ad_model.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

import '../../../widgets/payment_details_widget/pay_icon_widget.dart';

class AdItem extends StatelessWidget {
  final AdModel model;

  const AdItem({super.key, required this.model});

  @override
  Widget build(BuildContext context) {

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Theme
          .of(context)
          .cardColor,
      surfaceTintColor: Colors.transparent,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 2,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(title:getAdStatus(model),
                  fontColor: AppTheme.isDarkMode() ? Colors.white : mainColor,),
                PayIconWidget(
                  assetName: 'mastercard',
                  bg: mastercard,
                  onTap: () {
                    //no action only for display
                  },
                ),

              ],
            ),
            const SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(title: '${'Ad Number :'.tr()} #${model.id}',
                  fontColor: greyColor,
                  fontSize: 12,),
                CustomText(
                  title: '${formatNumber(model.price ?? 0)} ${'SAR'.tr()}',
                  fontColor: greyColor,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,)

              ],
            ),
            const SizedBox(height: 8,),
            Divider(color: AppTheme.isDarkMode()
                ? greyColor.withOpacity(.05)
                : inputBg,),
            const SizedBox(height: 8,),
            Row(
              children: [
                SizedBox(
                  width: 110,
                  child: CustomText(title: 'Ad location'.tr(),
                    fontColor: AppTheme.isDarkMode() ? Colors.white : Colors
                        .black,),
                ),
                const SizedBox(width: 16,),
                Expanded(child: CustomText(title: model.address ?? '',
                  fontColor: greyColor,
                  maxLines: 2,
                  fontSize: 12,),
                )
              ],
            ),
            const SizedBox(height: 12,),
            Row(
              children: [
                SizedBox(
                  width: 110,
                  child: CustomText(title: 'Ad date and time'.tr(),
                    fontColor: AppTheme.isDarkMode() ? Colors.white : Colors
                        .black,),
                ),
                const SizedBox(width: 16,),
                Expanded(child: CustomText(title: model.created_at ?? '',
                  fontColor: greyColor,
                  maxLines: 2,
                  fontSize: 12,),
                )
              ],
            ),
            const SizedBox(height: 12,),

          ],),
      ),
    );
  }

  String getAdStatus(AdModel model){
    DateTime from = DateUtil.parseStringToDate(model.from_date!, 'yyyy-MM-dd');
    DateTime to = DateUtil.parseStringToDate(model.to_date!, 'yyyy-MM-dd');
    DateTime now = DateUtil.currentDate();
    String n = DateUtil.parseDateToString(now, 'yyyy-MM-dd');
    if(model.is_accepted==false){
      return 'In progress'.tr();
    }else if(n ==model.from_date || n == model.to_date||from.isBefore(now)||now.isBefore(to)){
      return 'Published'.tr();

    }else if(to.isBefore(now)){
      return 'Completed ad'.tr();

    }
    return '';
  }

}
