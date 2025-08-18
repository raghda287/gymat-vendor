import 'package:flutter/material.dart';

import '../../../../core/app_colors/app_colors.dart';
import '../../../../core/app_theme/theme.dart';
import '../../../widgets/custom_avatar/custom_avatar.dart';
import '../../../widgets/custom_svg/CustomSvgIcon.dart';

class AddPhotoWidget extends StatelessWidget {
  final String? path;
  const AddPhotoWidget({super.key, this.path});

  @override
  Widget build(BuildContext context) {
    return Center(child: Container(
      alignment: Alignment.center,
      width: 112, height: 112,
      child: Stack(
        children: [
          CustomAvatar(
            url: path,
            radius: 112,
            elevation: .2,
            borderColor: AppTheme.isDarkMode() ? Colors.white
                .withOpacity(
                .2) : Colors.transparent,
            placeHolderColor: AppTheme.isDarkMode()
                ? inputBgDark
                : inputBg,),
          Positioned(
              bottom: 0,
              child: Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: mainColor,
                    borderRadius: BorderRadius.circular(18)),
                child: const CustomSvgIcon(
                  assetName: 'edit', width: 14, height: 14,),
              )),
        ],
      ),
    ));
  }
}
