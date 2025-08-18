import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';

class PlayButtonWidget extends StatelessWidget {
  final double width;
  final double height;
  final bool isPlaying;
  final VoidCallback onTap;
  final Color? bg;
  final Color? buttonColor;

  const PlayButtonWidget({super.key,this.width=28,this.height=28,required this.isPlaying,required this.onTap, this.bg, this.buttonColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration:  BoxDecoration(color:bg??mainColor,shape: BoxShape.circle),
      child: IconButton(padding: EdgeInsets.zero,onPressed: onTap, icon:  Icon(isPlaying?Icons.pause:Icons.play_arrow,color: buttonColor??Colors.white,size: 16,),),
    );
  }
}
