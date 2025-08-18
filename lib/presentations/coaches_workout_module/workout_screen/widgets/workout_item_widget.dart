import 'package:flutter/material.dart';
import 'package:gymatvendor/data/models/workout_model.dart';
import 'package:gymatvendor/presentations/widgets/custom_rounded_image/custom_rounded_image.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

import '../../../../core/dimens/dimens.dart';

class WorkoutItemWidget2 extends StatelessWidget {
  final WorkoutModel workoutModel;
  const WorkoutItemWidget2({super.key, required this.workoutModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Stack(
        children: [
          CustomRoundedImage(
            width: Dimens.width,
            height: Dimens.width,
            radius: 24,
            url: workoutModel.photo,
          ),
          Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            width: Dimens.width,
            height: Dimens.width,
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(.4),
                borderRadius: BorderRadius.circular(24)),
          ),
          Positioned(
              bottom: 16,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                width: 120,child: CustomText(title: workoutModel.trans_title!=null?workoutModel.trans_title!.startsWith('trans.')?workoutModel.title??'':workoutModel.trans_title??'':workoutModel.title??'',textAlign: TextAlign.start,maxLines: 2,fontColor: Colors.white,fontSize: 15,fontWeight: FontWeight.bold,),))
        ],
      ),
    );
  }
}
