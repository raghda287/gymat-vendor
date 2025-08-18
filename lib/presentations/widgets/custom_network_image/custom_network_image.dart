import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';

class CustomNetworkImage extends StatelessWidget {
  final double? width;
  final double? height;
  final String? url;
  final BoxFit? boxFit;
  final Color? bgColor;

  const CustomNetworkImage(
      {super.key,
      required this.url,
      this.width,
      this.height,
      this.boxFit = BoxFit.cover,
      this.bgColor});

  @override
  Widget build(BuildContext context) {
    return url != null
        ? CachedNetworkImage(
            imageUrl: url!,
            width: width,
            height: height,
            fit: boxFit,
          )
        : Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: bgColor ?? (AppTheme.isDarkMode() ? inputBgDark : inputBg),
            ),
          );
  }
}
