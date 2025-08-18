import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/data/models/add_addition_model.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

import '../../../core/constants/constants.dart';
import '../../widgets/custom_svg/CustomSvgIcon.dart';

class AdditionWidget extends StatelessWidget {
  final AddAditionModel model;
  final VoidCallback onTap;

  const AdditionWidget({super.key, required this.model, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
              color: AppTheme.isDarkMode()
                  ? inputBgDark
                  : greyColor.withOpacity(.15))),
      child: Stack(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: IconButton(
                      onPressed: onTap,
                      padding: EdgeInsets.zero,
                      icon: Icon(Icons.close,size: 20,color: AppTheme.isDarkMode()?Colors.white:Colors.black,)),
                ),
              ],
            ),
            CustomText(
              title: model.name,
              fontSize: 14,
              fontColor: AppTheme.isDarkMode() ? Colors.white : Colors.black,
              maxLines: 2,
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                    title: '${formatNumber(model.has_offer!=null&&model.has_offer!?model.newPrice??0.00:model.price)}',
                    fontSize: 14,
                    fontColor: mainColor,fontWeight: FontWeight.bold,),
                const SizedBox(width: 4,),
                const CustomSvgIcon(assetName: 'sar',width: 14,height: 14,color: mainColor,)

              ],
            ),
            if(model.has_offer!=null&&model.has_offer!)
              Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                        title: '${formatNumber(model.price)}',
                        fontSize: 10,
                        fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,
                      decoration: TextDecoration.lineThrough,

                    ),
                    const SizedBox(width: 4,),
                    CustomSvgIcon(assetName: 'sar',width: 14,height: 14,color: AppTheme.isDarkMode()?Colors.white:Colors.black,)

                  ],
                ),
                const SizedBox(height: 4,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(title: '${'Save2'.tr()} ${model.offer_value??0}',fontSize: 11,fontColor: discColor,),
                    const SizedBox(width: 4,),
                    model.offer_type=='value'?
                    const CustomSvgIcon(assetName: 'sar',width: 14,height: 14,color: discColor,):
                    const CustomText(title: '%',fontSize: 11,fontColor: discColor,),

                  ],
                ),

                const SizedBox(height: 4,),



              ],)
          ],
        ),
      ],),
    );
  }
}
