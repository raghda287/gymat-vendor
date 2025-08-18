import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../data/models/fitnessModel.dart';
import '../../../main.dart';
import 'customLinearProgress.dart';

class Nutritions extends StatelessWidget {
  final num totalCalories;
  final List<Nutrition> nutritions;
  const Nutritions({super.key, required this.nutritions, required this.totalCalories});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(title: 'Nutritions'.tr(),fontWeight: FontWeight.bold,fontSize: 18,fontColor: AppTheme.isDarkMode()?Colors.white.withOpacity(.8):Colors.black,),
              CustomText(title: getNowDate(),fontSize: 12,fontColor: AppTheme.isDarkMode()?Colors.white.withOpacity(.6):greyColor.withOpacity(.8)),

            ],
          ),
          const SizedBox(height: 12,),
          CustomText(
            title:
            '${'Daily calorie'.tr()} : $totalCalories ${'cal'.tr()}',
            fontColor: AppTheme.isDarkMode()
                ? Colors.white
                : Colors.black,
            fontSize: 13,
          ),
          const SizedBox(height: 8,),

          Row(
            children: [
              CustomLinearProgressIndicator(
                persentage: calculateNutritionProgressPercentage(),
              ),
              const SizedBox(width: 16,),
              CustomText(
                title:
                '${calculateTotalMealCalories()} ${'cal'.tr()}',
                fontSize: 12,
                fontColor: mainColor,
                fontWeight: FontWeight.bold,
              )

            ],
          ),

          const SizedBox(
            height: 24,
          ),

          ListView.builder(itemBuilder: (context,index){

            return Card(
              elevation: 0.5,
              surfaceTintColor: Colors.transparent,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              color: AppTheme.isDarkMode() ? cardDark : inputBg,
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: CustomText(
                          title: nutritions[index].title ?? '',
                          fontColor:
                          AppTheme.isDarkMode() ? Colors.white : Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(
                      width: 16,
                    ),
                    CustomText(
                      title: '${nutritions[index].calories ?? 0} ${'cal'.tr()}',
                      fontColor: greyColor,
                      fontSize: 12,
                    )
                  ],
                ),
              ),
            );

          },itemCount: nutritions.length,shrinkWrap: true,physics: const NeverScrollableScrollPhysics(),)
        ],
      ),
    );
  }


  double calculateNutritionProgressPercentage() {
    num percentage  = 0;
    int totalNutritionCalories = calculateTotalMealCalories();

    if(totalNutritionCalories>totalCalories){
      percentage = 1;
    }else{
      if(totalCalories>0){
        percentage = totalNutritionCalories/totalCalories;

      }else{
        percentage = 0;

      }
    }
    return percentage.toDouble();
  }


  int calculateTotalMealCalories() {
    int total = 0;
    for(Nutrition nutrition in nutritions){
      if(nutrition.calories!=null){
        total += nutrition.calories!.toInt();

      }
    }
    return total;
  }

  String getNowDate(){
    return DateFormat('EEEE, dd-MMM',navigatorKey.currentContext!.locale.languageCode).format(DateTime.now());
  }
}
