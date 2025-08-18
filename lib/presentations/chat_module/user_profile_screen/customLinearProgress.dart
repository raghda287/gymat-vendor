import 'package:flutter/material.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';

class CustomLinearProgressIndicator extends StatelessWidget {
  final double persentage;
  const CustomLinearProgressIndicator({super.key, required this.persentage});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 160,height: 8,
      child: Stack(children: [
        Container(
          decoration: BoxDecoration(color: AppTheme.isDarkMode()?greyColor.withOpacity(.2):greyColor.withOpacity(.6),borderRadius: BorderRadius.circular(4)),
        ),
        Container(
          width: 160*persentage,
          decoration: BoxDecoration(gradient: const LinearGradient(colors: [progresssStartColor,progresssEndColor]),borderRadius: BorderRadius.circular(4)),
        )

      ],),
    );
  }
}
