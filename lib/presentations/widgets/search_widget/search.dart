import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/presentations/widgets/custom_svg/CustomSvgIcon.dart';
import 'package:provider/provider.dart';

import '../../../core/text_styles/text_styles.dart';

class Search extends StatelessWidget {
  final TextEditingController controller;
  const Search({super.key,required this.controller});

  @override
  Widget build(BuildContext context) {

    return Container(
      width: 180,
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(22),border: Border.all(color: AppTheme.isDarkMode()?inputBg.withOpacity(.3):greyColor)),
      child:  Row(children: [
        CustomSvgIcon(assetName: 'search',width: 16,height: 16,color: AppTheme.isDarkMode()?mainColor:greyColor,),
        const SizedBox(width: 8,),
        Expanded(
          child: TextFormField(
            controller: controller,
            textAlignVertical: TextAlignVertical.center,
            cursorColor: mainColor,
            style: AppTextStyles().normalText(fontSize: 13).textColorNormal(AppTheme.isDarkMode()?Colors.white:Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Search for ?'.tr(),
              hintStyle: AppTextStyles().normalText(fontSize: 14).textColorNormal(hintColor),
            ),
          ),
        )
      ],),
    );
  }
}
