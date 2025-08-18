import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../../core/number_format/numberFormat.dart';
import '../../wallet_module/provider/wallet_provider.dart';
import '../custom_asset_image/custom_asset_image.dart';
import '../custom_text/custom_text.dart';
import '../loading_indicator/loading_indicator.dart';

class WalletPaymentBalance extends StatelessWidget {
  const WalletPaymentBalance({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletProvider>(
      builder: (context,provider,_){
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(title: 'Withdraw from wallet'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,fontSize: 14,),

            Row(children: [
              provider.isLoadingBalance?const LoadingIndicator(width: 18,stroke: 2,color: mainColor,):CustomText(title: '${CustomNumberFormat.format(provider.balance)} ${'SAR'.tr()}',fontColor: AppTheme.isDarkMode()?mainColor:Colors.black,fontWeight: FontWeight.bold,),
              const SizedBox(width: 16,),
              const CustomAssetImage(assetName: 'wallet',width: 24,height: 24,),
           ],),
          ],
        );
      },
    
    );
  }
}
