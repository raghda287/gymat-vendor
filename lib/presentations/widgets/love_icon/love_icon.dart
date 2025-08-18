import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';

import 'love_animation_widget.dart';

class LoveIcon extends StatefulWidget {
  bool isLiked;
  LoveIcon({super.key,required this.isLiked});

  @override
  State<LoveIcon> createState() => _LoveIconState();
}

class _LoveIconState extends State<LoveIcon> {
  @override
  Widget build(BuildContext context) {
    return LoveAnimationWidget(
      isAnimated: widget.isLiked,
      duration: const Duration(milliseconds: 150),
      alwayesAnimate: true,
      child: IconButton(
          alignment: Alignment.center,
          padding: EdgeInsets.zero,
          onPressed: (){
        setState(() {
          widget.isLiked = !widget.isLiked;
        });
      }, icon: Icon(widget.isLiked?Icons.favorite_rounded:Icons.favorite_outline_rounded,color: widget.isLiked?mainColor:AppTheme.isDarkMode()?greyColor:Colors.black,)),
    );
  }
}
