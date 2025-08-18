import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/core/constants/constants.dart';
import 'package:gymatvendor/data/models/subscribtion_model.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

import '../../../widgets/custom_svg/CustomSvgIcon.dart';

class SubscribtionItem extends StatelessWidget {
  final SubscribtionModel model;
  final int index;
  final VoidCallback onDelete;

  const SubscribtionItem(
      {super.key,
      required this.model,
      required this.index,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(title: model.getTitle()??'',fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,fontSize: 17,maxLines: 1,),
            Row(children: [

              CustomText(title:'${formatNumber(model.has_offer!=null&&model.has_offer!?model.new_price??0.00:model.price??0.00)}',fontColor: model.has_offer!=null&&model.has_offer!?mainColor:greyColor,fontSize: 12,maxLines: 1,),
              const SizedBox(width: 4,),
              CustomSvgIcon(assetName: 'sar',width: 14,height: 14,color: model.has_offer!=null&&model.has_offer!?mainColor:greyColor,),

            ],),
            if(model.has_offer!=null&&model.has_offer!)Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4,),
                Row(children: [
                  CustomText(title:'${formatNumber(model.price??0.00)}',fontColor: greyColor,fontSize: 12,maxLines: 1,decoration: TextDecoration.lineThrough,),
                  const SizedBox(width: 4,),
                  const CustomSvgIcon(assetName: 'sar',width: 14,height: 14,color:greyColor,),

                  const SizedBox(width: 4,),
                  Row(children: [
                    CustomText(title: '${'Save2'.tr()} ${model.offer_value??0.00}',fontSize: 11,fontColor: discColor,),
                    model.offer_type=='value'?
                    const Row(
                      children: [
                        SizedBox(width: 4,),
                        CustomSvgIcon(assetName: 'sar',width: 14,height: 14,color: discColor,),
                      ],
                    ) :const CustomText(title: ' % ',fontSize: 11,fontColor: discColor,),

                  ],)

                ],)
              ],)
          ],
        )),
        IconButton(
            onPressed: onDelete,
            icon: const Icon(
              Icons.delete,
              color: mainColor,
            ))
      ],
    );
  }
}
