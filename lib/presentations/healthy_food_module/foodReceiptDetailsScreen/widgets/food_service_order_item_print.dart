import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';


import '../../../../core/app_colors/app_colors.dart';
import '../../../../core/app_theme/theme.dart';
import '../../../../core/number_format/numberFormat.dart';
import '../../../../data/models/foodOrderDetailsModel.dart';
import '../../../../data/models/gymOrderDetailsModel.dart';
import '../../../../data/models/service_model.dart';
import '../../../widgets/custom_network_image/custom_network_image.dart';
import '../../../widgets/custom_svg/CustomSvgIcon.dart';
import '../../../widgets/custom_text/custom_text.dart';
import '../../../widgets/love_icon/love_icon.dart';

class FoodServiceOrderItemPrint extends StatelessWidget {
  final OrderFoodDetails model ;
  const FoodServiceOrderItemPrint({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(borderRadius: BorderRadius.circular(4),
                  child: SizedBox(
                      width: 70,
                      height: 70*3/4,
                      child: AspectRatio(aspectRatio: 4/3,child: CustomNetworkImage(url: model.serviceModel?.photo,),))
              ),
              Expanded(child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(title: model.serviceModel?.getTitle(),fontColor: Colors.black,fontSize: 14,maxLines: 1,),
                    const SizedBox(height: 8,),
                    Row(
                      children: [
                        CustomText(title: 'Price:'.tr(),fontColor: greyColor,fontSize: 12,maxLines: 1,),
                        const SizedBox(width: 4,),
                        CustomText(title: CustomNumberFormat.format(model.total??0),fontColor:Colors.black,fontSize: 13,maxLines: 1,fontWeight: FontWeight.bold,),
                        const SizedBox(width: 4,),

                        const CustomSvgIcon(assetName: 'sar',width: 14,height: 14,color: Colors.black,),

                      ],
                    )
                  ],),
              )),
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: greyColor.withOpacity(0.1),shape: BoxShape.circle),
                child: CustomText(title:'X${model.qty}',fontSize: 15,fontColor: mainColor,),
              )
            ],
          ),
          if(model.note!=null&&model.note!.isNotEmpty)Column(
            children: [
              const SizedBox(height: 8,),
              Row(children: [
                const CustomSvgIcon(assetName: 'note',color: greyColor,),
                const SizedBox(width: 8,),
                Expanded(child: CustomText(title: '${model.note}',fontColor: greyColor,fontSize: 12,maxLines: 2,)),

              ],),
            ],
          )

        ],
      ),
    );
  }
}
