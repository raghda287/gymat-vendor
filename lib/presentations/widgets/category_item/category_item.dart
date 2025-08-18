import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/core/dimens/dimens.dart';
import 'package:gymatvendor/data/models/department_model.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

class CategoryItem extends StatelessWidget {
  final DepartmentModel model;
  final int index;
  final bool selected;
  final ValueChanged onTap;
  final VoidCallback onLongTap;

  const CategoryItem({super.key, required this.model, required this.index, required this.onTap, required this.selected, required this.onLongTap});

  @override
  Widget build(BuildContext context) {

    return InkWell(
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        onLongPress: onLongTap,
        onTap: (){
          onTap(index);
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CustomText(title: model.trans_title!.contains('trans')?model.title??'':model.trans_title??'',fontColor: selected?mainColor:(AppTheme.isDarkMode()?Colors.white.withOpacity(.5):greyColor),),
            ),
            const SizedBox(height: 4,),
            Container(
              width: selected?24:0,
              height: 2,
              decoration: BoxDecoration(color: mainColor,borderRadius: BorderRadius.circular(1)),
            )
          ],
        ));
  }


}
