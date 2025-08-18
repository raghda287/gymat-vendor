import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/injection.dart';
import 'package:gymatvendor/presentations/chat_module/provider/chat_provider.dart';
import 'package:gymatvendor/presentations/gym_module/gym_orders_screen/widgets/arrow_icon_gym.dart';
import 'package:gymatvendor/presentations/gym_module/gym_orders_screen/widgets/text_animation_widget.dart';
import 'package:gymatvendor/presentations/gym_module/provider/gym_order_provider.dart';
import 'package:gymatvendor/presentations/widgets/custom_svg/CustomSvgIcon.dart';

import '../../../../../data/models/generalOrderModel.dart';
import '../../../../core/app_colors/app_colors.dart';
import '../../../../core/app_theme/theme.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/number_format/numberFormat.dart';
import '../../../widgets/custom_avatar/custom_avatar.dart';
import '../../../widgets/custom_text/custom_text.dart';

class GymOrderItem extends StatelessWidget {
  final GeneralOrderModel model;
  final int index;

  const GymOrderItem({super.key, required this.model, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border:
            Border.all(color: AppTheme.isDarkMode() ? dark : dividerColor)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Row(
                children: [
                  CustomAvatar(
                    radius: 36,
                    url: model.user?.user?.photo,
                    borderColor: greyColor.withOpacity(.1),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: CustomText(
                                  title: model.user?.user?.name ?? '',
                                  fontColor: AppTheme.isDarkMode()
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  maxLines: 1,
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    title:
                                    '${'Order Number:'.tr()} #${model.id ?? 0}',
                                    fontColor: greyColor,
                                    fontSize: 12,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  ArrowIconGym(
                                    model: model,
                                    index: index,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          model.status=='accepted'?const TextAnimationWidget():CustomText(title: getOrderStatus(model.status??''),fontColor: model.status=='new'?greyColor:model.status=='end'?mainColor:model.status=='refused'?Colors.red:model.status=='canceled'?Colors.red:greyColor,fontSize: 13,),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  CustomText(
                                    title: '${'Phone number'.tr()} :',
                                    fontColor: AppTheme.isDarkMode()
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  CustomText(
                                    title:
                                    '${model.user?.user?.phone_code ?? ''}${model.user?.user?.phone ?? ''}',
                                    fontColor: greyColor,
                                    fontSize: 12,
                                  ),
                                ],
                              ),



                            ],
                          ),
                        ],
                      ))
                ],
              ),
            ),
            Visibility(
              visible: model.isExpanded,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Divider(
                    color: AppTheme.isDarkMode() ? dark : dividerColor,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: CustomText(
                      title: 'Order date and time'.tr(),
                      fontSize: 14,
                      fontColor:
                      mainColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: CustomText(
                      title: '${model.date??''} - ${model.time??''}',
                      fontSize: 12,
                      fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),

                  Divider(
                    color: AppTheme.isDarkMode() ? dark : dividerColor,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: CustomText(
                      title: 'Order summary'.tr(),
                      fontSize: 14,
                      fontColor:
                      AppTheme.isDarkMode() ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      children: [

                        Expanded(
                            flex: 1,
                            child: CustomText(title: 'Subtotal:'.tr(),fontSize: 14,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,)),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomText(textAlign: TextAlign.end,title:CustomNumberFormat.format(model.total??0),fontSize: 13,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,),
                            const SizedBox(width: 4,),

                            CustomSvgIcon(assetName: 'sar',width: 14,height: 14,color: AppTheme.isDarkMode()?Colors.white:Colors.black,),

                          ],
                        )
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      children: [

                        Expanded(child: CustomText(title: 'Tax:'.tr(),fontSize: 14,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,)),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomText(textAlign: TextAlign.end,title:CustomNumberFormat.format(model.tax??0),fontSize: 13,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,),
                            const SizedBox(width: 4,),

                            CustomSvgIcon(assetName: 'sar',width: 14,height: 14,color: AppTheme.isDarkMode()?Colors.white:Colors.black,),

                          ],
                        )

                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      children: [

                        Expanded(child: CustomText(title: 'Discount:'.tr(),fontSize: 14,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,)),

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomText(textAlign: TextAlign.end,title:CustomNumberFormat.format(model.discount??0),fontSize: 13,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,),
                            const SizedBox(width: 4,),

                            CustomSvgIcon(assetName: 'sar',width: 14,height: 14,color: AppTheme.isDarkMode()?Colors.white:Colors.black,),

                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      children: [

                        Expanded(

                            child: CustomText(title: 'Total:'.tr(),fontSize: 15,fontColor: mainColor,fontWeight: FontWeight.bold,)),

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomText(textAlign: TextAlign.end,title:CustomNumberFormat.format(model.grand_total??0),fontSize: 15,fontColor: mainColor,fontWeight: FontWeight.bold,),
                            const SizedBox(width: 4,),

                            const CustomSvgIcon(assetName: 'sar',width: 14,height: 14,color: mainColor,),

                          ],
                        )
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                ],
              ),
            ),
            SizedBox(
              width: 42,
              height: 42,
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: (){
                  ChatProvider chatProvider = getIt();
                  chatProvider.createChatRoom(model.user!.user!.id!, model.user!.user!.name, model.user!.user!.photo, null);
                },
                child: Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    color: AppTheme.isDarkMode()?dark:Colors.white,
                    elevation: 1,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CustomSvgIcon(assetName: 'chat',width: 12,height: 12,),
                    )),
              ),
            ),

          ],
        ));
  }
  String getOrderStatus(String status){
    if(status=='new'){
      return 'New order'.tr();

    }else if(status=='accepted'){
      return 'Active'.tr();

    }else if(status=='refused'){
      return 'Refused'.tr();

    }else if(status=='end'){
      return 'Completed2'.tr();

    }

    return '';
  }
}
