import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/presentations/widgets/custom_svg/CustomSvgIcon.dart';

import '../../../core/app_theme/theme.dart';
import '../custom_asset_image/custom_asset_image.dart';
import '../custom_text/custom_text.dart';

class OnlinePaymentWidget extends StatelessWidget {
  const OnlinePaymentWidget ({super.key});

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(title: 'Online card'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,fontSize: 14,),
        const CustomSvgIcon(assetName: 'mastercard',width: 36,height: 24,),
      ],
    );
  }
}
