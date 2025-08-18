import 'package:flutter/material.dart';

class TrimmerPlayButtonWidget extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onTap;
  final bool show;

  const TrimmerPlayButtonWidget({super.key, required this.isPlaying, required this.onTap, required this.show});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      child: Visibility(
        visible: show,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(color: Colors.white.withOpacity(.5),shape: BoxShape.circle,),
          alignment: Alignment.center,
          child: Icon(isPlaying?Icons.pause_rounded:Icons.play_arrow_rounded,size: 24,color: Colors.black.withOpacity(.6),),
        ),
      ),
    );
  }
}
