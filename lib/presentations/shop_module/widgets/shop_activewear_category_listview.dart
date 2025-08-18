import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/core/number_format/numberFormat.dart';
import 'package:gymatvendor/core/text_styles/text_styles.dart';
import 'package:gymatvendor/presentations/widgets/custom_network_image/custom_network_image.dart';
import 'package:gymatvendor/presentations/widgets/custom_rounded_image/custom_rounded_image.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

import '../../../core/constants/constants.dart';
import '../../../core/dimens/dimens.dart';
import '../../../core/navigator/navigator.dart';
import '../../../data/models/shop_service_model.dart';
import '../../../injection.dart';
import '../../../main.dart';
import '../../widgets/custom_svg/CustomSvgIcon.dart';
import '../provider/shop_services_provider.dart';
import '../shop_add_service_screen/shop_add_service_screen.dart';

class ShopActivewearCategoryListView extends StatelessWidget {
  final List<ShopServiceModel?> list;

  const ShopActivewearCategoryListView({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: list.length,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemBuilder: (context, index) {
        ShopServiceModel? model = list[index];
        if (model != null) {
          return InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              ShopServicesProvider shopServicesProvider = getIt();

              NavigatorHandler.push(ShopAddService(
                shopDepartmentModel:
                    shopServicesProvider.shopCategoryList.isEmpty
                        ? null
                        : shopServicesProvider
                            .shopCategoryList[
                                shopServicesProvider.selectedShopCategoryIndex]
                            .category,
                shopServiceModel: model,
              ));
            },
            onLongPress: () {
              showServiceActionSheet(model, index);
            },
            child: Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),border: Border.all(color: greyColor.withOpacity(0.2))),
              child: Column(
                children: [
                  Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: const BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(4),topLeft: Radius.circular(4))),
                    child: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: CustomNetworkImage(
                        url: model.images.isNotEmpty
                            ? model.images.first.image
                            : null,
                        boxFit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(child: Padding(

                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        CustomText(
                          title: model.getTitle(),
                          fontColor: AppTheme.isDarkMode() ? Colors.white : Colors.black,
                          maxLines: 2,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(children: [
                          CustomText(title: model.details.first.has_offer!=null&&model.details.first.has_offer!?CustomNumberFormat.format(model.details.first.new_price??0.00):CustomNumberFormat.format(model.details.first.price??0.00),fontColor: mainColor,fontWeight: FontWeight.bold,fontSize: 14,maxLines: 1,),
                          const SizedBox(width: 4,),
                          const CustomSvgIcon(assetName: 'sar',width: 14,height: 14,color: mainColor,),

                        ],),

                       if(model.details.first.has_offer!=null&&model.details.first.has_offer!)
                         Column(
                           mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    constraints: const BoxConstraints(maxWidth: 100),
                                    child: Row(
                                      children: [
                                      CustomText(title:CustomNumberFormat.format(model.details.first.price??0.00),fontColor: greyColor,fontSize: 11,decoration: TextDecoration.lineThrough,maxLines: 1,),
                                      const SizedBox(width: 4,),
                                        const CustomSvgIcon(assetName: 'sar',width: 14,height: 14,color: greyColor,),

                                    ],),
                                  ),
                                ),
                                const SizedBox(width: 4,),
                                Row(
                                  children: [
                                    CustomText(title: '${'Save2'.tr()} ${model.details.first.offer_value??0}',fontSize: 11,fontColor: discColor,),
                                    const SizedBox(width: 4,),
                                    model.details.first.offer_type=='value'?
                                    const CustomSvgIcon(assetName: 'sar',width: 14,height: 14,color: discColor,):
                                    const CustomText(title: '%',fontSize: 11,fontColor: discColor,),

                                  ],
                                ),

                              ],
                            ),
                            const SizedBox(height: 8,),

                          ],)
                      ],
                    ),
                  ))
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1 / 1.6),
    );
  }


  void createDeleteAlertDialog(Widget titleWidget,VoidCallback onDelete,VoidCallback onCancel) {
    showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            surfaceTintColor: Colors.transparent,
            backgroundColor: AppTheme.isDarkMode() ? dark : Colors.white,
            contentPadding: const EdgeInsets.all(12),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 12,
                ),
                titleWidget,
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: onCancel,
                        child: CustomText(
                          title: 'Cancel'.tr(),
                          fontSize: 14,
                          fontColor: greyColor,
                        )),
                    const SizedBox(
                      width: 12,
                    ),
                    TextButton(
                        onPressed:onDelete,
                        child: CustomText(
                          title: 'Delete'.tr(),
                          fontSize: 14,
                          fontColor: Colors.red,
                        )),
                  ],
                )
              ],
            ),
          );
        });
  }

  void showServiceActionSheet(ShopServiceModel model, int index) {
    showModalBottomSheet(
        isDismissible: true,
        backgroundColor: AppTheme.isDarkMode() ? dark : Colors.white,
        context: navigatorKey.currentContext!,
        builder: (context) {
          return SizedBox(
            width: Dimens.width,
            child: Padding(
              padding: EdgeInsets.only(
                  left: 12,
                  top: 12,
                  right: 12,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Center(
                    child: Container(
                      width: 54,
                      height: 4,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: AppTheme.isDarkMode()
                              ? greyColor.withOpacity(.2)
                              : greyColor.withOpacity(.5)),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  ListTile(
                    leading: CustomSvgIcon(
                      assetName: 'delete',
                      color:
                      AppTheme.isDarkMode() ? Colors.white : Colors.black,
                    ),
                    title: CustomText(
                      title: 'Delete'.tr(),
                      fontColor:
                      AppTheme.isDarkMode() ? Colors.white : Colors.black,
                      fontSize: 16,
                    ),
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () async {
                      NavigatorHandler.pop();
                      await Future.delayed(const Duration(milliseconds: 300));
                      createDeleteAlertDialog(Text.rich(TextSpan(text: '${'Delete'.tr()} ',
                          style: AppTextStyles().normalText(fontSize: 13).textColorNormal(AppTheme.isDarkMode()?greyColor:Colors.black),
                          children: [
                            TextSpan(text: model.trans_title??'',style: AppTextStyles().normalText(fontSize: 17).textColorBold(AppTheme.isDarkMode()?Colors.white:Colors.black))
                          ]
                      )), () async{
                        NavigatorHandler.pop();
                        await Future.delayed(const Duration(milliseconds: 300));
                        ShopServicesProvider shopServicesProvider = getIt();
                        shopServicesProvider.deleteService(model);

                      }, () { NavigatorHandler.pop();});

                    },
                  ),
                  ListTile(
                    leading: CustomSvgIcon(
                      assetName: 'edit2',
                      width: 18,
                      height: 18,
                      color:
                      AppTheme.isDarkMode() ? Colors.white : Colors.black,
                    ),
                    title: CustomText(
                      title: 'Edit'.tr(),
                      fontColor:
                      AppTheme.isDarkMode() ? Colors.white : Colors.black,
                      fontSize: 16,
                    ),
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () async{
                      await NavigatorHandler.pop();
                      await Future.delayed(const Duration(milliseconds: 200));
                      ShopServicesProvider shopServicesProvider = getIt();
                      NavigatorHandler.push( ShopAddService(shopDepartmentModel: shopServicesProvider.shopCategoryList.isEmpty?null:shopServicesProvider.shopCategoryList[shopServicesProvider.selectedShopCategoryIndex].category,shopServiceModel: model,));



                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
