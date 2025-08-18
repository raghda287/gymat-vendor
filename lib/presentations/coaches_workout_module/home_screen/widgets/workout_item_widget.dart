import 'package:flutter/material.dart';
import 'package:gymatvendor/data/models/workout_model.dart';
import 'package:gymatvendor/presentations/widgets/custom_rounded_image/custom_rounded_image.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

import '../../../../core/dimens/dimens.dart';

class WorkoutItemWidget extends StatelessWidget {
  final WorkoutModel workoutModel;
  const WorkoutItemWidget({super.key, required this.workoutModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          children: [
            CustomRoundedImage(
              width: 160,
              height: 160,
              radius: 24,
              url: workoutModel.photo,
            ),
            Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.4),
                  borderRadius: BorderRadius.circular(24)),
            ),
            Positioned(
                bottom: 8,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 120,child: CustomText(title: workoutModel.trans_title!=null?workoutModel.trans_title!.startsWith('trans.')?workoutModel.title??'':workoutModel.trans_title??'':workoutModel.title??'',textAlign: TextAlign.start,maxLines: 2,fontColor: Colors.white,fontSize: 15,fontWeight: FontWeight.bold,),))
          ],
        ),
      ),
    );
  }
}
