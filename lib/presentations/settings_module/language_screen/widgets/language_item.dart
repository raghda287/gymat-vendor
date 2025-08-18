import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/app_colors/app_colors.dart';
import '../../../../core/app_theme/theme.dart';
import '../../../../data/models/appLanguage.dart';
import '../../../widgets/custom_svg/CustomSvgIcon.dart';
import '../../../widgets/custom_text/custom_text.dart';


class LanguageItem extends StatelessWidget {
  final AppLanguage model;
  final bool selected;
  final VoidCallback onTap;

  const LanguageItem({super.key, required this.model, required this.selected,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      minLeadingWidth: 0,
      leading: CustomSvgIcon(assetName: selected?'check':'uncheck'),
      title: CustomText(
        title: model.title,
        fontSize: 16,
        fontColor: selected
            ? mainColor
            : AppTheme.isDarkMode()
                ? Colors.white
                : Colors.black,
      ),
      subtitle: CustomText(
        title: model.content.tr(),
        fontSize: 13,
        fontColor: selected
            ? mainColor
            : AppTheme.isDarkMode()
            ? Colors.white.withOpacity(.5)
            : greyColor,
      ),
      minVerticalPadding: 0,
    );
  }
}
