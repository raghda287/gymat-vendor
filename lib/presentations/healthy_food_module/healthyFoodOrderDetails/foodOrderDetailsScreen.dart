import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
import '../foodReceiptDetailsScreen/foodReceiptDetailsScreen.dart';
import '../provider/food_order_provider.dart';

class FoodOrderDetailsScreen extends StatefulWidget {
  final num orderId;

  const FoodOrderDetailsScreen({super.key, required this.orderId});

  @override
  State<FoodOrderDetailsScreen> createState() => _FoodOrderDetailsScreenState();
}

class _FoodOrderDetailsScreenState extends State<FoodOrderDetailsScreen> {
  FoodOrderProvider provider = getIt();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    provider.initGymOrderDetails();
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
        body: Consumer<FoodOrderProvider>(
          builder: (context, provider, _) {
            return provider.isLoadingOrderDetails
                ? const Center(
                    child: LoadingIndicator(),
                  )
                : provider.foodOrderDetailsModel == null
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
                                          url: provider.foodOrderDetailsModel!
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
                                                      .foodOrderDetailsModel!
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
                                                  '${'Order Number:'.tr()} #${provider.foodOrderDetailsModel!.id ?? 0}',
                                              fontColor: greyColor,
                                            ),
                                          ],
                                        )),
                                        CustomButton(
                                          title: 'E-Receipt'.tr(),
                                          onTap: () {
                                            NavigatorHandler.push(
                                                FoodReceiptDetailsScreen(
                                              model: provider
                                                  .foodOrderDetailsModel!,
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
                                            flex: 1,
                                            child: CustomText(
                                              title:
                                                  'Expected pick up date'.tr(),
                                              fontSize: 13,
                                              fontColor: AppTheme.isDarkMode()
                                                  ? Colors.white
                                                  : Colors.black,
                                            )),
                                        Expanded(
                                            flex: 1,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                CustomText(
                                                  textAlign: TextAlign.end,
                                                  title:
                                                      '${provider.foodOrderDetailsModel?.order?.date ?? ''} ${provider.foodOrderDetailsModel?.order?.time ?? ''}',
                                                  fontSize: 12,
                                                  fontColor: AppTheme.isDarkMode()
                                                          ? Colors.white
                                                          : Colors.black,
                                                ),
                                                if (isDateOld(
                                                    provider
                                                        .foodOrderDetailsModel
                                                        ?.order
                                                        ?.date,
                                                    provider
                                                        .foodOrderDetailsModel
                                                        ?.order
                                                        ?.time,
                                                    provider
                                                        .foodOrderDetailsModel
                                                        ?.status))
                                                  CustomText(
                                                    textAlign: TextAlign.end,
                                                    title: ' (${'Expired'.tr()}) ',
                                                    fontColor: discColor,
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
                                      height: 140,
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Positioned(
                                              top: 4,
                                              child: CircleStepWidget(
                                                selected: isStepActive(
                                                    1,
                                                    provider.foodOrderDetailsModel
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
                                                        provider.foodOrderDetailsModel
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
                                                            provider.foodOrderDetailsModel
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
                                                    provider.foodOrderDetailsModel
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
                                                        provider.foodOrderDetailsModel
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
                                                            provider.foodOrderDetailsModel
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
                                                    provider.foodOrderDetailsModel
                                                            ?.status ??
                                                        ''),
                                              )),
                                          Positioned(
                                              top: 116,
                                              left: lang == 'ar' ? null : 24,
                                              right: lang == 'en' ? null : 24,
                                              child: CustomText(
                                                title:
                                                    'Your order has been prepared.'
                                                        .tr(),
                                                fontSize: 13,
                                                fontColor: isStepActive(
                                                        3,
                                                        provider.foodOrderDetailsModel
                                                                ?.status ??
                                                            '')
                                                    ? mainColor
                                                    : AppTheme.isDarkMode()
                                                        ? Colors.white
                                                        : Colors.black,
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
                                          children: [
                                            CustomText(
                                              title:
                                              CustomNumberFormat.format(provider.foodOrderDetailsModel!.total ?? 0),
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
                                          children: [
                                            CustomText(
                                              title:
                                              CustomNumberFormat.format(provider.foodOrderDetailsModel!.tax ?? 0),
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
                                          children: [
                                            CustomText(
                                              title:
                                              CustomNumberFormat.format(provider.foodOrderDetailsModel!.discount ?? 0),
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
                                          children: [
                                            CustomText(
                                              title:
                                              CustomNumberFormat.format(provider.foodOrderDetailsModel!.app_value ?? 0),
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
                                          children: [
                                            CustomText(
                                              title:
                                              CustomNumberFormat.format(provider.foodOrderDetailsModel!.grand_total ?? 0),
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
                          provider.foodOrderDetailsModel != null &&
                                  provider.foodOrderDetailsModel!.status ==
                                      'new'
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0, vertical: 12),
                                  child: Row(
                                    children: [
                                      if (!isDateOld(
                                          provider.foodOrderDetailsModel?.order
                                              ?.date,
                                          provider.foodOrderDetailsModel?.order
                                              ?.time,
                                          provider
                                              .foodOrderDetailsModel?.status))
                                        Expanded(
                                            child: CustomButton(
                                          title: 'Accept order'.tr(),
                                          onTap: () {
                                            if (isDateNew(provider
                                                .foodOrderDetailsModel
                                                ?.order
                                                ?.date)) {
                                              CustomScaffoldMessanger.showToast(
                                                  title:
                                                      'Please, Check pick up date'
                                                          .tr());
                                            } else {
                                              provider.updateOrderStatus(
                                                  widget.orderId, 'accepted');
                                            }
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
                              : provider.foodOrderDetailsModel != null && (provider.foodOrderDetailsModel!.status == 'accepted'||provider.foodOrderDetailsModel!.status =='preparing'||provider.foodOrderDetailsModel!.status =='done')
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0, vertical: 12),
                                      child: CustomButton(
                                        title: getNexTransStatus(provider.foodOrderDetailsModel!.status!),
                                        onTap: () {
                                          provider.updateOrderStatus(
                                              widget.orderId, getNexStatus(provider.foodOrderDetailsModel!.status!));
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



  bool isDateOld(String? date, String? time, String? status) {
    if (date != null && time != null && status != null) {
      DateTime now = DateTime.now();
      DateTime dateTime =
          DateFormat('yyyy-MM-dd HH:mm a', 'en').parse('$date $time');
      if (status == 'new') {
        if (dateTime.isBefore(now)) {
          return true;
        }
      }
    }

    return false;
  }

  bool isDateNew(String? date) {
    if (date != null) {
      DateTime d = DateTime.now();
      DateTime now = DateTime(d.year, d.month, d.day, 0, 0, 0, 0, 0);

      DateTime dateTime = DateFormat('yyyy-MM-dd', 'en').parse(date);
      if (dateTime.isAfter(now)) {
        return true;
      }
    }

    return false;
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
      }
    } else if (status == 'preparing') {
      if (step == 1) {
        return true;
      } else if (step == 2) {
        return true;
      } else if (step == 3) {
        return false;
      }
    } else if (status == 'done' || status == 'end') {
      if (step == 1) {
        return true;
      } else if (step == 2) {
        return true;
      } else if (step == 3) {
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

    } else if (status == 'done') {
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
      return 'end';
    }

    return '';
  }

}
