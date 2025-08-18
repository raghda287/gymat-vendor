import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';
import 'package:shimmer/shimmer.dart';

class CardOrderPlaceholderWidget extends StatelessWidget {
  const CardOrderPlaceholderWidget({super.key,});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 106,
      child: Card(
        elevation: 2,
        surfaceTintColor: Colors.transparent,
        color: Theme.of(context).cardColor,
        clipBehavior: Clip.antiAliasWithSaveLayer,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Stack(children: [
          SizedBox(
            width: 106,
            height:76,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 8,),

                Container(width: 50,height: 8,color: AppTheme.isDarkMode()?inputBgDark:greyColor.withOpacity(.2),),

                const SizedBox(height: 8,),

                Container(width: 24,height: 8,color: AppTheme.isDarkMode()?inputBgDark:greyColor.withOpacity(.2),),
                const SizedBox(height: 8,),

                Container(width: 50,height: 8,color: AppTheme.isDarkMode()?inputBgDark:greyColor.withOpacity(.2),),
                const SizedBox(height: 8,),

              ],
            ),
          ),
          Shimmer(
              gradient: LinearGradient(colors: [
                greyColor.withOpacity(.2),
                greyColor.withOpacity(.1)
              ]),
              child: Container(
                width: 106,
                height: 76,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: AppTheme.isDarkMode()
                        ? inputBgDark
                        : inputBg,
                    borderRadius: BorderRadius.circular(8)),
              ))
        ],),
      ),
    );
  }
}
