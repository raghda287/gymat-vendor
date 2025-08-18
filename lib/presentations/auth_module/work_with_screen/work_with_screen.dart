import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/navigator/navigator.dart';
import 'package:gymatvendor/presentations/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:gymatvendor/presentations/widgets/dialogs/scaffold_messanger.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../../injection.dart';
import '../../widgets/custom_button/custom_button.dart';
import '../../widgets/custom_text/custom_text.dart';
import '../gender_screen/widgets/gender.dart';
import '../provider/auth_provider.dart';
import '../registration_info_screen/registration_info_screen.dart';

class WorkWithScreen extends StatefulWidget {
  const WorkWithScreen({super.key});

  @override
  State<WorkWithScreen> createState() => _WorkWithScreenState();
}

class _WorkWithScreenState extends State<WorkWithScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AuthProvider authProvider = getIt();
    authProvider.initWorkWith();
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
                        title: 'you prefer working with?'.tr(),
                        fontWeight: FontWeight.bold,
                        fontColor: mainColor,
                        fontSize: 24,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      CustomText(
                        title:
                            'To give you a better experience we need to know which gender you want to work with'
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          provider.updateWorkWithGender('male');
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Gender(
                            iconName: 'male',
                            title: 'Male'.tr(),
                            selected: provider.workWithGender == 'male'),
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      InkWell(
                        onTap: () {
                          provider.updateWorkWithGender('female');
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Gender(
                            iconName: 'female',
                            title: 'Female'.tr(),
                            selected: provider.workWithGender == 'female'),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      provider.updateWorkWithGender('both');
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Gender(
                        iconName: 'both_gender',
                        title: 'Both'.tr(),
                        selected: provider.workWithGender == 'both'),
                  ),
                ],
              );
            }),
            const Expanded(child: SizedBox()),
            CustomButton(
              title: 'Confirm'.tr(),
              onTap: () {
                AuthProvider provider = getIt();
                if (provider.workWithGender != null) {
                  provider.updateAccountWorkWith();
                } else {
                  CustomScaffoldMessanger.showScaffoledMessanger(
                    title:
                        'To give you a better experience we need to know which gender you want to work with'
                            .tr(),
                  );
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
