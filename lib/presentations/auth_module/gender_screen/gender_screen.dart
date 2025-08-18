import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/navigator/navigator.dart';
import 'package:gymatvendor/injection.dart';
import 'package:gymatvendor/presentations/auth_module/provider_date_registration_screen/provider_data_registration_screen.dart';
import 'package:gymatvendor/presentations/auth_module/work_with_screen/work_with_screen.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/home_screen/coaches_workout_home_screen.dart';
import 'package:gymatvendor/presentations/gym_module/home_screen/gym_home_screen.dart';
import 'package:gymatvendor/presentations/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:gymatvendor/presentations/widgets/dialogs/scaffold_messanger.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../widgets/custom_button/custom_button.dart';
import '../../widgets/custom_text/custom_text.dart';
import '../provider/auth_provider.dart';
import 'widgets/gender.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({super.key});

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  AuthProvider authProvider = getIt();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authProvider.initGender();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        showToolBar: true,
        showBackArrow: true,
        isMainBack: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 24,
                      ),
                      CustomText(
                        title: 'Tell us about yourself!'.tr(),
                        fontWeight: FontWeight.bold,
                        fontColor: mainColor,
                        fontSize: 24,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      CustomText(
                        title:
                            'To give you a better experience we need to know your gender.'
                                .tr(),
                        fontColor: greyColor,
                      ),
                    ],

                  ),
                ),
              ],
            ),
            const Expanded(child: SizedBox()),
            Consumer<AuthProvider>(builder: (context, provider, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      provider.updateGender('male');
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Gender(
                        iconName: 'male',
                        title: 'Male'.tr(),
                        selected: provider.gender == 'male'),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  InkWell(
                    onTap: () {
                      provider.updateGender('female');
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Gender(
                        iconName: 'female',
                        title: 'Female'.tr(),
                        selected: provider.gender == 'female'),

                  ),
                ],
              );
            }),
            const Expanded(child: SizedBox()),
            CustomButton(
              title: 'Next'.tr(),
              onTap: () {
                if(authProvider.gender!=null){
                 /* if(authProvider.account!=null){
                    NavigatorHandler.push(const CoachesWorkoutHomeScreen());

                  }else{
                    NavigatorHandler.push(const ProviderDataRegistrationScreen());

                  }*/
                  NavigatorHandler.push(const ProviderDataRegistrationScreen());


                }else{
                  CustomScaffoldMessanger.showToast(title: 'Select gender'.tr());
                }
              },
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
