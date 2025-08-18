import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

class CardStatisticsWidget extends StatelessWidget {
  final String title;
  final num count;
  final VoidCallback onTap;
  const CardStatisticsWidget({super.key, required this.title, required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(aspectRatio: 1/0.7,child:
      Card(
        color: Theme.of(context).cardColor,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(title: title,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,fontSize: 13,),
              const SizedBox(height: 4,),
              CustomText(title: count.toString(),fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,fontSize: 12,fontWeight: FontWeight.bold,),

            ],
          ),
        ),
      )
      ,);
  }
}
