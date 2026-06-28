import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/core/constants/constants.dart';
import 'package:gymatvendor/core/dimens/dimens.dart';
import 'package:gymatvendor/core/navigator/navigator.dart';
import 'package:gymatvendor/presentations/Contract/ContractWebView.dart';
import 'package:gymatvendor/presentations/profile_module/provider/profile_provider.dart';
import 'package:gymatvendor/presentations/widgets/Icons/ContractIcon.dart';
import 'package:gymatvendor/presentations/widgets/custom_svg/CustomSvgIcon.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';
import 'package:gymatvendor/presentations/widgets/dialogs/scaffold_messanger.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../injection.dart';
import '../circle_red_point_widget/circle_red_point_widget.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onProfilePressed;
  final VoidCallback onChatPressed;
  final VoidCallback onNotificationPressed;

  const HomeAppBar({
    super.key,
    required this.onProfilePressed,
    required this.onChatPressed,
    required this.onNotificationPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<ProfileProvider,String?>(
      selector: (context,provider)=>provider.contractUrl,
      builder: (context,contractUrl,child) {
        if(contractUrl!=null){
          // Navigator.push(context, MaterialPageRoute(builder: (context)=>ContractWebView(contractUrl: contractUrl)));
          _openContract(contractUrl);
        }
        return AppBar(
          elevation: 1,
          surfaceTintColor: Colors.transparent,
          backgroundColor: AppTheme.isDarkMode() ? dark : white,
          title: CustomText(
            title: 'Home page'.tr(),
            fontSize: 20,
            fontColor: AppTheme.isDarkMode() ? Colors.white : black,
            fontWeight: FontWeight.bold,
          ),
          centerTitle: true,
          leading: InkWell(
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: onProfilePressed,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Consumer<ProfileProvider>(
                  builder: (context, provider, _) {
                    return Stack(
                      children: [
                        Center(
                            child: CustomSvgIcon(
                              assetName: 'profile',
                              width: 20,
                              height: 20,
                              color:
                              AppTheme.isDarkMode() ? Colors.white : Colors
                                  .black,
                            )),
                        if(!provider.isAccountProviderCompleted() ||
                            !provider.isSelectedWorkWith() ||
                            !provider.isSelectedBio())const Positioned(
                            bottom: 40,
                            child: CircleRedPointWidget())

                      ],
                    );
                  },
                ),
              )),
          actions: [
            ContractIcon(),
            InkWell(
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: onChatPressed,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: CustomSvgIcon(
                    assetName: 'chats',
                    width: 20,
                    height: 20,
                    color: AppTheme.isDarkMode() ? Colors.white : Colors.black,
                  ),
                )),
            InkWell(
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: onNotificationPressed,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: CustomSvgIcon(
                    assetName: 'notification',
                    width: 24,
                    height: 24,
                    color: AppTheme.isDarkMode() ? Colors.white : Colors.black,
                  ),
                )),
          ],
        );
      }
    );
      
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(Dimens.width, appBarSize);

  void _openContract(String contractUrl)async{
    final Uri uri = Uri.parse(contractUrl);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not open PDF');
    }
  }
}
