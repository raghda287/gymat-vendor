import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/core/navigator/navigator.dart';
import 'package:gymatvendor/presentations/growth_module/growth_screen.dart';
import 'package:gymatvendor/presentations/gym_module/home_screen/widgets/card_chart_widget.dart';
import 'package:gymatvendor/presentations/gym_module/home_screen/widgets/card_order_widget.dart';
import 'package:gymatvendor/presentations/widgets/home_category_widget/home_category_widget.dart';
import 'package:gymatvendor/presentations/gym_module/home_screen/widgets/unauth_widget.dart';
import 'package:gymatvendor/presentations/healthy_food_module/provider/healthy_food_home_provider.dart';
import 'package:gymatvendor/presentations/settings_module/general_settings_screen/general_settings_screen.dart';
import 'package:gymatvendor/presentations/settings_module/language_screen/provider/language_provider.dart';
import 'package:gymatvendor/presentations/widgets/custom_svg/CustomSvgIcon.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';
import 'package:gymatvendor/presentations/widgets/start_ads_widget/start_ads_widget.dart';
import 'package:provider/provider.dart';

import '../../../core/notification/notificationActionHandler.dart';
import '../../../core/number_format/numberFormat.dart';
import '../../../data/models/localNotificationHandler.dart';
import '../../../injection.dart';
import '../../../theme_provider.dart';
import '../../auth_module/registration_info_screen/registration_info_screen.dart';
import '../../chat_module/chat_screen/chat_screen.dart';
import '../../chat_module/rooms_screen/rooms_screen.dart';
import '../../gym_module/home_screen/widgets/card_chart_placehoder_widget.dart';
import '../../gym_module/home_screen/widgets/card_order_placeholder_widget.dart';
import '../../gym_module/home_screen/widgets/card_scan_qr_widget.dart';
import '../../gym_module/home_screen/widgets/unAccepted_widget.dart';
import '../../notification_screen/notificationScreen.dart';
import '../../profile_module/profile_screen.dart';
import '../../profile_module/provider/profile_provider.dart';
import '../../qrcode_screen/qrcode_screen.dart';
import '../../widgets/dialogs/scaffold_messanger.dart';
import '../../widgets/home_app_bar/home_app_bar.dart';
import '../../widgets/loading_indicator/loading_indicator.dart';
import '../food_orders_screen/foodOrderScreen.dart';
import '../healthy_food_services_screen/healthy_food_services_screen.dart';

class HealthyFoodHomeScreen extends StatefulWidget {
  final LocalNotificationHandler? localNotificationHandler;
  const HealthyFoodHomeScreen({super.key, this.localNotificationHandler});

  @override
  State<HealthyFoodHomeScreen> createState() => _HealthClubSpaScreenState();
}

class _HealthClubSpaScreenState extends State<HealthyFoodHomeScreen> with WidgetsBindingObserver{
  HealthyFoodHomeProvider healthyFoodHomeProvider = getIt();
  ProfileProvider profileProvider = getIt();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      profileProvider.getProfile();

      healthyFoodHomeProvider.getStatistics();
      healthyFoodHomeProvider.updateToken();
      healthyFoodHomeProvider.getDepartments();
      if(widget.localNotificationHandler!=null&&widget.localNotificationHandler!.notificationType == NotificationType.notification){
        await Future.delayed(const Duration(seconds: 1));
        NavigatorHandler.push(const NotificationScreen());
      }else if(widget.localNotificationHandler!=null&&widget.localNotificationHandler!.notificationType == NotificationType.message){
        await Future.delayed(const Duration(seconds: 1));
        NavigatorHandler.push( ChatScreen(chatUser: widget.localNotificationHandler!.chatUser!));
      }


    });

    WidgetsBinding.instance.addObserver(this);


  }
  @override
  Widget build(BuildContext context) {

    return Consumer<LanguageProvider>(builder: (context,provider,_){
      return Consumer<ThemeProvider>(builder: (context,provider,_){
        return Scaffold(
          appBar: HomeAppBar(
            onProfilePressed: () {
              ProfileProvider profileProvider = getIt();
              if(profileProvider.isAccountProviderCompleted()){
                NavigatorHandler.push(const ProfileScreen());

              }else{
                NavigatorHandler.push(const ProfileScreen());

/*
                NavigatorHandler.push(const RegistrationInfoScreen());
*/

              }
              },
            onChatPressed: () {
              ProfileProvider provider = getIt();

              if(provider.getUserModel() != null &&!provider.getUserModel()!.providerModel!.is_accepted){
                CustomScaffoldMessanger.showToast(title: 'Please wait, your information is being reviewed.'.tr());
              }else{
                NavigatorHandler.push(const RoomsScreen());
              }

            }, onNotificationPressed: () {
            ProfileProvider provider = getIt();

            if(provider.getUserModel() != null &&!provider.getUserModel()!.providerModel!.is_accepted){
              CustomScaffoldMessanger.showToast(title: 'Please wait, your information is being reviewed.'.tr());
            }else{
              NavigatorHandler.push(const NotificationScreen());

            }

          },
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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


                const StartAdsWidget(),
                const SizedBox(height: 24,),
                ListTile(
                  horizontalTitleGap: 4,
                  leading: CustomSvgIcon(assetName: 'calender',width: 16,height: 16,color: AppTheme.isDarkMode()?Colors.white:mainColor,),
                  title: CustomText(title: 'Booking'.tr(),fontWeight: FontWeight.bold,fontColor: AppTheme.isDarkMode()?Colors.white:mainColor,fontSize: 14,),
                  subtitle: CustomText(title: 'Manage your booking'.tr(),fontColor: greyColor,fontSize: 12,),
                ),

                Consumer<HealthyFoodHomeProvider>(
                    builder: (context,provider,_) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          children: [
                            provider.isLoadingStatistics||provider.statisticsHomeModel==null?const CardOrderPlaceholderWidget() :
                            CardOrderWidget(
                              onTap: () {
                                ProfileProvider providerProfile = getIt();

                                if(providerProfile.getUserModel() != null &&!providerProfile.getUserModel()!.providerModel!.is_accepted){
                                  CustomScaffoldMessanger.showToast(title: 'Please wait, your information is being reviewed.'.tr());
                                }else{
                                  NavigatorHandler.push(const FoodOrderScreen(orderType: 'up_coming'));

                                }

                              },
                              orderCount:provider.statisticsHomeModel?.booking?.newCount!=null?'${provider.statisticsHomeModel?.booking?.newCount}':'0',
                              title: 'Need to Accept'.tr(),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            provider.isLoadingStatistics||provider.statisticsHomeModel==null?const CardOrderPlaceholderWidget() :CardOrderWidget(
                              onTap: () {
                                ProfileProvider providerProfile = getIt();

                                if(providerProfile.getUserModel() != null &&!providerProfile.getUserModel()!.providerModel!.is_accepted){
                                  CustomScaffoldMessanger.showToast(title: 'Please wait, your information is being reviewed.'.tr());
                                }else{
                                  NavigatorHandler.push(const FoodOrderScreen(orderType: 'complete'));

                                }

                              },
                              orderCount: provider.statisticsHomeModel?.booking?.end!=null?'${provider.statisticsHomeModel?.booking?.end}':'0',
                              title: 'Completed'.tr(),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            CardScanQrWidget(onTap: () {
                              ProfileProvider providerProfile = getIt();

                              if(providerProfile.getUserModel() != null &&!providerProfile.getUserModel()!.providerModel!.is_accepted){
                                CustomScaffoldMessanger.showToast(title: 'Please wait, your information is being reviewed.'.tr());
                              }else{
                                NavigatorHandler.push(const QrCodeScannerScreen());

                              }
                            },)
                          ],
                        ),
                      );
                    }
                ),



                const SizedBox(height: 8,),
                ListTile(
                  horizontalTitleGap: 4,
                  leading: CustomSvgIcon(assetName: 'growth',width: 16,height: 16,color: AppTheme.isDarkMode()?Colors.white:mainColor,),
                  title: CustomText(title: 'Growth Chart'.tr(),fontWeight: FontWeight.bold,fontColor: AppTheme.isDarkMode()?Colors.white:mainColor,fontSize: 14,),
                  subtitle: CustomText(title: 'Set the goals'.tr(),fontColor: greyColor,fontSize: 12,),
                  trailing: InkWell(
                      onTap: (){
                        ProfileProvider providerProfile = getIt();

                        if(providerProfile.getUserModel() != null &&!providerProfile.getUserModel()!.providerModel!.is_accepted){
                          CustomScaffoldMessanger.showToast(title: 'Please wait, your information is being reviewed.'.tr());
                        }else{
                          NavigatorHandler.push(const GrowthScreen());

                        }
                      },
                      child: CustomText(title: 'See All'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:mainColor,fontSize: 14,)),

                ),
                Consumer<HealthyFoodHomeProvider>(
                    builder: (context,provider,_) {
                      return provider.isLoadingStatistics||provider.statisticsHomeModel==null?
                      const CardChartPlaceholderWidget():
                      CardChartWidget(
                        earningPrice: '${provider.statisticsHomeModel?.goals?.total??0}',
                        percentage: double.parse(CustomNumberFormat.format(provider.statisticsHomeModel?.goals?.percent ?? 0,1)),
                      );

                    }
                ),
                const SizedBox(height: 8,),
                ListTile(
                  horizontalTitleGap: 4,
                  leading: CustomSvgIcon(assetName: 'add_service',width: 16,height: 16,color: AppTheme.isDarkMode()?Colors.white:mainColor,),
                  title: CustomText(title: 'Add your Services'.tr(),fontWeight: FontWeight.bold,fontColor: AppTheme.isDarkMode()?Colors.white:mainColor,fontSize: 14,),
                  subtitle: CustomText(title: 'Add your services, Edit, delete...'.tr(),fontColor: greyColor,fontSize: 12,),
                  trailing:
                  InkWell(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        ProfileProvider providerProfile = getIt();

                        if(providerProfile.getUserModel() != null &&!providerProfile.getUserModel()!.providerModel!.is_accepted){
                          CustomScaffoldMessanger.showToast(title: 'Please wait, your information is being reviewed.'.tr());
                        }else{
                          NavigatorHandler.push(const HealthyFoodServicesScreen());

                        }
                      },
                      child: CustomText(title: 'See All'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:mainColor,fontSize: 14,)),
                ),

                Consumer<HealthyFoodHomeProvider>(builder: (context, provider, _) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: provider.isLoadingDepartments
                        ? const LoadingIndicator(width: 24,stroke: 3,)
                        : GridView.builder(
                        shrinkWrap: true,
                        itemCount: provider.departments.length,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 2.5,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8),
                        itemBuilder: (context, index) {
                          return HomeCategoryWidget(
                              title: provider.departments[index].trans_title!.contains('trans')?provider.departments[index].title??'':provider.departments[index].trans_title??'',
                              onTap: () {
                                ProfileProvider providerProfile = getIt();

                                if(providerProfile.getUserModel() != null &&!providerProfile.getUserModel()!.providerModel!.is_accepted){
                                  CustomScaffoldMessanger.showToast(title: 'Please wait, your information is being reviewed.'.tr());
                                }else{
                                  NavigatorHandler.push(HealthyFoodServicesScreen(homeDepartmentModel: provider.departments[index],));

                                }

                              });
                        }),
                  );
                }),
                const SizedBox(height: 24,),


              ],
            ),
          ),
        );

      });

    },);
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if(state==AppLifecycleState.resumed){
      profileProvider.getProfile();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();

  }
}
