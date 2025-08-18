import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/presentations/widgets/custom_asset_image/custom_asset_image.dart';

class CustomRoundedImage extends StatelessWidget {
  final double width;
  final double height;
  final String? url;
  final double? elevation;
  final double? radius;
  final BoxFit? boxFit;
  final Color? bgColor;
  const CustomRoundedImage({super.key, required this.width,required this.height, this.url,this.elevation,this.radius, this.boxFit, this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius??4)),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Card(
        surfaceTintColor: Colors.transparent,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius??4)),
        elevation: elevation ?? 0,
        margin: EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius??4),
          child: url != null ? url!.startsWith('assets')?CustomAssetImage(assetName: url!,boxFit: boxFit,):url!.startsWith('fileimage:')?Image.file(File(url!.replaceAll('fileimage:', '')),width: radius,height: radius,fit: boxFit,):
          CachedNetworkImage(
                  imageUrl: url!,
                  width: width,
                  height: height,
                  fit: BoxFit.cover,
                ) : Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                      color: bgColor??(AppTheme.isDarkMode()?inputBgDark:inputBg),
                      borderRadius: BorderRadius.circular(radius??4)),
                ),
        ),
      ),
    );
  }
}
