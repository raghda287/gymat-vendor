import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/presentations/widgets/custom_svg/CustomSvgIcon.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

import '../../widgets/circle_red_point_widget/circle_red_point_widget.dart';

class ListTileWidget extends StatelessWidget {
  final String title;
  final String? details;
  final VoidCallback onTap;
  final bool isComplete;

  const ListTileWidget(
      {super.key,
      required this.title,
      required this.onTap,
      required this.isComplete,
      this.details});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                title: title,
                fontSize: 15,
                fontColor: AppTheme.isDarkMode() ? Colors.white : Colors.black,
              ),
             if(details!=null) CustomText(
                title: details ?? '',
                fontSize: 12,
                fontColor: greyColor,
              )
            ],
          )),
          const SizedBox(width: 16,),
          Row(
            children: [
              if(!isComplete)const CircleRedPointWidget(),
              if(!isComplete)const SizedBox(width: 12,),
              Icon(Icons.arrow_forward_ios_rounded,size: 16,color: AppTheme.isDarkMode()?Colors.white:Colors.black,)
            ],
          ),
        ],
      ),
    );
  }
}

