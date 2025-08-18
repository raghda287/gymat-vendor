import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';
import 'package:gymatvendor/presentations/widgets/loading_indicator/loading_indicator.dart';
import 'package:gymatvendor/theme_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../../injection.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';
import 'provider/general_setting_provider.dart';
import '../../widgets/toggle_button/toggle_button.dart';
import 'widgets/toggle_dark_mode_button.dart';

class GeneralSettingsScreen extends StatefulWidget {
  const GeneralSettingsScreen({super.key});

  @override
  State<GeneralSettingsScreen> createState() => _GeneralSettingsScreenState();
}

class _GeneralSettingsScreenState extends State<GeneralSettingsScreen> {
  GeneralSettingProvider generalSettingProvider = getIt();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    generalSettingProvider.init();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      generalSettingProvider.getNotificationSetting();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context,themeProvider,_){
      return Scaffold(
          appBar: CustomAppBar(
            showToolBar: true,
            showBackArrow: true,
            isMainBack: true,
            title: 'General setting'.tr(),
            elevation: 1,
            bgColor: AppTheme.isDarkMode() ? dark : Colors.white,
          ),
          body: Consumer<GeneralSettingProvider>(builder: (context,provider,_){
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
              children: [
                ListTile(
                  minLeadingWidth: 0,
                  title: CustomText(title: 'Dark mode'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,fontSize: 14,),
                  trailing: CustomDarkModelToggleButton(onToggle: (bool value) {
                    provider.changeDarkMode(value);
                  }, selected: provider.isDarkModel,),
                  contentPadding: EdgeInsets.zero,
                ),
                Divider(color: AppTheme.isDarkMode()?dark:inputBg,),
                ListTile(
                  minLeadingWidth: 0,
                  title: CustomText(title: 'Default Notification Actions'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,fontSize: 14,),
                  subtitle: CustomText(title: 'You want to receive booking'.tr(),fontColor: greyColor,fontSize: 12,),
                  trailing: provider.isLoadingNotificationSetting?const SizedBox(
                      width: 20,
                      height: 20,
                      child: LoadingIndicator(color: mainColor,stroke: 2,)):CustomToggleButton(
                    inActiveColor: AppTheme.isDarkMode()?dark:toggleColorDisactive,

                    onToggle: (bool value) { provider.changeNotificationAction(); }, selected: provider.notificationSetting?.is_notification==true,),
                  contentPadding: EdgeInsets.zero,
                ),
                ListTile(
                  minLeadingWidth: 0,
                  title: CustomText(title: 'Messages'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,fontSize: 14,),
                  subtitle: CustomText(title: 'When this setting is deactivated, no one can chat with you.'.tr(),fontColor: greyColor,fontSize: 12,),
                  trailing: provider.isLoadingChatSetting?const SizedBox(
                      width: 20,
                      height: 20,
                      child: LoadingIndicator(color: mainColor,stroke: 2,)):CustomToggleButton(
                    inActiveColor: AppTheme.isDarkMode()?dark:toggleColorDisactive,

                    onToggle: (bool value) { provider.changeMessageNotificationAction(); }, selected: provider.notificationSetting?.is_message==true,),
                  contentPadding: EdgeInsets.zero,
                ),
                ListTile(
                  minLeadingWidth: 0,
                  title: CustomText(title: 'Booking remainder'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,fontSize: 14,),
                  subtitle: CustomText(title: 'You want to receive booking reminder.'.tr(),fontColor: greyColor,fontSize: 12,),
                  trailing: provider.isLoadingChatSetting?const SizedBox(
                      width: 20,
                      height: 20,
                      child: LoadingIndicator(color: mainColor,stroke: 2,)):CustomToggleButton(
                    inActiveColor: AppTheme.isDarkMode()?dark:toggleColorDisactive,

                    onToggle: (bool value) { provider.changeReceiveBookingAction(); }, selected: provider.notificationSetting?.bookable==true,),
                  contentPadding: EdgeInsets.zero,
                )

              ],);
          },)
      );
    });

  }
}
