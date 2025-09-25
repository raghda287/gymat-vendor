import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/navigator/navigator.dart';
import 'package:gymatvendor/presentations/auth_module/login_screen/widgets/social_button.dart';
import 'package:gymatvendor/presentations/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:gymatvendor/presentations/widgets/custom_button/custom_button.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';
import 'package:gymatvendor/presentations/widgets/list_animation/list_animation.dart';
import 'package:provider/provider.dart';

import '../../../core/app_theme/theme.dart';
import '../../../injection.dart';
import '../../widgets/custom_text_form/custom_text_form.dart';
import '../../widgets/phone_code_widget/phoneCodeWidget.dart';
import '../provider/auth_provider.dart';
import 'dart:ui' as ui;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthProvider loginProvider = getIt();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loginProvider.init();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(height: 84,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomText(title: 'Hi There!'.tr(),fontWeight: FontWeight.bold,fontColor: mainColor,fontSize: 24,),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomText(title: 'Welcome back, Sign in to your account'.tr(),fontColor: greyColor,fontSize: 16,),
          ),
          const SizedBox(height: 64,),
          Consumer<AuthProvider>(
              builder: (context,provider,_) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Directionality(textDirection: ui.TextDirection.ltr,
                      child: Row(
        
                        children: [
                          Container(
                            height:56,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(color:AppTheme.isDarkMode()?inputBgDark:inputBg,borderRadius: BorderRadius.circular(8)),
                            child: PhoneCodeWidget(countryCode: provider.countryCode,onSelected: (CountryCode? code){
        
                              if(code!=null){
                                provider.updateCountryCode(code);
        
                              }
        
        
                            },),
                          ),
                          const SizedBox(width: 12,),
                          Expanded(child: CustomTextFormField(controller: loginProvider.phoneController,borderRaduis: 8,textInputType: TextInputType.phone,hint: 'Phone number'.tr())),
                        ],
                      )),
                );
              }
          ),
        
          const SizedBox(height: 24,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomButton(title: 'Login'.tr(), onTap: (){
        
              loginProvider.resetSocialAccount();
              loginProvider.checkPhoneNumber(context);
            },fontSize: 16,fontWeight: FontWeight.bold,)
          ),
          const SizedBox(height: 24,),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(children: [
                const Expanded(child: Divider(color: dividerColor,)),
                CustomText(title: ' OR '.tr(),fontColor: hintColor,),
                const Expanded(child: Divider(color: dividerColor,)),
              ],)
          ),
          const SizedBox(height: 24,),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(children: [
                SocialButton(svgIconName: Platform.isAndroid?'google':'apple', onTap: (){loginProvider.socialLogin();},text: Platform.isAndroid?'Sign in with google'.tr():'Sign in with apple'.tr(),),
        
        
              ],)
          ),
        
        
        
        
        ]),
      ),
    );
  }
}
