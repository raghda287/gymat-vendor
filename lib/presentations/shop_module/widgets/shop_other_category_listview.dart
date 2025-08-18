import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/main.dart';
import 'package:gymatvendor/presentations/shop_module/provider/shop_services_provider.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../../core/dimens/dimens.dart';
import '../../../core/navigator/navigator.dart';
import '../../../core/text_styles/text_styles.dart';
import '../../../data/models/shop_service_model.dart';
import '../../../injection.dart';
import '../../widgets/custom_svg/CustomSvgIcon.dart';
import '../../widgets/custom_text/custom_text.dart';
import '../../widgets/loading_indicator/loading_indicator.dart';
import '../shop_add_service_screen/shop_add_service_screen.dart';
import 'shop_service_item_widget.dart';

class ShopOtherCategoryListView extends StatelessWidget {
  final List<ShopServiceModel?> list;
  const ShopOtherCategoryListView({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (context, index) {
          ShopServiceModel? model = list[index];
          if (model == null) {
            return const LoadingIndicator(width: 32,stroke: 3,);
          } else {
            return ShopServiceItemWidget(
              serviceModel: model,
              index: index,
              onUpdate: (int index,ShopServiceModel model) async {
                await Future.delayed(const Duration(milliseconds: 300));

                ShopServicesProvider shopServicesProvider = getIt();
                NavigatorHandler.push( ShopAddService(shopDepartmentModel: shopServicesProvider.shopCategoryList.isEmpty?null:shopServicesProvider.shopCategoryList[shopServicesProvider.selectedShopCategoryIndex].category,shopServiceModel: model,));

              },
              onDelete: (index) async{
                await Future.delayed(const Duration(milliseconds: 300));
                createDeleteAlertDialog(Text.rich(TextSpan(text: '${'Delete'.tr()} ',
                    style: AppTextStyles().normalText(fontSize: 13).textColorNormal(AppTheme.isDarkMode()?greyColor:Colors.black),
                    children: [
                      TextSpan(text: model.getTitle()??'',style: AppTextStyles().normalText(fontSize: 17).textColorBold(AppTheme.isDarkMode()?Colors.white:Colors.black))
                    ]
                )), () {
                  NavigatorHandler.pop();
                  ShopServicesProvider shopServicesProvider = getIt();
                  shopServicesProvider.deleteService(model);
                }, () { NavigatorHandler.pop();});
              },
              onTap: () {
                ShopServicesProvider shopServicesProvider = getIt();

                NavigatorHandler.push( ShopAddService(shopDepartmentModel: shopServicesProvider.shopCategoryList.isEmpty?null:shopServicesProvider.shopCategoryList[shopServicesProvider.selectedShopCategoryIndex].category,shopServiceModel: model,));

              },
              onLongTap: () {
                showServiceActionSheet(model,index);
              },
            );
          }
        });
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
