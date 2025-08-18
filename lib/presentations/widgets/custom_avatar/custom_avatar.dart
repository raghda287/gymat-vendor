import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/presentations/widgets/custom_asset_image/custom_asset_image.dart';

import '../../../data/models/user_model.dart';
import '../../auth_module/provider/auth_provider.dart';

class CustomAvatar extends StatelessWidget {
  final double radius;
  final String? url;
  final double? elevation;
  final double? borderWidth;
  final Color? borderColor;
  final Color? placeHolderColor;
  final Widget? placeHolderWidget;


  const CustomAvatar({super.key, required this.radius, this.url,this.elevation,this.borderColor,this.placeHolderColor, this.borderWidth, this.placeHolderWidget});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius,
      height: radius,
      padding: EdgeInsets.all(borderColor!=null?borderWidth??2:0),
      decoration: BoxDecoration(color: borderColor??Colors.transparent,borderRadius: BorderRadius.circular(radius/2)),
      child: Container(
        width: radius,
        height: radius,
        decoration:
        BoxDecoration(borderRadius: BorderRadius.circular(radius / 2)),
        child: Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius/2)),
          elevation: elevation ?? 0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius / 2),
            child: url != null ? url!.startsWith('assets')?CustomAssetImage(assetName: url!):url!.startsWith('fileimage:')?Image.file(File(url!.replaceAll('fileimage:', '')),width: radius,height: radius,): CachedNetworkImage(
              placeholder: (context,url){
                return placeHolderWidget??const SizedBox();
              },
              errorWidget: (context,url,error){
                return placeHolderWidget??const SizedBox();

              },
              imageUrl: url!,
              width: radius,
              height: radius,
              fit: BoxFit.cover,
            ): Container(
              width: radius,
              height: radius,
              decoration: BoxDecoration(
                  color: placeHolderColor??greyColor.withOpacity(.2),
                  borderRadius: BorderRadius.circular(radius / 2)),
            ),
          ),
        ),
      ),
    );
  }


}
