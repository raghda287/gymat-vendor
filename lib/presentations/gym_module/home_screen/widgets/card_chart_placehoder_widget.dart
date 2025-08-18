import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shimmer/shimmer.dart';

class CardChartPlaceholderWidget extends StatelessWidget {
  const CardChartPlaceholderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12,vertical: 4),
      elevation: 2,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: Theme.of(context).cardColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child:Stack(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 50,height: 8,color: AppTheme.isDarkMode()?inputBgDark:greyColor.withOpacity(.2),),
                    const SizedBox(height: 8,),
                    Container(width: 40,height: 8,color: AppTheme.isDarkMode()?inputBgDark:greyColor.withOpacity(.2),),
                  ],
                ),
              ),
              CircularPercentIndicator(radius: 35,lineWidth: 6,backgroundColor: greyColor.withOpacity(.2),progressColor: percentageColor,percent: 0,circularStrokeCap: CircularStrokeCap.round,),

            ],
          ),
        ),
        Shimmer(
            gradient: LinearGradient(colors: [
              greyColor.withOpacity(.2),
              greyColor.withOpacity(.1)
            ]),
            child: Container(
              decoration: BoxDecoration(
                  color: AppTheme.isDarkMode()
                      ? inputBgDark
                      : inputBg,
                  borderRadius: BorderRadius.circular(8)),

              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(width: 50,height: 8,color: AppTheme.isDarkMode()?inputBgDark:greyColor.withOpacity(.2),),
                          const SizedBox(height: 8,),
                          Container(width: 40,height: 8,color: AppTheme.isDarkMode()?inputBgDark:greyColor.withOpacity(.2),),
                        ],
                      ),
                    ),
                    CircularPercentIndicator(radius: 35,lineWidth: 6,backgroundColor: greyColor.withOpacity(.2),progressColor: percentageColor,percent: 0,circularStrokeCap: CircularStrokeCap.round,),

                  ],
                ),
              ),
            ))

      ],),
    );
  }
}
