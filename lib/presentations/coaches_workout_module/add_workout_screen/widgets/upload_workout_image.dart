import 'package:flutter/material.dart';
import 'package:gymatvendor/presentations/widgets/custom_rounded_image/custom_rounded_image.dart';

class UploadWorkoutImage extends StatelessWidget {
  final String? url;
  final VoidCallback onDeleteTap;
  final VoidCallback onTap;
  const UploadWorkoutImage({super.key, this.url, required this.onDeleteTap, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: SizedBox(
        width: 80,
        height: 80,
        child: Stack(

          children: [
          CustomRoundedImage(width: 80, height: 80,url: url,),
          if(url!=null&&!url!.startsWith('http'))Container(
            width: 24,
            height: 24,
            padding: const EdgeInsets.all(4),
            child: IconButton(padding: EdgeInsets.zero, onPressed:onDeleteTap, icon: Container(
              width: 24,
              height: 24,
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(color: Colors.white.withOpacity(.5),borderRadius: BorderRadius.circular(12)),
              alignment: Alignment.center,
              child: const Icon(Icons.close,color: Colors.black,size: 12,),
            )),
          )
        ],),
      ),
    );
  }
}
