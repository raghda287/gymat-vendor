import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../widgets/custom_svg/CustomSvgIcon.dart';

class CardChartWidget extends StatelessWidget {
  final String earningPrice;
  final num percentage;
  const CardChartWidget({super.key, required this.earningPrice, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12,vertical: 4),
      elevation: 2,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: Theme.of(context).cardColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child:Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(title: 'Total earning today'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:mainColor,fontSize: 14,),
                  const SizedBox(height: 8,),
                  Row(
                    children: [
                      CustomText(title: earningPrice,fontColor: AppTheme.isDarkMode()?mainColor:Colors.black,fontSize: 14,fontWeight: FontWeight.bold,),
                      const SizedBox(width: 4,),
                      CustomSvgIcon(assetName: 'sar',width: 14,height: 14,color: AppTheme.isDarkMode()?mainColor:Colors.black,),
                    ],
                  ),

                ],
              ),
            ),
            CircularPercentIndicator(radius: 35,lineWidth: 6,progressColor: percentageColor,percent: percentage/100,circularStrokeCap: CircularStrokeCap.round,center: CustomText(title:'$percentage%',fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,fontSize: 12,),),

          ],
        ),
      ),
    );
  }
}
