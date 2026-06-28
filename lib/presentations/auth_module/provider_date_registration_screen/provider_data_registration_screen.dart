import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/presentations/auth_module/registration_step2_screen/widgets/upload_file_widget.dart';
import 'package:gymatvendor/presentations/gym_module/home_screen/gym_home_screen.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';
import 'package:gymatvendor/presentations/widgets/custom_text_form/custom_text_form.dart';
import 'package:gymatvendor/presentations/widgets/dialogs/scaffold_messanger.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../injection.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';
import '../../widgets/custom_button/custom_button.dart';
import '../provider/auth_provider.dart';

class ProviderDataRegistrationScreen extends StatefulWidget {
  const ProviderDataRegistrationScreen({super.key});

  @override
  State<ProviderDataRegistrationScreen> createState() => _ProviderDataRegistrationState();
}

class _ProviderDataRegistrationState extends State<ProviderDataRegistrationScreen> {
  AuthProvider authProvider = getIt();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      authProvider.initProviderDataRegistration();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        showToolBar: true,
        showBackArrow: true,
        isMainBack: true,
        title: 'Sign up info'.tr(),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12,),
                      CustomText(title: 'Name'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:greyColor,),
                      const SizedBox(height: 12,),
                      CustomTextFormField(controller: provider.providerNameController,textInputType: TextInputType.text,),
                      const SizedBox(height: 12,),
                      CustomText(title: 'Email'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:greyColor,),
                      const SizedBox(height: 12,),
                      CustomTextFormField(controller: provider.providerEmailController,textInputType: TextInputType.emailAddress,),
                      const SizedBox(height: 12,),

                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                child: CustomButton(title: 'Next'.tr(), onTap: (){
                  String name = provider.providerNameController.text;
                  String email = provider.providerEmailController.text;
                  if(name.isNotEmpty&&EmailValidator.validate(email)){
                    provider.signUp();
                  }else{
                    if(name.isEmpty){
                      CustomScaffoldMessanger.showToast(title: 'Name field is required'.tr());
                    }else if(!EmailValidator.validate(email)){
                      CustomScaffoldMessanger.showToast(title: 'Invalid email address'.tr());

                    }
                  }
                }),
              )

            ],
          );
        },
      ),
    );

  }

}
