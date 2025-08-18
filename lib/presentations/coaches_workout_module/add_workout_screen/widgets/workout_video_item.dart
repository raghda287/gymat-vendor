import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/data/models/local_workout_video_model.dart';
import 'package:gymatvendor/presentations/widgets/custom_rounded_image/custom_rounded_image.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

class WorkoutVideoItem extends StatelessWidget {
  final LocalWorkoutVideoModel model;
  final int index;
  final ValueChanged<int> onDismissed;
  final ValueChanged<int> onDelete;
  final VoidCallback onTap;

  const WorkoutVideoItem(
      {super.key,
      required this.model,
      required this.index,
      required this.onDismissed,
        required this.onDelete, required this.onTap});

  @override
  Widget build(BuildContext context) {
    String lang = context.locale.languageCode;
    return Dismissible(
      confirmDismiss: (direction) async{
        onDismissed(index);
        return false;
      },
        direction: DismissDirection.startToEnd,
        secondaryBackground: Container(
          color: Colors.black,
        ),
        key: UniqueKey(),
        onDismissed: (direction) {
        },


        background: Container(
          alignment:
              lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
          decoration: BoxDecoration(color: deleteColor,borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: CustomText(
            title: 'Delete'.tr(),
            fontColor: Colors.white,
          ),
        ),
        child: InkWell(
          focusColor: Colors.transparent,
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: onTap,
          child: Card(
              surfaceTintColor: Colors.transparent,
              elevation: 1,
              color: Theme.of(context).cardColor,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                child: Row(
                  children: [
                    model.videoThumbnail.videoImagePath.startsWith('http')
                        ? CustomRoundedImage(
                            width: 64,
                            height: 64,
                            radius: 12,
                            url: model.videoThumbnail.videoImagePath,
                          )
                        : Container(
                            width: 64,
                            height: 64,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12)),
                            child: Image.file(
                              File(model.videoThumbnail.videoImagePath.replaceAll('fileimage:', '')),
                              fit: BoxFit.cover,
                            )),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          title: model.videoTitle,
                          maxLines: 1,
                          fontColor:
                              AppTheme.isDarkMode() ? Colors.white : Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(height: 8,),
                        CustomText(
                          title: model.duration,
                          maxLines: 1,
                          fontColor:
                              AppTheme.isDarkMode() ? Colors.white.withOpacity(.5) : greyColor,
                          fontSize: 14,
                        ),
                      ],
                    )),
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: (){
                            onDelete(index);
                          }, icon: const Icon(Icons.delete,color: Colors.red,)),
                    )
                  ],
                ),
              )),
        ));
  }
}
