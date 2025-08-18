import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';

import '../../core/app_colors/app_colors.dart';
import '../../core/app_theme/theme.dart';
import '../../core/dimens/dimens.dart';
import '../../core/navigator/navigator.dart';
import '../widgets/custom_app_bar/custom_app_bar.dart';

class ShowImageScreen extends StatefulWidget {
  final String url;
  final num? dimens;
  final String? title;
  const ShowImageScreen({super.key, required this.url, this.dimens, this.title});

  @override
  State<ShowImageScreen> createState() => _ShowImageScreenState();
}

class _ShowImageScreenState extends State<ShowImageScreen> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: InkWell(
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: (){
            isPressed = !isPressed;
            if(mounted){
              setState(() {

              });
            }
          },
          child: Stack(
            children: [

              Center(child: SizedBox(
                  width: Dimens.width,
                  height: widget.dimens!=null? Dimens.width/widget.dimens!:Dimens.width/1,
                  child: PhotoView(imageProvider: CachedNetworkImageProvider(widget.url),))),
              if(!isPressed)Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  child: CustomAppBar(
                    showToolBar: true,
                    showBackArrow: true,
                    isMainBack: true,
                    title: widget.title??'',
                    fontColor: Colors.white,
                    fontSize: 16,
                    elevation: 1,
                    bgColor: msgLeftDarkColor.withOpacity(0.3),
                    systemUiOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.transparent,statusBarIconBrightness: Brightness.light),
                  )),

            ],
          ),
        )
    );

  }
}