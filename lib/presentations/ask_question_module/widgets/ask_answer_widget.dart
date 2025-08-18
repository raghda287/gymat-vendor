import 'package:flutter/material.dart';
import 'package:gymatvendor/core/dimens/dimens.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

class AskAnswerWidget extends StatelessWidget {
  final double? height;
  final String? title;
  final Color bg;
  final Color fontColor;

  const AskAnswerWidget({super.key, this.height, this.title, required this.bg, required this.fontColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimens.width,
      height: height??110,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: bg,borderRadius: BorderRadius.circular(8)),
      child: CustomText(title: title,fontColor: fontColor,),
    );
  }
}
