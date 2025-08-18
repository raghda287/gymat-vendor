import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/core/constants/constants.dart';
import 'package:gymatvendor/core/dimens/dimens.dart';
import 'package:gymatvendor/core/navigator/navigator.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

import '../../../injection.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final double? fontSize;
  final Color? fontColor;
  final bool? showBackArrow;
  final bool? centerTitle;
  final List<Widget>? actions;
  final bool showToolBar;
  final double? elevation;
  final Color? bgColor;
  final Color? shadowColor;
  final bool isMainBack;
  final SystemUiOverlayStyle? systemUiOverlayStyle;

  const CustomAppBar(
      {super.key,
      this.title,
      this.fontSize = 20,
      this.fontColor,
      this.showBackArrow = false,
      this.centerTitle ,
      this.actions,
      this.showToolBar = false,
      this.elevation,
        this.shadowColor,
        this.isMainBack = false,
      this.bgColor,
        this.systemUiOverlayStyle,});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: elevation,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: systemUiOverlayStyle,
      shadowColor: elevation != null ? elevation != 0
              ? AppTheme.isDarkMode()
                  ? Colors.white.withOpacity(0)
                  : Colors.black
              : Colors.black
          : shadowColor??Colors.black,
      backgroundColor: bgColor ?? (AppTheme.isDarkMode() ? dark : white),
      title: CustomText(
        title: title ?? '',
        fontSize: fontSize ?? 14,
        fontColor: fontColor != null
            ? fontColor!:(AppTheme.isDarkMode() ? Colors.white : black),
        fontWeight: FontWeight.bold,
      ),
      centerTitle: centerTitle??true,
      leading: showBackArrow != null && showBackArrow!
          ? InkWell(
              onTap: () {
                if(isMainBack){
                  NavigatorHandler.pop();
                }
              },
              child: Icon(
                Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
                color: fontColor??(AppTheme.isDarkMode() ? Colors.white : Colors.black),
              ))
          : const SizedBox(),
      actions: actions,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize =>
      Size(Dimens.width, showToolBar == true ? appBarSize : 0);
}
