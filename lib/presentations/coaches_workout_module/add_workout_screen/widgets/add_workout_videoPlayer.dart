import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/presentations/widgets/play_button_widget/play_button_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class AddWorkoutVideoPlayer extends StatefulWidget {
  final String videoPath;
  final num? aspectRatio;
  final Function onVideoLoaded;
  final VideoPlayerController playerController;

  AddWorkoutVideoPlayer({super.key, required this.videoPath, required this.onVideoLoaded, this.aspectRatio, required this.playerController});

  @override
  State<AddWorkoutVideoPlayer> createState() => _AddWorkoutVideoPlayerState();
}

class _AddWorkoutVideoPlayerState extends State<AddWorkoutVideoPlayer> {
  String? duration;
  String? videoImagePath;
  bool isPlaying = false;
  bool show = true;


  @override
  Widget build(BuildContext context) {

    return widget.playerController.value.isInitialized?Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      constraints:  BoxConstraints(maxWidth: widget.aspectRatio!=null&&widget.aspectRatio!>1?220:100,minHeight: widget.aspectRatio!=null&&widget.aspectRatio!>1?48:100),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: Stack(
        alignment: Alignment.center,
        children: [
        InkWell(
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: (){

            //startTimer();
          },
          child: AspectRatio(
              aspectRatio:widget.playerController.value.aspectRatio,
              child: VideoPlayer(widget.playerController)),
        ),
          show?PlayButtonWidget(isPlaying: isPlaying, onTap: (){
          if(isPlaying){
            isPlaying = false;
            widget.playerController.pause();
            show = true;
          }else{
            widget.playerController.play();
            isPlaying = true;

          }
          setState(() {

          });

        },bg: Colors.white.withOpacity(.5),buttonColor: Colors.black.withOpacity(.6),):const SizedBox()
      ],),
    ):Container(decoration: BoxDecoration(color: AppTheme.isDarkMode()?inputBgDark:inputBg,borderRadius: BorderRadius.circular(8)),);
  }
}
