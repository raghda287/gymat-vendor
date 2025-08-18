import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/core/navigator/navigator.dart';
import 'package:gymatvendor/presentations/followers_screen/followersScreen.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

import '../../../injection.dart';
import '../../widgets/dialogs/scaffold_messanger.dart';
import '../provider/profile_provider.dart';

class FollowersWidget extends StatelessWidget {
  final String followersNumber;
  const FollowersWidget({super.key, required this.followersNumber});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      onTap: (){
        ProfileProvider provider = getIt();

        if(provider.getUserModel() != null &&!provider.getUserModel()!.providerModel!.is_accepted){
          CustomScaffoldMessanger.showToast(title: 'Please wait, your information is being reviewed.'.tr());
        }else{
          NavigatorHandler.push(const FollowersScreen());

        }
      },
      child: Container(
        constraints: const BoxConstraints(minWidth: 160,maxWidth: 160),
        height: 42,
        decoration: BoxDecoration(color: AppTheme.isDarkMode()?inputBgDark:inputBg,borderRadius: BorderRadius.circular(4)),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(title: followersNumber,fontSize: 14,fontWeight: FontWeight.bold,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,),
            const SizedBox(width: 8,),
            CustomText(title: 'Followers'.tr(),fontSize: 14,fontColor: AppTheme.isDarkMode()?greyColor:mainColor,),

          ],
        ),
      ),
    );
  }
}
