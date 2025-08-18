import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/app_colors/app_colors.dart';

class CardStatisticsPlaceholderWidget extends StatelessWidget {
  const CardStatisticsPlaceholderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(aspectRatio: 1/0.7,child:
      Card(
        color: Theme.of(context).cardColor,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Stack(
          alignment: Alignment.center,
          children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 50,height: 8,color: AppTheme.isDarkMode()?inputBgDark:greyColor.withOpacity(.2),),
                const SizedBox(height: 12,),
                Container(width: 30,height: 8,color: AppTheme.isDarkMode()?inputBgDark:greyColor.withOpacity(.2),),

              ],
            ),
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

        ],),
      )
      ,);
  }
}
