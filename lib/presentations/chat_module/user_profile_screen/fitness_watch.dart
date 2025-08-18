import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../data/models/fitnessModel.dart';
import '../../../main.dart';
import 'customLinearProgress.dart';

class FitnessWatch extends StatelessWidget {
  final FitnessModel? model;
  const FitnessWatch({super.key, this.model});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8,),
          Row(
            children: [
              Expanded(
                  child: Column(
                    children: [
                      CircularPercentIndicator(
                        radius: 42,
                        lineWidth: 6,
                        backgroundColor:
                        greyColor.withOpacity(.3),
                        progressColor: mainColor,
                        percent: getPercentageCalories(),
                        circularStrokeCap:
                        CircularStrokeCap.round,
                        center: CustomText(
                          title:
                          '${model?.goals?.calories??'0'} \n${'cal'.tr()}',
                          textAlign: TextAlign.center,
                          fontColor: AppTheme.isDarkMode()
                              ? Colors.white
                              : Colors.black,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      CustomText(
                        title: 'Calories Burn'.tr(),
                        fontColor: AppTheme.isDarkMode()
                            ? Colors.white
                            : Colors.black,
                        fontSize: 14,
                      ),
                    ],
                  )),
              Expanded(
                  child: Column(
                    children: [
                      CircularPercentIndicator(
                        radius: 42,
                        lineWidth: 6,
                        backgroundColor:
                        greyColor.withOpacity(.3),
                        progressColor: mainColor,
                        percent: getPercentageSleep(),
                        circularStrokeCap:
                        CircularStrokeCap.round,
                        center: CustomText(
                          title:
                          '${model?.goals?.water??'0'} \n${'hrs'.tr()}',
                          textAlign: TextAlign.center,
                          fontColor: AppTheme.isDarkMode()
                              ? Colors.white
                              : Colors.black,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      CustomText(
                        title: 'Sleep'.tr(),
                        fontColor: AppTheme.isDarkMode()
                            ? Colors.white
                            : Colors.black,
                        fontSize: 14,
                      ),
                    ],
                  )),
              Expanded(
                  child: Column(
                    children: [
                      CircularPercentIndicator(
                        radius: 42,
                        lineWidth: 6,
                        backgroundColor:
                        greyColor.withOpacity(.3),
                        progressColor: mainColor,
                        percent: getPercentageWater(),
                        circularStrokeCap:
                        CircularStrokeCap.round,
                        center: CustomText(
                          title:
                          '${model?.goals?.sleep_hours??'0'} \n${'liter'.tr()}',
                          textAlign: TextAlign.center,
                          fontColor: AppTheme.isDarkMode()
                              ? Colors.white
                              : Colors.black,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      CustomText(
                        title: 'Water'.tr(),
                        fontColor: AppTheme.isDarkMode()
                            ? Colors.white
                            : Colors.black,
                        fontSize: 14,
                      ),
                    ],
                  )),
            ],
          ),
          const SizedBox(height: 12,),
        ],
      ),
    );
  }

  double getPercentageCalories(){

    if(model!=null&&model!.goals!=null&&model!.goals!.calories!=null&&model!.goals!.calories!=0){
      num totalCalories = model!.goals!.calories??0;
      num calories = model!.goals!.achieved_calories??0;
      return calories/totalCalories;
    }

    return 0;
  }

  double getPercentageWater(){

    if(model!=null&&model!.goals!=null&&model!.goals!.water!=null&&model!.goals!.water!=0){
      num totalWater = model!.goals!.water??0;
      num water = model!.goals!.achieved_water??0;
      return water/totalWater;
    }

    return 0;
  }

  double getPercentageSleep(){

    if(model!=null&&model!.goals!=null&&model!.goals!.sleep_hours!=null&&model!.goals!.sleep_hours!=0){
      num totalSleepHours = model!.goals!.sleep_hours??0;
      num sleepHours = model!.goals!.achieved_sleep_hours??0;
      return sleepHours/totalSleepHours;
    }

    return 0;
  }

}
