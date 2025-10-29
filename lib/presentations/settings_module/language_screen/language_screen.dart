import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/navigator/navigator.dart';
import 'package:gymatvendor/presentations/settings_module/language_screen/widgets/language_item.dart';
import 'package:gymatvendor/presentations/widgets/custom_button/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../../core/constants/constants.dart';
import '../../../injection.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';
import 'provider/language_provider.dart';



class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  final LanguageProvider languageProvider = getIt();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    languageProvider.init();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showToolBar: true,
        showBackArrow: true,
        isMainBack: true,
        title: 'Select language'.tr(),
        elevation: 1,
        bgColor: AppTheme.isDarkMode() ? dark : Colors.white,
      ),
      body: Consumer<LanguageProvider>(builder: (context,provider,_){
        return Column(
          children: [
            Expanded(child: ListView.builder(itemBuilder: (context,index){
              return LanguageItem( selected: provider.selectedIndex == index,onTap: (){
                provider.saveLanguage(index);
                Restart.restartApp(
                  notificationTitle: 'Restarting App',
                  notificationBody: 'Please tap here to open the app again.'
                );
              }, model: appLanguage[index],);
            },itemCount:appLanguage.length,shrinkWrap: true,)),
          ],
        );

      },),
    );
  }
}
