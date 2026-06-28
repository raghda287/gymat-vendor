import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/CoursesScreen/CoursesScreen.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../../injection.dart';
import '../../profile_module/provider/profile_provider.dart';
import '../../widgets/custom_svg/CustomSvgIcon.dart';
import '../../widgets/custom_text/custom_text.dart';
import '../../widgets/loading_indicator/loading_indicator.dart';
import '../home_screen/widgets/workout_item_widget.dart';
import '../provider/coach_home_provider.dart';

class CoursesWidget extends StatelessWidget{
  const CoursesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          horizontalTitleGap: 4,
          leading: CustomSvgIcon(assetName: 'course_icon',width: 16,height: 16,color: AppTheme.isDarkMode()?Colors.white:mainColor,),
          title: CustomText(title: 'add your courses'.tr(),fontWeight: FontWeight.bold,fontColor: AppTheme.isDarkMode()?Colors.white:mainColor,fontSize: 14,),
          subtitle: CustomText(title: 'add your courses,share your passion'.tr(),fontColor: greyColor,fontSize: 12,),
          trailing: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: (){
                // ProfileProvider provider = getIt();

                // if(provider.getUserModel() != null &&!provider.getUserModel()!.providerModel!.is_accepted){
                //   CustomScaffoldMessanger.showToast(title: 'Please wait, your information is being reviewed.   '.tr());
                // }else{
                //   NavigatorHandler.push(const WorkoutScreen());

                //}

                Navigator.push(context, MaterialPageRoute(builder: (_){return const CoursesScreen();}));
              },
              child: CustomText(title: 'See All'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:mainColor,fontSize: 14,)),
        ),
        const SizedBox(height: 12,),
        Consumer<CoachHomeProvider>(
            builder: (context,provider,_) {
              return provider.isLoadingWorkouts?const LoadingIndicator(width: 24,stroke: 3,):SizedBox(
                height: !provider.isLoadingWorkouts&&provider.workouts.isNotEmpty? 160:10,
                child: provider.isLoadingWorkouts?const LoadingIndicator():ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    shrinkWrap: true,
                    itemCount: provider.workouts.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context,index){
                      return InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: (){
                            ProfileProvider providerProfile = getIt();

                            // if(providerProfile.getUserModel() != null &&!providerProfile.getUserModel()!.providerModel!.is_accepted){
                            //   CustomScaffoldMessanger.showToast(title: 'Please wait, your information is being reviewed.'.tr());
                            // }else{
                            //   NavigatorHandler.push(AddWorkoutScreen(workoutModel:provider.workouts[index] ,fromPage: 'home',));
                            //
                            // }
                          },
                          child: WorkoutItemWidget(workoutModel: provider.workouts[index],));
                    }),
              );
            }
        ),
        const SizedBox(height: 12,),

      ],
    );
  }

}