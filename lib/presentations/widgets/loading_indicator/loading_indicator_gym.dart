import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../core/app_theme/theme.dart';
import '../../../core/dimens/dimens.dart';
import '../custom_asset_image/custom_asset_image.dart';


class LoadingIndicatorGym extends StatelessWidget {
  final double? width;

  const LoadingIndicatorGym({super.key, this.width});

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: CustomAssetImage(assetName: AppTheme.isDarkMode()?'loader2':'loader',boxFit: BoxFit.contain,width: Dimens.width,height: Dimens.width/5.5,),
    );
    /*return Center(
      child: Container(
        width: width??256.0,
        height: width??256.0,
        alignment: Alignment.center,
        child: Lottie.asset('assets/images/lottie/loader.json'),
      ),
    );*/
  }
}
