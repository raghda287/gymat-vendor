import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shimmer/shimmer.dart';



class CardEarningPlaceholderWidget extends StatelessWidget {
  const CardEarningPlaceholderWidget({super.key,});

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.transparent,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: AspectRatio(aspectRatio: 0.75/1.23,child:
        Stack(children: [
          Padding(
            padding: const EdgeInsets.only(left: 4.0,right: 4.0,top: 8.0),
            child: Column(
              children: [
                Row(children: [
                  Container(width: 60,height: 8,color: AppTheme.isDarkMode()?inputBgDark:greyColor.withOpacity(.2),)
                ],),
                const SizedBox(height: 12,),
                SizedBox(
                    width: 80,
                    height: 80,
                    child: CircularPercentIndicator(radius: 35,lineWidth: 6,percent: 0,backgroundColor: greyColor.withOpacity(.2),progressColor: percentageColor,circularStrokeCap: CircularStrokeCap.round,
                    )),

                const SizedBox(height: 12,),

                Container(width: 90,height: 8,color: AppTheme.isDarkMode()?inputBgDark:greyColor.withOpacity(.2),),
                const SizedBox(height: 24,),
                Container(width: 40,height: 8,color: AppTheme.isDarkMode()?inputBgDark:greyColor.withOpacity(.2),)

              ],),
          ),
          Shimmer(
              gradient: LinearGradient(colors: [
                greyColor.withOpacity(.2),
                greyColor.withOpacity(.1)
              ]),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: AppTheme.isDarkMode()
                        ? inputBgDark
                        : inputBg,
                    borderRadius: BorderRadius.circular(8)),
              ))

        ],)
        ,),
    );
  }
}
