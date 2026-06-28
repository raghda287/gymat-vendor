import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/core/dimens/dimens.dart';
import 'package:gymatvendor/data/models/comment_model.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

class CommentCardItem extends StatelessWidget {
  final CommentData comment;

  const CommentCardItem({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    final String displayName = comment.isMe ? 'Me' : comment.user.name;

    return Container(
      width: Dimens.width,
      decoration: BoxDecoration(
        color: AppTheme.isDarkMode() ? dark : Colors.transparent,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: comment.isMe
                  ? Container(
                color: mainColor.withOpacity(0.12),
                child: const Icon(
                  Icons.person,
                  color: mainColor,
                ),
              )
                  : CachedNetworkImage(
                imageUrl: comment.user.photo,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) =>
                const Icon(Icons.person),
              ),
            ),
          ),

          const SizedBox(width: 10),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(title: displayName),
              const SizedBox(height: 8),
              CustomText(title: comment.comment),
            ],
          ),
        ],
      ),
    );
  }
}