import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_url/app_url.dart';
import 'package:gymatvendor/core/navigator/navigator.dart';
import 'package:gymatvendor/presentations/ads_module/my_ads_screen/my_ads_screen.dart';
import 'package:gymatvendor/presentations/auth_module/provider/auth_provider.dart';
import 'package:gymatvendor/presentations/auth_module/registration_info_screen/registration_info_screen.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/livesession_screen/webview_livesession_screen.dart';
import 'package:gymatvendor/presentations/healthcub_spa_module/employee_screen/employee_screen.dart';
import 'package:gymatvendor/presentations/profile_module/provider/profile_provider.dart';
import 'package:gymatvendor/presentations/profile_module/widgets/followers_widgets.dart';
import 'package:gymatvendor/presentations/profile_module/widgets/list_tile_widget.dart';
import 'package:gymatvendor/presentations/settings_module/general_settings_screen/general_settings_screen.dart';
import 'package:gymatvendor/presentations/settings_module/language_screen/language_screen.dart';
import 'package:gymatvendor/presentations/wallet_module/screens/wallet_screen.dart';
import 'package:gymatvendor/presentations/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:gymatvendor/presentations/widgets/custom_avatar/custom_avatar.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';
import 'package:gymatvendor/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_colors/app_colors.dart';
import '../../core/app_theme/theme.dart';
import '../../core/utils/social_media_helper.dart';
import '../../data/models/user_model.dart';
import '../../injection.dart';
import '../../main.dart';
import '../ask_question_module/ask_question_screen.dart';
import '../gym_module/home_screen/widgets/unAccepted_widget.dart';
import '../gym_module/home_screen/widgets/unauth_widget.dart';
import '../payment_module/payment_cards_screen/payment_cards_screen.dart';
import '../settings_module/language_screen/provider/language_provider.dart';
import '../widgets/dialogs/scaffold_messanger.dart';
import 'account_info_screen.dart';
import 'widgets/switch_account_widget.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileProvider profileProvider = getIt();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      profileProvider.init();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, provider, _) {
        return Consumer<ThemeProvider>(builder: (context, provider, _) {
          return Scaffold(
            appBar: CustomAppBar(
              showToolBar: true,
              showBackArrow: true,
              title: 'Profile'.tr(),
              elevation: 1,
              isMainBack: true,
              bgColor: AppTheme.isDarkMode() ? dark : Colors.white,
            ),
            body: Column(
              children: [
                Consumer<ProfileProvider>(builder: (context, provider, _) {
                  if(provider.getUserModel() != null && !provider.getUserModel()!.providerModel!.sign_info){
                    return const UnAuthWidget();

                  }else if(provider.getUserModel() != null &&!provider.getUserModel()!.providerModel!.is_accepted){
                    return const UnAcceptedWidget();
                  }else{
                    return const SizedBox();
                  }
                }),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 24,
                        ),
                        Consumer<ProfileProvider>(
                            builder: (context, providerProfile, _) {
                          String bussinesName = providerProfile.getUserModel() != null && providerProfile.getUserModel()!.providerModel != null && providerProfile
                                              .getUserModel()!
                                              .providerModel!
                                              .mainAccount != null ? providerProfile.getUserModel()!.providerModel!.mainAccount!.business_name ?? '' : '';
                          String email =
                              providerProfile.getUserModel() != null &&
                                      providerProfile
                                              .getUserModel()!
                                              .providerModel !=
                                          null &&
                                      providerProfile
                                              .getUserModel()!
                                              .providerModel!
                                              .mainAccount !=
                                          null
                                  ? providerProfile
                                          .getUserModel()!
                                          .providerModel!
                                          .mainAccount!
                                          .email ??
                                      ''
                                  : '';
                          String? avatarUrl =
                              providerProfile.getUserModel() != null &&
                                      providerProfile
                                              .getUserModel()!
                                              .providerModel !=
                                          null &&
                                      providerProfile
                                              .getUserModel()!
                                              .providerModel!
                                              .mainAccount !=
                                          null
                                  ? providerProfile
                                      .getUserModel()!
                                      .providerModel!
                                      .mainAccount!
                                      .logo
                                  : null;

                          bool hasManyAccounts = providerProfile.getUserModel()!.providerModel!.accounts.length>1;
                          bool isAccountCompleted = providerProfile.isAccountProviderCompleted();

                          return Column(
                            children: [
                              Center(
                                  child: CustomAvatar(
                                url: avatarUrl!=null?avatarUrl.contains('default-img')?getAvatarAssets(providerProfile.getUserModel()!.providerModel!.mainAccount!):avatarUrl:getAvatarAssets(providerProfile.getUserModel()!.providerModel!.mainAccount!),
                                radius: 84,
                                elevation: .2,
                                borderColor: AppTheme.isDarkMode()
                                    ? Colors.white.withOpacity(.2)
                                    : Colors.transparent,
                                placeHolderColor: AppTheme.isDarkMode()
                                    ? inputBgDark
                                    : inputBg,
                              )),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      width: 150,
                                      alignment: Alignment.center,
                                      child: CustomText(
                                        title: isAccountCompleted?bussinesName:hasManyAccounts?'Switch account'.tr():'',
                                        fontColor: AppTheme.isDarkMode()
                                            ? Colors.white
                                            : mainColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                      )),
                                  hasManyAccounts?const SwitchAccountWidget():const SizedBox()

                                ],
                              ),

                               SizedBox(
                                height: isAccountCompleted?8:0,
                              ),
                              isAccountCompleted?email.isEmpty
                                  ? const SizedBox()
                                  : CustomText(
                                      title: email,
                                      fontColor: AppTheme.isDarkMode()
                                          ? greyColor.withOpacity(.8)
                                          : greyColor,
                                      fontSize: 14,
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                    ):const SizedBox(),
                              SizedBox(
                                height: email.isEmpty ? 0 : isAccountCompleted?8:0,
                              ),
                              isAccountCompleted?FollowersWidget(followersNumber: '${providerProfile.folowers}',
                              ):const SizedBox(),
                              const SizedBox(
                                height: 12,
                              ),
                            ],
                          );
                        }),
                        Consumer<ProfileProvider>(
                            builder: (context, providerProfile, _) {
                          return ListTileWidget(
                            title: 'Account info'.tr(),
                            isComplete: profileProvider.isSelectedWorkWith()&&profileProvider.isSelectedBio(),
                            iconName: 'profile',
                            onTap: () {

                              if(profileProvider.isAccountProviderCompleted()){
                                NavigatorHandler.push(const AccountInfoScreen());

                              }else{
                                NavigatorHandler.push(const RegistrationInfoScreen());

                              }

                            },
                          );
                        }),
                        ListTileWidget(
                          title: 'Wallet'.tr(),
                          iconName: 'wallet',
                          onTap: () {
                            ProfileProvider provider = getIt();

                            if(provider.getUserModel() != null &&!provider.getUserModel()!.providerModel!.is_accepted){
                              CustomScaffoldMessanger.showToast(title: 'Please wait, your information is being reviewed.'.tr());
                            }else{
                              NavigatorHandler.push(const WalletScreen());

                            }


                          },
                        ),

                        ListTileWidget(
                          title: 'Payment cards'.tr(),
                          iconName: 'payment_card',
                          onTap: () {
                            ProfileProvider provider = getIt();

                            if(provider.getUserModel() != null &&!provider.getUserModel()!.providerModel!.is_accepted){
                              CustomScaffoldMessanger.showToast(title: 'Please wait, your information is being reviewed.'.tr());
                            }else{
                              NavigatorHandler.push(const PaymentCardsScreen());

                            }

                          },
                        ),

                        ListTileWidget(
                          title: 'Advertising'.tr(),
                          iconName: 'ad',
                          onTap: () {
                            ProfileProvider provider = getIt();

                            if(provider.getUserModel() != null &&!provider.getUserModel()!.providerModel!.is_accepted){
                              CustomScaffoldMessanger.showToast(title: 'Please wait, your information is being reviewed.'.tr());
                            }else{
                              NavigatorHandler.push(const MyAdsScreen());

                            }

                          },
                        ),
                        Visibility(
                          visible: profileProvider.getUserModel() != null &&
                              profileProvider.getUserModel()!.providerModel !=
                                  null &&
                              profileProvider
                                      .getUserModel()!
                                      .providerModel!
                                      .mainAccount !=
                                  null &&
                              profileProvider
                                      .getUserModel()!
                                      .providerModel!
                                      .mainAccount!
                                      .category
                                      .type ==
                                  USERTYPE.healthClubAndSpa.name,
                          child: ListTileWidget(
                            title: 'Employees'.tr(),
                            iconName: 'employee',
                            onTap: () {
                              ProfileProvider provider = getIt();

                              if(provider.getUserModel() != null &&!provider.getUserModel()!.providerModel!.is_accepted){
                                CustomScaffoldMessanger.showToast(title: 'Please wait, your information is being reviewed.'.tr());
                              }else{
                                NavigatorHandler.push(const EmployeeScreen());

                              }
                            },
                          ),
                        ),
                        ListTileWidget(
                          title: 'Language'.tr(),
                          iconName: 'lang',
                          onTap: () {
                            NavigatorHandler.push(const LanguageScreen());
                          },
                        ),
                        Divider(
                          color: AppTheme.isDarkMode()
                              ? inputBgDark.withOpacity(.6)
                              : inputBg,
                        ),
                        ListTileWidget(
                          title: 'General setting'.tr(),
                          iconName: 'settings',
                          onTap: () {
                            NavigatorHandler.push(
                                const GeneralSettingsScreen());
                          },
                        ),
                        Divider(
                          color: AppTheme.isDarkMode()
                              ? inputBgDark.withOpacity(.6)
                              : inputBg,
                        ),
                        ListTileWidget(
                          title: 'Terms & conditions'.tr(),
                          iconName: 'sheild',
                          onTap: () async{
                            await launchUrl(Uri.parse('${AppUrls.baseUrl}webView/terms_conditions?lang=${navigatorKey.currentContext!.locale.languageCode}'),mode: LaunchMode.inAppBrowserView);

                          },
                        ),
                        ListTileWidget(
                          title: 'Rate Us'.tr(),
                          iconName: 'empty_star',
                          onTap: () {
                            SocialMediaHelper()
                                .openStore('com.apps.gymatvendor', null);
                          },
                        ),
                        Consumer<ProfileProvider>(

                          builder: (context,provider,_){
                            return provider.userModel==null?const SizedBox():
                            Column(children: [
                              const SizedBox(height: 8,),

                              ListTileWidget(
                                title: 'Delete account'.tr(),
                                showArrow: false,
                                fontColor: Colors.red,
                                iconName: 'delete_account',
                                onTap: () {
                                  createAlertDialogDeleteAccount();
                                },
                              ),
                              ListTileWidget(
                                title: 'Logout'.tr(),
                                showArrow: false,
                                iconName: 'logout',
                                onTap: () {
                                  AuthProvider authProvider = getIt();
                                  authProvider.logout();
                                },
                              ),


                            ],);
                          },
                        ),

                        const SizedBox(
                          height: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  void createAlertDialogDeleteAccount() {
    showDialog(context: navigatorKey.currentContext!, builder: (context){
      return  AlertDialog(
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        content: Column(mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12,),
            CustomText(title: 'Are you sure to delete your account ?'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,fontSize: 16,fontWeight: FontWeight.bold,)

          ],

        ),actions: [
        InkWell(
            onTap: () async{
              AuthProvider authProvider = getIt();
              NavigatorHandler.pop();
              await Future.delayed(const Duration(milliseconds: 500));
              authProvider.deleteAccount();

            },
            child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12),
                child: CustomText(title: 'Delete'.tr(),fontSize: 13,fontColor: Colors.red,))),
        InkWell(
            onTap: (){
              NavigatorHandler.pop();
            },
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: CustomText(title: 'Cancel'.tr(),fontSize: 13,fontColor:AppTheme.isDarkMode()?Colors.white:Colors.black,)))
      ],);
    });
  }



  String getAvatarAssets(AccountsModel accountsModel){

    if(accountsModel.category.type==USERTYPE.gym.name){
      return 'assets/images/icons/gym_avatar.png';
    }else if(accountsModel.category.type==USERTYPE.coache.name){
      return 'assets/images/icons/coach_avatar.png';
    }else if(accountsModel.category.type==USERTYPE.healthClubAndSpa.name){
      return 'assets/images/icons/spa_avatar.png';
    }else if(accountsModel.category.type==USERTYPE.healthyFood.name){
      return 'assets/images/icons/food_avatar.png';
    }else if(accountsModel.category.type==USERTYPE.market.name){
      return 'assets/images/icons/shop_avatar.png';
    }else if(accountsModel.category.type==USERTYPE.sportFieldRentals.name){
      return 'assets/images/icons/sport_field_avatar.png';
    }

    return '';
  }

}
