import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

class HomeCategoryWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const HomeCategoryWidget({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      onTap: onTap,
      child: Card(
        color: Theme.of(context).cardColor,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Center(child: CustomText(title: title,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,fontSize: 11,maxLines: 1,)),
        ),
      ),
    );
  }
}
