import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/data/models/user_model.dart';
import 'package:gymatvendor/presentations/gym_module/gymOrderDetailsScreen/widgets/calender.dart';
import 'package:gymatvendor/presentations/gym_module/provider/gym_order_provider.dart';
import 'package:gymatvendor/presentations/widgets/custom_svg/CustomSvgIcon.dart';
import 'package:gymatvendor/presentations/widgets/dialogs/scaffold_messanger.dart';

import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../../core/navigator/navigator.dart';
import '../../../core/number_format/numberFormat.dart';
import '../../../injection.dart';
import '../../../main.dart';
import '../../ads_module/ad_details_screen/widgets/circle_step_widget.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';
import '../../widgets/custom_avatar/custom_avatar.dart';
import '../../widgets/custom_button/custom_button.dart';
import '../../widgets/custom_text/custom_text.dart';
import '../../widgets/loading_indicator/loading_indicator.dart';
import '../provider/shop_order_provider.dart';
import '../shop_receipt_details_screen/shopReceiptDetailsScreen.dart';
import '../widgets/scheduled_time_sheet_widget.dart';

class ShopOrderDetailsScreen extends StatefulWidget {
  final num orderId;

  const ShopOrderDetailsScreen({super.key, required this.orderId});

  @override
  State<ShopOrderDetailsScreen> createState() => _ShopOrderDetailsScreenState();
}

class _ShopOrderDetailsScreenState extends State<ShopOrderDetailsScreen> {
  ShopOrderProvider provider = getIt();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    provider.initShopOrderDetails();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      provider.getOrderDetails(widget.orderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    String lang = context.locale.languageCode;

    return Scaffold(
        appBar: CustomAppBar(
          showToolBar: true,
          showBackArrow: true,
          isMainBack: true,
          title: 'Order details'.tr(),
          elevation: 1,
          bgColor: AppTheme.isDarkMode() ? dark : Colors.white,
        ),
        body: Consumer<ShopOrderProvider>(
          builder: (context, provider, _) {
            return provider.isLoadingOrderDetails
                ? const Center(
                    child: LoadingIndicator(),
                  )
                : provider.shopOrderDetailsModel == null
                    ? const SizedBox()
                    : Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomAvatar(
                                          radius: 75,
                                          borderWidth: .5,
                                          borderColor:
                                              mainColor.withOpacity(.2),
                                          url: provider.shopOrderDetailsModel!
                                              .market?.logo,
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                              title: provider
                                                      .shopOrderDetailsModel!
                                                      .market
                                                      ?.business_name ??
                                                  '',
                                              fontColor: AppTheme.isDarkMode()
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 15,
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            CustomText(
                                              title:
                                                  '${'Order Number:'.tr()} #${provider.shopOrderDetailsModel!.id ?? 0}',
                                              fontColor: greyColor,
                                            ),
                                          ],
                                        )),
                                        CustomButton(
                                          title: 'E-Receipt'.tr(),
                                          onTap: () {
                                            NavigatorHandler.push(
                                               ShopReceiptDetailsScreen(
                                              model: provider
                                                  .shopOrderDetailsModel!,
                                            ));
                                          },
                                          bg: mainColor,
                                          fontColor: Colors.white,
                                          fontSize: 11,
                                          width: 80,
                                          height: 42,
                                          radius: 4,
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Divider(
                                      color: AppTheme.isDarkMode()
                                          ? dark
                                          : inputBg,
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 3,
                                            child: CustomText(
                                              title:
                                                  'Expected delivery date'.tr(),
                                              fontSize: 14,
                                              fontColor: AppTheme.isDarkMode()
                                                  ? Colors.white
                                                  : Colors.black,
                                            )),
                                        Expanded(
                                            flex: 2,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                CustomText(
                                                  textAlign: TextAlign.end,
                                                  title:
                                                      provider.shopOrderDetailsModel?.order?.delivery_date ?? '',
                                                  fontSize: 13,
                                                  fontColor: AppTheme.isDarkMode()
                                                          ? Colors.white
                                                          : Colors.black,
                                                ),

                                              ],
                                            ))
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Divider(
                                      color: AppTheme.isDarkMode()
                                          ? dark
                                          : inputBg,
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),

                                    SizedBox(
                                      height: 200,
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Positioned(
                                              top: 4,
                                              child: CircleStepWidget(
                                                selected: isStepActive(
                                                    1,
                                                    provider.shopOrderDetailsModel
                                                        ?.status ??
                                                        ''),
                                              )),
                                          Positioned(
                                              left: lang == 'ar' ? null : 24,
                                              right: lang == 'en' ? null : 24,
                                              child: CustomText(
                                                title:
                                                'Your order has been accepted.'
                                                    .tr(),
                                                fontSize: 13,
                                                fontColor: isStepActive(
                                                    1,
                                                    provider.shopOrderDetailsModel
                                                        ?.status ??
                                                        '')
                                                    ? mainColor
                                                    : AppTheme.isDarkMode()
                                                    ? Colors.white
                                                    : Colors.black,
                                              )),
                                          Positioned(
                                              top: 16,
                                              left: lang == 'ar' ? null : 5.5,
                                              right: lang == 'en' ? null : 5.5,
                                              child: Container(
                                                width: 1,
                                                height: 46,
                                                decoration: BoxDecoration(
                                                    color: isStepActive(
                                                        1,
                                                        provider.shopOrderDetailsModel
                                                            ?.status ??
                                                            '')
                                                        ? mainColor
                                                        : AppTheme.isDarkMode()
                                                        ? Colors.white
                                                        : greyColor
                                                        .withOpacity(
                                                        .3),
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        .5)),
                                              )),


                                          Positioned(
                                              top: 62,
                                              child: CircleStepWidget(
                                                selected: isStepActive(
                                                    2,
                                                    provider.shopOrderDetailsModel
                                                        ?.status ??
                                                        ''),
                                              )),
                                          Positioned(
                                              top: 58,
                                              left: lang == 'ar' ? null : 24,
                                              right: lang == 'en' ? null : 24,
                                              child: CustomText(
                                                title: 'Preparing order'.tr(),
                                                fontSize: 13,
                                                fontColor: isStepActive(
                                                    2,
                                                    provider.shopOrderDetailsModel
                                                        ?.status ??
                                                        '')
                                                    ? mainColor
                                                    : AppTheme.isDarkMode()
                                                    ? Colors.white
                                                    : Colors.black,
                                              )),
                                          Positioned(
                                              top: 74,
                                              left: lang == 'ar' ? null : 5.5,
                                              right: lang == 'en' ? null : 5.5,
                                              child: Container(
                                                width: 1,
                                                height: 46,
                                                decoration: BoxDecoration(
                                                    color: isStepActive(
                                                        2,
                                                        provider.shopOrderDetailsModel
                                                            ?.status ??
                                                            '')
                                                        ? mainColor
                                                        : AppTheme.isDarkMode()
                                                        ? Colors.white
                                                        : greyColor
                                                        .withOpacity(
                                                        .3),
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        .5)),
                                              )),


                                          Positioned(
                                              top: 120,
                                              child: CircleStepWidget(
                                                selected: isStepActive(
                                                    3,
                                                    provider.shopOrderDetailsModel
                                                        ?.status ??
                                                        ''),
                                              )),
                                          Positioned(
                                              top: 116,
                                              left: lang == 'ar' ? null : 24,
                                              right: lang == 'en' ? null : 24,
                                              child: CustomText(
                                                title: 'Your order has been prepared.'.tr(),
                                                fontSize: 13,
                                                fontColor: isStepActive(
                                                    3,
                                                    provider.shopOrderDetailsModel
                                                        ?.status ??
                                                        '')
                                                    ? mainColor
                                                    : AppTheme.isDarkMode()
                                                    ? Colors.white
                                                    : Colors.black,
                                              )),
                                          Positioned(
                                              top: 132,
                                              left: lang == 'ar' ? null : 5.5,
                                              right: lang == 'en' ? null : 5.5,
                                              child: Container(
                                                width: 1,
                                                height: 46,
                                                decoration: BoxDecoration(
                                                    color: isStepActive(
                                                        3,
                                                        provider.shopOrderDetailsModel
                                                            ?.status ??
                                                            '')
                                                        ? mainColor
                                                        : AppTheme.isDarkMode()
                                                        ? Colors.white
                                                        : greyColor
                                                        .withOpacity(
                                                        .3),
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        .5)),
                                              )),


                                          Positioned(
                                              top: 178,
                                              child: CircleStepWidget(
                                                selected: isStepActive(
                                                    4,
                                                    provider.shopOrderDetailsModel
                                                        ?.status ??
                                                        ''),
                                              )),
                                          Positioned(
                                              top: 172,
                                              left: lang == 'ar' ? null : 24,
                                              right: lang == 'en' ? null : 24,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  CustomText(
                                                    title:
                                                    'Your order has been shipped'.tr(),
                                                    fontSize: 13,
                                                    fontColor: isStepActive(
                                                        4,
                                                        provider.shopOrderDetailsModel
                                                            ?.status ??
                                                            '')
                                                        ? mainColor
                                                        : AppTheme.isDarkMode()
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                  const SizedBox(height: 4,),
                                                  CustomText(
                                                    title: 'Delivery is on way'.tr(),
                                                    fontSize: 11,
                                                    fontColor: greyColor,
                                                  ),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ),


                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Divider(
                                      color: AppTheme.isDarkMode()
                                          ? dark
                                          : inputBg,
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    CustomText(
                                      title: 'Order summary'.tr(),
                                      fontColor: AppTheme.isDarkMode()
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomText(
                                          title: 'Subtotal:'.tr(),
                                          fontColor: AppTheme.isDarkMode()
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 13,
                                        ),


                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CustomText(
                                              title:
                                              CustomNumberFormat.format(provider.shopOrderDetailsModel!.total ?? 0),
                                              fontColor: AppTheme.isDarkMode()
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 13,
                                            ),
                                            const SizedBox(width: 4,),
                                             CustomSvgIcon(assetName: 'sar',width: 14,height: 14,color: AppTheme.isDarkMode()
                                                ? Colors.white
                                                : Colors.black,),

                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomText(
                                          title: 'Tax:'.tr(),
                                          fontColor: AppTheme.isDarkMode()
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 13,
                                        ),

                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CustomText(
                                              title:
                                              CustomNumberFormat.format(provider.shopOrderDetailsModel!.tax ?? 0),
                                              fontColor: AppTheme.isDarkMode()
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 13,
                                            ),
                                            const SizedBox(width: 4,),
                                            CustomSvgIcon(assetName: 'sar',width: 14,height: 14,color: AppTheme.isDarkMode()
                                                ? Colors.white
                                                : Colors.black,),

                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomText(
                                          title: 'Discount:'.tr(),
                                          fontColor: AppTheme.isDarkMode()
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 13,
                                        ),

                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CustomText(
                                              title:
                                              CustomNumberFormat.format(provider.shopOrderDetailsModel!.discount ?? 0),
                                              fontColor: AppTheme.isDarkMode()
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 13,
                                            ),
                                            const SizedBox(width: 4,),
                                            CustomSvgIcon(assetName: 'sar',width: 14,height: 14,color: AppTheme.isDarkMode()
                                                ? Colors.white
                                                : Colors.black,),

                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomText(
                                          title: 'Service Fees'.tr(),
                                          fontColor: AppTheme.isDarkMode()
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 13,
                                        ),

                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CustomText(
                                              title:
                                              CustomNumberFormat.format(provider.shopOrderDetailsModel!.app_value ?? 0),
                                              fontColor: AppTheme.isDarkMode()
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 13,
                                            ),
                                            const SizedBox(width: 4,),
                                            CustomSvgIcon(assetName: 'sar',width: 14,height: 14,color: AppTheme.isDarkMode()
                                                ? Colors.white
                                                : Colors.black,),

                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomText(
                                          title: 'Total:'.tr(),
                                          fontColor: AppTheme.isDarkMode()
                                              ? mainColor
                                              : Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),


                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CustomText(
                                              title:
                                              CustomNumberFormat.format(provider.shopOrderDetailsModel!.grand_total ?? 0),
                                              fontColor: AppTheme.isDarkMode()
                                                  ? mainColor
                                                  : Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            const SizedBox(width: 4,),
                                            CustomSvgIcon(assetName: 'sar',width: 14,height: 14,color: AppTheme.isDarkMode()
                                                ? mainColor
                                                : Colors.black,),

                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          provider.shopOrderDetailsModel != null &&
                                  provider.shopOrderDetailsModel!.status ==
                                      'new'
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0, vertical: 12),
                                  child: Row(
                                    children: [
                                        Expanded(
                                            child: CustomButton(
                                          title: 'Accept order'.tr(),
                                          onTap: () {
                                            showDeliveryDateSheet(provider.shopOrderDetailsModel!.market!,provider.shopOrderDetailsModel!.id!);
                                          },
                                          fontColor: Colors.white,
                                          bg: mainColor,
                                        )),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      Expanded(
                                          child: CustomButton(
                                        title: 'Refuse order'.tr(),
                                        onTap: () {
                                          provider.updateOrderStatus(
                                              widget.orderId, 'refused');
                                        },
                                        fontColor: Colors.red,
                                        bg: greyColor.withOpacity(0.2),
                                      ))
                                    ],
                                  ),
                                )
                              : provider.shopOrderDetailsModel != null && (provider.shopOrderDetailsModel!.status == 'accepted'||provider.shopOrderDetailsModel!.status =='preparing'||provider.shopOrderDetailsModel!.status =='done')
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0, vertical: 12),
                                      child: CustomButton(
                                        title: getNexTransStatus(provider.shopOrderDetailsModel!.status!),
                                        onTap: () {
                                          provider.updateOrderStatus(
                                              widget.orderId, getNexStatus(provider.shopOrderDetailsModel!.status!));
                                        },
                                        fontColor: Colors.white,
                                        bg: mainColor,
                                      ),
                                    )
                                  : const SizedBox()
                        ],
                      );
          },
        ));
  }




  void showDeliveryDateSheet(AccountsModel market,num orderId){
    provider.updateDeleiveryData(DateTime.now());
    showModalBottomSheet(
        isScrollControlled: true,
        constraints:
        const BoxConstraints(minWidth: double.infinity),
        backgroundColor:
        AppTheme.isDarkMode() ? inputBgDark : Colors.white,
        context: navigatorKey.currentContext!,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24))),
        builder: (context) {
          return  ScheduledTimeWidget(market: market,orderId: orderId,);
        });
  }

  bool isStepActive(int step, String status) {
    if (status == 'new') {
      if (step == 1) {
        return false;
      } else if (step == 2) {
        return false;
      } else if (step == 3) {
        return false;
      }
    } else if (status == 'accepted') {
      if (step == 1) {
        return true;
      } else if (step == 2) {
        return false;
      } else if (step == 3) {
        return false;
      }else if (step == 4) {
        return false;
      }
    } else if (status == 'preparing') {
      if (step == 1) {
        return true;
      } else if (step == 2) {
        return true;
      } else if (step == 3) {
        return false;
      }
      else if (step == 4) {
        return false;
      }
    }else if (status == 'on_way') {
      if (step == 1) {
        return true;
      } else if (step == 2) {
        return true;
      } else if (step == 3) {
        return true;
      }
      else if (step == 4) {
        return true;
      }
    }

    else if (status == 'done' || status == 'end') {
      if (step == 1) {
        return true;
      } else if (step == 2) {
        return true;
      } else if (step == 3) {
        return true;
      }else if (step == 4) {
        return true;
      }
    } else {
      return false;
    }

    return false;
  }

  String getNexTransStatus(String status) {
    if (status == 'accepted') {
      return 'Prepare order'.tr();
    } else if (status == 'preparing') {
      return 'Prepared'.tr();

    }else if (status == 'preparing') {
      return 'Prepared'.tr();

    } else if (status == 'done') {
      return 'Order has been shipped'.tr();

    }else if (status == 'on_way') {
      return 'End order'.tr();
    }

    return '';
  }

  String getNexStatus(String status) {
    if (status == 'accepted') {
      return 'preparing';
    } else if (status == 'preparing') {
      return 'done';

    } else if (status == 'done') {
      return 'on_way';
    }else if (status == 'on_way') {
      return 'end';
    }

    return '';
  }

}
