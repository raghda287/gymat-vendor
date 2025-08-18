import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';


import '../../../../core/app_colors/app_colors.dart';
import '../../../../core/app_theme/theme.dart';
import '../../../../core/number_format/numberFormat.dart';
import '../../../../data/models/foodOrderDetailsModel.dart';
import '../../../../data/models/gymOrderDetailsModel.dart';
import '../../../../data/models/service_model.dart';
import '../../../../data/models/shopOrderDetailsModel.dart';
import '../../../widgets/custom_network_image/custom_network_image.dart';
import '../../../widgets/custom_svg/CustomSvgIcon.dart';
import '../../../widgets/custom_text/custom_text.dart';
import '../../../widgets/love_icon/love_icon.dart';

class ShopServiceOrderItem extends StatelessWidget {
  final OrderShopDetails model ;
  const ShopServiceOrderItem({super.key, required this.model});

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
                      width: 64,
                      height: 64,
                      child: AspectRatio(aspectRatio: 4/3,child: CustomNetworkImage(url: model.product!=null&&model.product!.images.isNotEmpty?model.product?.images.first.image:null,),))
              ),
              Expanded(child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(title: model.product?.getTitle(),fontColor: mainColor,fontSize: 14,maxLines: 1,),
                    const SizedBox(height: 4,),
                    if(model.product_price?.title!=null&&model.product_price!.title!.isNotEmpty)Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(title: model.product_price?.title??'',fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,fontSize: 14,maxLines: 1,),
                        const SizedBox(height: 4,),

                      ],),
                    Row(
                      children: [
                        CustomText(title: 'Price:'.tr(),fontColor: greyColor,fontSize: 12,maxLines: 1,),
                        const SizedBox(width: 4,),
                        CustomText(title: CustomNumberFormat.format(model.total??0),fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,fontSize: 13,maxLines: 1,fontWeight: FontWeight.bold,),
                        const SizedBox(width: 4,),
                        CustomSvgIcon(assetName: 'sar',width: 14,height: 14,color: AppTheme.isDarkMode()?Colors.white:Colors.black,),
                      ],
                    ),
                  ],),
              )),
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: AppTheme.isDarkMode()?inputBgDark:greyColor.withOpacity(0.1),shape: BoxShape.circle),
                child: CustomText(title:'X${model.qty}',fontSize: 13,fontColor: mainColor,),
              )

            ],
          ),
          if(model.note!=null&&model.note!.isNotEmpty)Column(
            children: [
              const SizedBox(height: 8,),
              Row(children: [
                const CustomSvgIcon(assetName: 'note',color: greyColor,width: 16,height: 16,),
                const SizedBox(width: 8,),
                Expanded(child: CustomText(title: '${model.note}',fontColor: greyColor,fontSize: 12,maxLines: 2,)),

              ],),
            ],
          )

        ],
      ) ,
    );
  }
}
