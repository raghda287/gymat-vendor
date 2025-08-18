import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/dimens/dimens.dart';

class CustomBorderedContainer extends StatelessWidget {
  final Widget child;
  final double? borderRadius;
  final Color? borderColor;
  final Color? bg;
  final double? width;
  final double? height;
  final double? padding;
  const CustomBorderedContainer({super.key, required this.child, this.borderRadius, this.borderColor, this.bg, this.width, this.height, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width??Dimens.width,
      height: height,

      padding:  EdgeInsets.all(padding??12),
      decoration: BoxDecoration(color: bg??Colors.transparent,borderRadius: BorderRadius.circular(borderRadius??8),border: Border.all(color: borderColor??toggleColorDisactive)),
      child: child,
    );
  }
}
