import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/core/number_format/numberFormat.dart';
import 'package:gymatvendor/presentations/growth_module/provider/provider.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../widgets/custom_svg/CustomSvgIcon.dart';

class CardEarningWidget extends StatelessWidget {
  final String day;
  final num percentage;
  final num total;
  const CardEarningWidget({super.key, required this.day, required this.percentage, required this.total});

  @override
  Widget build(BuildContext context) {
    String month = DateFormat('MMMM',context.locale.languageCode).format(DateTime.now());
    String year = '${DateTime.now().year}';
    return Card(
      surfaceTintColor: Colors.transparent,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: AspectRatio(aspectRatio: 0.75/1.23,child:
        Padding(
          padding: const EdgeInsets.only(left: 4.0,right: 4.0,top: 8.0),
          child: Column(
            children: [
              Row(children: [
                CustomText(title: day=='today'?'Today'.tr():day=='month'?month:year,fontSize: 12,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,)
              ],),
              SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularPercentIndicator(radius: 35,lineWidth: 6,percent: percentage.toDouble()/100,progressColor: percentageColor,circularStrokeCap: CircularStrokeCap.round,
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    CustomText(title: '${CustomNumberFormat.format(percentage)}%',fontSize: 13,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,fontWeight: FontWeight.bold,),
                  ],),
                  )),
              Container(
                  height: 30,
                  alignment: Alignment.center,
                  child: CustomText(title: day=='today'?'Total earning today'.tr():day=='month'?'Total earning this month'.tr():'Total earning this year'.tr(),fontSize: 11,fontColor: const Color(0xff809FB8),textAlign: TextAlign.center,)),
              const SizedBox(height: 8,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(title: CustomNumberFormat.format(total),fontSize: 12,fontWeight: FontWeight.bold,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,maxLines: 1,),
                  const SizedBox(width: 4,),
                  CustomSvgIcon(assetName: 'sar',width: 14,height: 14,color: AppTheme.isDarkMode()?Colors.white:Colors.black,)
                ],
              )

            ],),
        )
        ,),
    );
  }
}
