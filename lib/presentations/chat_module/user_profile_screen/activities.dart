import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/main.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../data/models/fitnessModel.dart';
import 'customLinearProgress.dart';

class Activities extends StatelessWidget {
  final num totalCalories;
  final List<Activity> activities;

  const Activities(
      {super.key, required this.activities, required this.totalCalories});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  title: 'Activities'.tr(),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontColor: AppTheme.isDarkMode()
                      ? Colors.white.withOpacity(.8)
                      : Colors.black,
                ),
                CustomText(
                    title: getNowDate(),
                    fontSize: 12,
                    fontColor: AppTheme.isDarkMode()
                        ? Colors.white.withOpacity(.6)
                        : greyColor.withOpacity(.8)),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            CustomText(
              title: '${'Burn calorie'.tr()} : $totalCalories ${'cal'.tr()}',
              fontColor: AppTheme.isDarkMode() ? Colors.white : Colors.black,
              fontSize: 13,
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                CustomLinearProgressIndicator(
                  persentage: calculateActivityProgressPercentage(),
                ),
                const SizedBox(
                  width: 16,
                ),
                CustomText(
                  title: '${calculateTotalActivitiesCalories()} ${'cal'.tr()}',
                  fontSize: 12,
                  fontColor: mainColor,
                  fontWeight: FontWeight.bold,
                )
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                  surfaceTintColor: Colors.transparent,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(title: activities[index].title??'',fontWeight: FontWeight.bold,fontSize: 15,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,),
                        const SizedBox(height: 8,),
                        Row(
                          children: [
                            Expanded(child: CustomText(title: '${'Total Time:'.tr()} ${getDurationTime(activities[index].minutes!=null?activities[index].minutes!.toInt():0)}',fontColor: greyColor,fontSize: 13,)),

                            CustomText(title: '${activities[index].calories??0} ${'cal'.tr()}',fontColor: mainColor,fontSize: 12,),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
              itemCount: activities.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
            )
          ],
        ),
      ),
    );
  }

  double calculateActivityProgressPercentage() {
    num percentage = 0;
    int totalActivityCalories = calculateTotalActivitiesCalories();

    if (totalActivityCalories > totalCalories) {
      percentage = 1;
    } else {
      if (totalCalories > 0) {
        percentage = totalActivityCalories / totalCalories;
      } else {
        percentage = 0;
      }
    }

    return percentage.toDouble();
  }

  int calculateTotalActivitiesCalories() {
    int total = 0;
    for (Activity activity in activities) {
      if (activity.calories != null) {
        total += activity.calories!.toInt();
      }
    }
    return total;
  }

  String getNowDate() {
    return DateFormat(
            'EEEE, dd-MMM', navigatorKey.currentContext!.locale.languageCode)
        .format(DateTime.now());
  }

  String getDurationTime(int time){
    int min = time%60;
    int hrs = time ~/60;
    String timeText ='';
    if(hrs>0){
      if(hrs==1){
        if(min==0){
          timeText ='$hrs ${'hour'.tr()}';

        }else if(min ==1){
          timeText ='$hrs ${'hour'.tr()}${' and '.tr()}$min ${'minute'.tr()}';

        }else{
          timeText ='$hrs ${'hour'.tr()}${' and '.tr()}$min ${'minutes'.tr()}';

        }


      }else{
        if(min==0){
          timeText ='$hrs ${'hours'.tr()}';

        }else if(min ==1){
          timeText ='$hrs ${'hours'.tr()}${' and' .tr()}$min ${'minute'.tr()}';

        }else{
          timeText ='$hrs ${'hours'.tr()}${' and '.tr()}$min ${'minutes'.tr()}';

        }
      }
    }else{
      if(min==0){
        timeText ='$min ${'minute'.tr()}';

      }else if(min ==1){
        timeText ='$min ${'minute'.tr()}';

      }else{
        timeText ='$min ${'minutes'.tr()}';

      }
    }

    return timeText;
  }

}
