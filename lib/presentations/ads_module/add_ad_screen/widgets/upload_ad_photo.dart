import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

class UploadAdPhoto extends StatelessWidget {
  final String? url;
  final VoidCallback onTap;

  const UploadAdPhoto({super.key, this.url, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16/9,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        child: Container(
          alignment: Alignment.center,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: AppTheme.isDarkMode()?inputBgDark:inputBg),
          child: url==null?CustomText(title: 'Upload your ad photo'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,):Image.file(File(url!,),fit: BoxFit.cover,),
        ),
      ),
    );
  }
}
