import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/presentations/widgets/custom_asset_image/custom_asset_image.dart';
import 'package:gymatvendor/presentations/widgets/custom_svg/CustomSvgIcon.dart';

class CustomRoundedImage extends StatelessWidget {
  final double width;
  final double height;
  final String? url;
  final double? elevation;
  final double? radius;
  final BoxFit? boxFit;
  final Color? bgColor;

  /// اسم أيقونة الـ svg من assets
  final String? emptySvgIcon;

  /// حجم الأيقونة لما مفيش صورة
  final double? emptyIconSize;

  const CustomRoundedImage({
    super.key,
    required this.width,
    required this.height,
    this.url,
    this.elevation,
    this.radius,
    this.boxFit,
    this.bgColor,
    this.emptySvgIcon,
    this.emptyIconSize,
  });

  @override
  Widget build(BuildContext context) {
    final double borderRadius = radius ?? 4;
    final bool hasUrl = url != null && url!.trim().isNotEmpty;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Card(
        surfaceTintColor: Colors.transparent,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: elevation ?? 0,
        margin: EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: hasUrl ? _buildImage() : _buildEmptyView(),
        ),
      ),
    );
  }

  Widget _buildImage() {
    final String imageUrl = url!.trim();

    if (imageUrl.startsWith('assets')) {
      return CustomAssetImage(
        assetName: imageUrl,
        boxFit: boxFit ?? BoxFit.cover,
      );
    }

    if (imageUrl.startsWith('fileimage:')) {
      final String path = imageUrl.replaceAll('fileimage:', '');

      return Image.file(
        File(path),
        width: width,
        height: height,
        fit: boxFit ?? BoxFit.cover,
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: boxFit ?? BoxFit.cover,
      placeholder: (context, url) {
        return _buildEmptyView();
      },
      errorWidget: (context, url, error) {
        return _buildEmptyView();
      },
    );
  }

  Widget _buildEmptyView() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: bgColor ?? (AppTheme.isDarkMode() ? inputBgDark : inputBg),
        borderRadius: BorderRadius.circular(radius ?? 4),
      ),
      child: Center(
        child: emptySvgIcon != null
            ? CustomSvgIcon(
          assetName: emptySvgIcon!,
          width: emptyIconSize ?? 24,
          height: emptyIconSize ?? 24,
          color: greyColor,
        )
            : const Icon(
          Icons.upload_file,
          size: 24,
          color: greyColor,
        ),
      ),
    );
  }
}