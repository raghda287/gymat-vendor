import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/core/constants/constants.dart';
import 'package:gymatvendor/data/models/service_model.dart';
import 'package:gymatvendor/presentations/widgets/custom_rounded_image/custom_rounded_image.dart';
import 'package:gymatvendor/presentations/widgets/custom_svg/CustomSvgIcon.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

class ServiceItemWidget extends StatelessWidget {
  final ServiceModel serviceModel;
  final int index;
  final ValueChanged onDelete;
  final Function onUpdate;
  final VoidCallback onTap;
  final VoidCallback onLongTap;

  const ServiceItemWidget(
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
                    height: 48,
                    radius: 4,
                    url: serviceModel.photo,
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
                        fontColor: mainColor,
                      ),
                      const SizedBox(height: 4,),

                      SizedBox(height: serviceModel.category != null && serviceModel.category!.id != 1 ? 4 : 0,),
                      if(serviceModel.category != null && serviceModel.category!.id != 1) Row(
                          children: [

                            CustomText(
                              title: '${formatNumber(serviceModel.has_offer!=null&&serviceModel.has_offer!?serviceModel.new_price??0.00:serviceModel.price ?? 0.00)}',
                              fontSize: 14,
                              fontColor:AppTheme.isDarkMode()
                                  ? Colors.white
                                  : Colors.black,
                              maxLines: 1,
                              fontWeight: FontWeight.bold,

                            ),
                            const SizedBox(
                              width: 4,
                            ),

                            CustomSvgIcon(assetName: 'sar',width: 14,height: 14,color: AppTheme.isDarkMode()?Colors.white:Colors.black,),


                          ],
                        ),
                      if(serviceModel.has_offer!=null&&serviceModel.has_offer!)Column(
                        crossAxisAlignment: CrossAxisAlignment.start,children: [
                        const SizedBox(height: 4,),

                        Row(
                          children: [
                            CustomText(
                              title: '${formatNumber(serviceModel.price ?? 0.00)}',
                              fontSize: 11,
                              fontColor: greyColor,
                              maxLines: 1,
                              decoration: TextDecoration.lineThrough,

                            ),
                            const SizedBox(width: 4,),

                            const CustomSvgIcon(assetName: 'sar',width: 14,height: 14,color: greyColor,),


                            const SizedBox(width: 8,),
                            Row(children: [
                              CustomText(title: '${'Save2'.tr()} ${serviceModel.offer_value??0}',fontSize: 11,fontColor: discColor,),
                              serviceModel.offer_type=='value'?
                              const Row(
                                children: [
                                  SizedBox(width: 4,),
                                  CustomSvgIcon(assetName: 'sar',width: 14,height: 14,color: discColor,),
                                ],
                              ) :const CustomText(title: ' % ',fontSize: 11,fontColor: discColor,),

                            ],)
                          ],
                        ),

                      ],)
                    ],
                  ))
                ],
              ),
            ),
          ),
        ));
  }
}
