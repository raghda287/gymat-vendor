import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/core/dimens/dimens.dart';
import 'package:gymatvendor/presentations/widgets/custom_svg/CustomSvgIcon.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

class MediaChooseWidget extends StatelessWidget {
  final Animation<double> animation;
  final VoidCallback onCameraPressed;
  final VoidCallback onGalleryPressed;


  const MediaChooseWidget(
      {super.key,
      required this.animation,
      required this.onCameraPressed,
      required this.onGalleryPressed});

  @override
  Widget build(BuildContext context) {
    String lang = context.locale.languageCode;
    return CircularRevealAnimation(
      animation: animation,
      minRadius: 0,
      centerOffset:  Offset(lang=='ar'?36:Dimens.width*.46, 120),
      child: Card(
        color: Theme.of(context).cardColor,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: onCameraPressed,
                  child: Row(
                    children: [
                      CustomSvgIcon(
                        assetName: 'camera',
                        color: AppTheme.isDarkMode() ? Colors.white : mainColor,
                        width: 16,
                        height: 16,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      CustomText(
                        title: 'Camera'.tr(),
                        fontColor:
                            AppTheme.isDarkMode() ? Colors.white : mainColor,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                InkWell(
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: onGalleryPressed,
                  child: Row(
                    children: [
                      CustomSvgIcon(
                        assetName: 'gallery',
                        color: AppTheme.isDarkMode() ? Colors.white : mainColor,
                        width: 16,
                        height: 16,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      CustomText(
                        title: 'Gallery'.tr(),
                        fontColor:
                            AppTheme.isDarkMode() ? Colors.white : mainColor,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
