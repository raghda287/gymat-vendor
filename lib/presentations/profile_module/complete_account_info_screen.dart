import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/navigator/navigator.dart';
import 'package:gymatvendor/presentations/auth_module/registration_info_screen/registration_info_screen.dart';
import 'package:gymatvendor/presentations/auth_module/registration_step2_screen/registration_step2_screen.dart';
import 'package:gymatvendor/presentations/auth_module/work_with_screen/work_with_screen.dart';
import 'package:gymatvendor/presentations/profile_module/provider/profile_provider.dart';
import 'package:gymatvendor/presentations/profile_module/widgets/list_tile_complete_account_widget.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';
import 'package:gymatvendor/presentations/widgets/dialogs/scaffold_messanger.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors/app_colors.dart';
import '../../core/app_theme/theme.dart';
import '../widgets/custom_app_bar/custom_app_bar.dart';

class CompleteAccountInfoScreen extends StatefulWidget {
  const CompleteAccountInfoScreen({super.key});

  @override
  State<CompleteAccountInfoScreen> createState() =>
      _CompleteAccountInfoScreenState();
}

class _CompleteAccountInfoScreenState extends State<CompleteAccountInfoScreen> {
  @override
  Widget build(BuildContext context) {
    String lang = context.locale.languageCode;
    return Scaffold(
      appBar: CustomAppBar(
        showToolBar: true,
        showBackArrow: true,
        title: 'Complete account info'.tr(),
        elevation: 1,
        isMainBack: true,
        bgColor: AppTheme.isDarkMode() ? dark : Colors.white,
      ),
      body: Consumer<ProfileProvider>(builder: (context,provider,_){
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 24,
              ),
              CustomText(
                title: 'Complete your information to verify the account'.tr(),
                fontSize: 13,
                fontColor: AppTheme.isDarkMode() ? Colors.white : mainColor,
              ),
              const SizedBox(
                height: 12,
              ),
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: AppTheme.isDarkMode()
                      ? inputBgDark
                      : greyColor.withOpacity(.3),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        )),
                    const SizedBox(
                      width: 24,
                    ),
                    Expanded(
                        child: Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: mainColor.withOpacity(.3),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        )),
                    const SizedBox(
                      width: 24,
                    ),
                    Expanded(
                        child: Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: mainColor.withOpacity(.3),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ))
                  ],
                ),
              ),
              const SizedBox(height: 36,),
              ListTileWidget(
                title: 'Account certificates'.tr(),
                isComplete: provider.userModel!=null&&provider.userModel!.providerModel!=null&&provider.userModel!.providerModel!.sign_info,
                onTap: () {
                  if(provider.userModel!=null&&provider.userModel!.providerModel!=null&&!provider.userModel!.providerModel!.sign_info){
                    NavigatorHandler.push(const RegistrationStep2Screen());

                  }else{
                    CustomScaffoldMessanger.showScaffoledMessanger(title: 'Your certificates have sent to adminstration for reviewing'.tr());
                  }
                },
              ),
              const SizedBox(height: 16,),
              Divider(color: AppTheme.isDarkMode()?inputBgDark:greyColor.withOpacity(.1),),
              const SizedBox(height: 16,),

              ListTileWidget(
                title: 'Provider certificates'.tr(),
                isComplete: false,
                onTap: () {
                  NavigatorHandler.push(const RegistrationInfoScreen());

                },
              ),
              const SizedBox(height: 16,),
              Divider(color: AppTheme.isDarkMode()?inputBgDark:greyColor.withOpacity(.1),),
              const SizedBox(height: 16,),
              ListTileWidget(
                title: 'you prefer working with?'.tr(),
                details: 'To give you a better experience we need to know which gender you want to work with'.tr(),
                isComplete: false,
                onTap: () {
                  NavigatorHandler.push(const WorkWithScreen());

                },
              ),
              const SizedBox(height: 16,),
            ],
          ),
        );
      },),
    );
  }
}
