import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/navigator/navigator.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/home_screen/widgets/live_session_item_widget.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/home_screen/widgets/workout_item_widget.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/livesession_screen/addLiveSessionScreen.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/livesession_screen/liveSessionScreen.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/provider/livesession_provider.dart';
import 'package:gymatvendor/presentations/widgets/loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';

import '../../../../core/app_colors/app_colors.dart';
import '../../../../core/app_theme/theme.dart';
import '../../../../injection.dart';
import '../../../profile_module/provider/profile_provider.dart';
import '../../../widgets/custom_svg/CustomSvgIcon.dart';
import '../../../widgets/custom_text/custom_text.dart';
import '../../../widgets/dialogs/scaffold_messanger.dart';

class LiveSessionWidget extends StatelessWidget {
  const LiveSessionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          horizontalTitleGap: 4,
          leading: CustomSvgIcon(
            assetName: 'on_air',
            width: 16,
            height: 16,
            color: AppTheme.isDarkMode() ? Colors.white : mainColor,
          ),
          title: CustomText(
            title: 'Start live session'.tr(),
            fontWeight: FontWeight.bold,
            fontColor: AppTheme.isDarkMode() ? Colors.white : mainColor,
            fontSize: 14,
          ),
          subtitle: CustomText(
            title: 'Connect with your audience'.tr(),
            fontColor: greyColor,
            fontSize: 12,
          ),
          trailing: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              onTap: () {
                ProfileProvider providerProfile = getIt();

                if(providerProfile.getUserModel() != null &&!providerProfile.getUserModel()!.providerModel!.is_accepted){
                  CustomScaffoldMessanger.showToast(title: 'Please wait, your information is being reviewed.'.tr());
                }else{
                  NavigatorHandler.push(const LiveSessionScreen());

                }
              },
              child: CustomText(
                title: 'See All'.tr(),
                fontColor: AppTheme.isDarkMode() ? Colors.white : mainColor,
                fontSize: 14,
              )),
        ),
        const SizedBox(
          height: 12,
        ),
        Consumer<LiveSessionProvider>(builder: (context, provider, _) {
          return SizedBox(
            height: !provider.isLoadingHomeLiveSession &&
                    provider.homeLiveSessionList.isNotEmpty
                ? 160:36,
            child: provider.isLoadingHomeLiveSession
                ? const LoadingIndicator(
                    width: 24,
                    stroke: 3,
                  )
                : provider.homeLiveSessionList.isNotEmpty
                    ? ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        shrinkWrap: true,
                        itemCount: provider.homeLiveSessionList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () {

                                ProfileProvider providerProfile = getIt();

                                if(providerProfile.getUserModel() != null &&!providerProfile.getUserModel()!.providerModel!.is_accepted){
                                  CustomScaffoldMessanger.showToast(title: 'Please wait, your information is being reviewed.'.tr());
                                }else{
                                  NavigatorHandler.push(AddLiveSessionScreen(
                                    liveSessionModel:
                                    provider.homeLiveSessionList[index],
                                  ));
                                }


                              },
                              child: LiveSessionItemWidget(
                                model: provider.homeLiveSessionList[index],
                              ));
                        })
                    : const SizedBox(),
          );
        }),
        const SizedBox(
          height: 12,
        ),
      ],
    );
  }
}
