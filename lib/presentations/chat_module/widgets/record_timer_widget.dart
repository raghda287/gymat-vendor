
import 'package:flutter/material.dart';
import 'package:gymatvendor/presentations/chat_module/widgets/record_icon_animation.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../widgets/custom_text/custom_text.dart';

class RecordTimerWidget extends StatelessWidget {
  final int seconds;
  const RecordTimerWidget({super.key, required this.seconds});


  @override
  Widget build(BuildContext context) {
    Duration duration = Duration(seconds: seconds);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: [
          const RecordIconAnimation(),
          const SizedBox(width: 8,),
          CustomText(title:seconds>0?'${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}':'',fontColor: mainColor,fontSize: 17,),
        ],
      ),
    );
  }

  String twoDigits(int n)=>n.toString().padLeft(2,'0');
}
