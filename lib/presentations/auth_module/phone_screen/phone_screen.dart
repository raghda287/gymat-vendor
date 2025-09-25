import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../../injection.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';
import '../../widgets/custom_button/custom_button.dart';
import '../../widgets/custom_text/custom_text.dart';
import '../../widgets/custom_text_form/custom_text_form.dart';
import '../../widgets/phone_code_widget/phoneCodeWidget.dart';
import '../provider/auth_provider.dart';
import 'dart:ui' as ui;


class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  AuthProvider loginProvider = getIt();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CustomAppBar(title: 'Phone verification'.tr(),fontSize: 18,showToolBar: true,showBackArrow: true,isMainBack: true),
      body: Column(children: [
        Expanded(
          child: Column(
            children: [
              const SizedBox(height: 24,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: CustomText(title: 'Enter phone number to send verification code.'.tr(),fontSize: 16,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,),
              ),
              const SizedBox(height: 16,),

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
                              Expanded(child: CustomTextFormField(controller: provider.phoneController,borderRaduis: 8,textInputType: TextInputType.phone,hint: 'Phone number'.tr())),
                            ],
                          )),
                    );
                  }
              ),
              const SizedBox(height: 24,),
            ],
          ),
        ),

        Column(
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CustomButton(title: 'Next'.tr(), onTap: (){
                  loginProvider.checkPhoneNumber(context);
                },fontSize: 16,fontWeight: FontWeight.bold,)
            ),
            const SizedBox(height: 24,),
          ],
        )


      ]),
    );
  }
}
