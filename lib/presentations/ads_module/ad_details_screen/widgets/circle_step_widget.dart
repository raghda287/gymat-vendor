import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';

class CircleStepWidget extends StatelessWidget {
  final bool selected;
  const CircleStepWidget({super.key, required this.selected});

  @override
  Widget build(BuildContext context) {
    double size = 12;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: selected?mainColor:AppTheme.isDarkMode()?Colors.white:greyColor.withOpacity(.3),borderRadius: BorderRadius.circular(size/2)),
    );
  }
}
