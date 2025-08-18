import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/navigator/navigator.dart';
import 'package:gymatvendor/presentations/auth_module/provider/auth_provider.dart';
import 'package:gymatvendor/presentations/auth_module/registration_info_screen/registration_info_screen.dart';
import 'package:gymatvendor/presentations/profile_module/provider/profile_provider.dart';
import 'package:gymatvendor/presentations/profile_module/widgets/list_tile_complete_account_widget.dart';
import 'package:gymatvendor/presentations/widgets/custom_button/custom_button.dart';
import 'package:gymatvendor/presentations/widgets/custom_svg/CustomSvgIcon.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors/app_colors.dart';
import '../../core/app_theme/theme.dart';
import '../auth_module/work_with_screen/work_with_screen.dart';
import '../widgets/custom_app_bar/custom_app_bar.dart';
import '../widgets/custom_avatar/custom_avatar.dart';
import '../widgets/custom_bordered_container/custom_bordered_container.dart';
import 'dart:ui' as ui;

import 'bio_coach_account_info_screen.dart';

class AccountInfoScreen extends StatefulWidget {
  const AccountInfoScreen({super.key});

  @override
  State<AccountInfoScreen> createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  @override
  Widget build(BuildContext context) {
    String lang = context.locale.languageCode;
    return Scaffold(
      appBar: CustomAppBar(
        showToolBar: true,
        showBackArrow: true,
        title: 'Account info'.tr(),
        elevation: 1,
        isMainBack: true,
        bgColor: AppTheme.isDarkMode() ? dark : Colors.white,),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Consumer<ProfileProvider>(builder: (context,provider,_){
          String? avatarUrl = provider.getUserModel()!=null&&provider.getUserModel()!.providerModel!=null&&provider.getUserModel()!.providerModel!.mainAccount!=null?provider.getUserModel()!.providerModel!.mainAccount!.logo:null;
          String description = provider.getUserModel()!=null&&provider.getUserModel()!.providerModel!=null&&provider.getUserModel()!.providerModel!.mainAccount!=null?provider.getUserModel()!.providerModel!.mainAccount!.desc??'':'';
          String bussinesName = provider.getUserModel()!=null&&provider.getUserModel()!.providerModel!=null&&provider.getUserModel()!.providerModel!.mainAccount!=null?provider.getUserModel()!.providerModel!.mainAccount!.business_name??'':'';
          String phoneCode = provider.getUserModel()!=null&&provider.getUserModel()!.providerModel!=null&&provider.getUserModel()!.providerModel!.mainAccount!=null?provider.getUserModel()!.providerModel!.mainAccount!.phone_code??'':'';
          String phone = provider.getUserModel()!=null&&provider.getUserModel()!.providerModel!=null&&provider.getUserModel()!.providerModel!.mainAccount!=null?provider.getUserModel()!.providerModel!.mainAccount!.phone??'':'';
          String emailAddress = provider.getUserModel()!=null&&provider.getUserModel()!.providerModel!=null&&provider.getUserModel()!.providerModel!.mainAccount!=null?provider.getUserModel()!.providerModel!.mainAccount!.email??'':'';
          String website = provider.getUserModel()!=null&&provider.getUserModel()!.providerModel!=null&&provider.getUserModel()!.providerModel!.mainAccount!=null?provider.getUserModel()!.providerModel!.mainAccount!.website??'':'';

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24,),
              Center(child: Container(
                alignment: Alignment.center,
                width: 98, height: 98,
                child: Stack(
                  children: [
                    CustomAvatar(
                      url:avatarUrl ,
                      radius: 84,
                      elevation: .2,
                      borderColor: AppTheme.isDarkMode() ? Colors.white
                          .withOpacity(
                          .2) : Colors.transparent,
                      placeHolderColor: AppTheme.isDarkMode()
                          ? inputBgDark
                          : inputBg,),
                  ],
                ),
              )),
              const SizedBox(height: 36,),
              CustomText(title: description,
                fontColor: AppTheme.isDarkMode() ? Colors.white : mainColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                maxLines: 2,),
              const SizedBox(height: 24,),
              CustomBorderedContainer(
                borderColor: AppTheme.isDarkMode()?inputBgDark:toggleColorDisactive,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(title: 'Business name'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white.withOpacity(.5):greyColor,fontSize: 15,),
                        Container(
                            width: 180,

                            alignment: lang=='ar'?Alignment.centerLeft:Alignment.centerRight,
                            child: CustomText(title: bussinesName,fontColor: AppTheme.isDarkMode()?Colors.white.withOpacity(.5):mainColor,fontSize: 13,maxLines: 1,))
                      ],
                    ),
                    const SizedBox(height: 12,),
                    ListTileWidget(
                      title: 'you prefer working with?'.tr(),
                      details: 'To give you a better experience we need to know which gender you want to work with'.tr(),
                      isComplete: provider.isSelectedWorkWith(),
                      onTap: () {
                        NavigatorHandler.push(const WorkWithScreen());

                      },
                    ),

                   if (provider.getUserModel()!=null&&provider.getUserModel()!.providerModel!=null&&provider.getUserModel()!.providerModel!.mainAccount!=null&&provider.getUserModel()!.providerModel!.mainAccount!.category.type==USERTYPE.coache.name) const SizedBox(height: 12,),
                    if (provider.getUserModel()!=null&&provider.getUserModel()!.providerModel!=null&&provider.getUserModel()!.providerModel!.mainAccount!=null&&provider.getUserModel()!.providerModel!.mainAccount!.category.type==USERTYPE.coache.name)  ListTileWidget(
                      title: 'Bio'.tr(),
                      details: '',
                      isComplete: provider.isSelectedBio(),
                      onTap: () {
                        NavigatorHandler.push(const BioCoachAccountInfoScreen());
                      },
                    ),
                  ],
                ),),
              const SizedBox(height: 24,),
              CustomText(title: 'Contact Info'.tr(),
                fontColor: AppTheme.isDarkMode() ? Colors.white : mainColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                maxLines: 2,),
              const SizedBox(height: 24,),
              CustomBorderedContainer(
                borderColor: AppTheme.isDarkMode()?inputBgDark:toggleColorDisactive,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(title: 'Phone number'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white.withOpacity(.5):greyColor,fontSize: 15,),
                        Container(
                            width: 180,
                            alignment: lang=='ar'?Alignment.centerLeft:Alignment.centerRight,
                            child: Directionality(textDirection: ui.TextDirection.ltr,
                            child: CustomText(title: '$phoneCode$phone',fontColor: AppTheme.isDarkMode()?Colors.white.withOpacity(.5):mainColor,fontSize: 13,maxLines: 1,)))
                      ],
                    ),
                    const SizedBox(height: 16,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(title: 'Email'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white.withOpacity(.5):greyColor,fontSize: 15,),
                        Container(
                            width: 180,
                            alignment: lang=='ar'?Alignment.centerLeft:Alignment.centerRight,
                            child: Directionality(textDirection: ui.TextDirection.ltr,
                            child: CustomText(title: emailAddress,fontColor: AppTheme.isDarkMode()?Colors.white.withOpacity(.5):mainColor,fontSize: 13,maxLines: 1,)))
                      ],
                    ),
                    const SizedBox(height: 16,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(title: 'Website'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white.withOpacity(.5):greyColor,fontSize: 15,),
                        Container(
                            width: 180,
                            alignment: lang=='ar'?Alignment.centerLeft:Alignment.centerRight,
                            child: Directionality(textDirection: ui.TextDirection.ltr,
                            child: CustomText(title: website,fontColor: AppTheme.isDarkMode()?Colors.white.withOpacity(.5):mainColor,fontSize: 13,maxLines: 1,)))
                      ],
                    ),

                  ],
                ),),
              const SizedBox(height: 48,),
              CustomButton(title: 'Edit'.tr(), onTap: (){
                NavigatorHandler.push(const RegistrationInfoScreen());
              },bg: AppTheme.isDarkMode()?inputBgDark:inputBg,fontColor: AppTheme.isDarkMode()?Colors.white:mainColor,),
              const SizedBox(height: 24,),

            ],);
        },),
      ),
    );
  }
}
