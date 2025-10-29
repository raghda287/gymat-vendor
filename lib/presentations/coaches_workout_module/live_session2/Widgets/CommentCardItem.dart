import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/core/dimens/dimens.dart';
import 'package:gymatvendor/data/models/comment_model.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

class CommentCardItem extends StatelessWidget{
  CommentData comment;
  CommentCardItem({required this.comment});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimens.width,
      decoration: BoxDecoration(
        color: AppTheme.isDarkMode()?dark:Colors.transparent
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: CachedNetworkImage(imageUrl: comment.user.user.photo,fit: BoxFit.cover,),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              CustomText(title: comment.user.user.name),
              CustomText(title: comment.comment)
            ],
          )
        ],
      )
    );
  }

}