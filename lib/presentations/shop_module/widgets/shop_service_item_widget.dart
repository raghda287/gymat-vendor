import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/core/constants/constants.dart';
import 'package:gymatvendor/data/models/service_model.dart';
import 'package:gymatvendor/data/models/shop_service_model.dart';
import 'package:gymatvendor/presentations/widgets/custom_rounded_image/custom_rounded_image.dart';
import 'package:gymatvendor/presentations/widgets/custom_svg/CustomSvgIcon.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

import '../../../core/number_format/numberFormat.dart';

class ShopServiceItemWidget extends StatelessWidget {
  final ShopServiceModel serviceModel;
  final int index;
  final ValueChanged onDelete;
  final Function onUpdate;
  final VoidCallback onTap;
  final VoidCallback onLongTap;

  const ShopServiceItemWidget(
      {super.key,
      required this.serviceModel,
      required this.index,
      required this.onDelete,
      required this.onUpdate,
      required this.onTap,
      required this.onLongTap});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: ValueKey(serviceModel),
        onDismissed: (dismisDirection) {},
        confirmDismiss: (dismisDirection) async {
          if (dismisDirection == DismissDirection.endToStart) {
            onUpdate(index, serviceModel);
          } else {
            onDelete(index);
          }
          return false;
        },
        background: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
              color: deleteColor, borderRadius: BorderRadius.circular(4)),
          child: Row(
            children: [
              const CustomSvgIcon(
                assetName: 'delete',
                color: Colors.white,
              ),
              const SizedBox(
                width: 12,
              ),
              CustomText(
                title: 'Delete'.tr(),
                fontColor: Colors.white,
                fontSize: 15,
              )
            ],
          ),
        ),
        secondaryBackground: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
              color: mainColor, borderRadius: BorderRadius.circular(4)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomText(
                title: 'Edit'.tr(),
                fontColor: Colors.white,
                fontSize: 15,
              ),
              const SizedBox(
                width: 12,
              ),
              const CustomSvgIcon(
                assetName: 'edit',
                color: Colors.white,
              ),
            ],
          ),
        ),
        child: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: onTap,
          onLongPress: onLongTap,
          child: Card(
            color: Theme.of(context).cardColor,
            surfaceTintColor: Colors.transparent,
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  CustomRoundedImage(
                    width: 64,
                    height: 64,
                    radius: 4,
                    url: serviceModel.images.isNotEmpty?serviceModel.images.first.image:null,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        title: serviceModel.getTitle(),
                        fontSize: 15,
                        fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,
                        maxLines: 2,
                      ),
                      SizedBox(
                        height: serviceModel.category != null &&
                                serviceModel.category!.id != 1
                            ? 4
                            : 0,
                      ),
                      if (serviceModel.category != null && serviceModel.category!.id != 1)
                        Column(
                          children: [
                            Row(children: [
                              CustomText(title: serviceModel.details.first.has_offer!=null&&serviceModel.details.first.has_offer!?CustomNumberFormat.format(serviceModel.details.first.new_price??0.00):CustomNumberFormat.format(serviceModel.details.first.price??0.00),fontColor: mainColor,fontWeight: FontWeight.bold,fontSize: 14,maxLines: 1,),
                              const SizedBox(width: 4,),
                              const CustomSvgIcon(assetName: 'sar',width: 14,height: 14,color: mainColor,),

                            ],),

                            if(serviceModel.details.first.has_offer!=null&&serviceModel.details.first.has_offer!)
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4,),

                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          CustomText(title:CustomNumberFormat.format(serviceModel.details.first.price??0.00),fontColor: greyColor,fontSize: 11,decoration: TextDecoration.lineThrough,maxLines: 1,),
                                          const SizedBox(width: 4,),
                                          const CustomSvgIcon(assetName: 'sar',width: 14,height: 14,color: greyColor,),

                                        ],),
                                      const SizedBox(width: 4,),
                                      CustomText(title: '${'Save2'.tr()} ${serviceModel.details.first.offer_value??0}',fontSize: 11,fontColor: discColor,),
                                      const SizedBox(width: 4,),
                                      serviceModel.details.first.offer_type=='value'?
                                      const CustomSvgIcon(assetName: 'sar',width: 14,height: 14,color: discColor,):
                                      const CustomText(title: '%',fontSize: 11,fontColor: discColor,),


                                    ],
                                  ),
                                  const SizedBox(height: 4,),

                                ],)
                          ],
                        )
                    ],
                  ))
                ],
              ),
            ),
          ),
        ));
  }
}
