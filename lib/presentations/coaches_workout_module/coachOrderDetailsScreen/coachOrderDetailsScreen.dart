import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/coachOrderDetailsScreen/widgets/startEndDateScreen.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/provider/coach_order_provider.dart';
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
import '../../widgets/custom_app_bar/custom_app_bar.dart';
import '../../widgets/custom_avatar/custom_avatar.dart';
import '../../widgets/custom_button/custom_button.dart';
import '../../widgets/custom_text/custom_text.dart';
import '../../widgets/loading_indicator/loading_indicator.dart';
import '../coachReceiptDetailsScreen/coachReceiptDetailsScreen.dart';

class CoachOrderDetailsScreen extends StatefulWidget {
  final num orderId;

  const CoachOrderDetailsScreen({super.key, required this.orderId});

  @override
  State<CoachOrderDetailsScreen> createState() => _CoachOrderDetailsScreenState();
}

class _CoachOrderDetailsScreenState extends State<CoachOrderDetailsScreen> {
  CoachOrderProvider provider = getIt();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    provider.initCoachOrderDetails();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      provider.getOrderDetails(widget.orderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          showToolBar: true,
          showBackArrow: true,
          isMainBack: true,
          title: 'Order details'.tr(),
          elevation: 1,
          bgColor: AppTheme.isDarkMode() ? dark : Colors.white,
        ),
        body: Consumer<CoachOrderProvider>(
          builder: (context, provider, _) {
            return provider.isLoadingOrderDetails
                ? const Center(
                    child: LoadingIndicator(),
                  )
                : provider.coachOrderDetailsModel == null
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
                                          borderColor: mainColor.withOpacity(.2),
                                          url: provider.coachOrderDetailsModel!
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
                                                      .coachOrderDetailsModel!
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
                                                  '${'Order Number:'.tr()} #${provider.coachOrderDetailsModel!.id ?? 0}',
                                              fontColor: greyColor,
                                            ),
                                          ],
                                        )),
                                        CustomButton(
                                          title: 'E-Receipt'.tr(),
                                          onTap: () {
                                            NavigatorHandler.push(
                                                CoachReceiptDetailsScreen(
                                              model: provider
                                                  .coachOrderDetailsModel!,
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
                                              CustomNumberFormat.format(provider.coachOrderDetailsModel!.total ?? 0),
                                              fontColor: AppTheme.isDarkMode()
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 13,
                                            ),
                                            const SizedBox(width: 4,),
                                            CustomSvgIcon(assetName: 'sar',width: 14,height: 14,color: AppTheme.isDarkMode()?Colors.white:Colors.black,),

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
                                              CustomNumberFormat.format(provider.coachOrderDetailsModel!.tax ?? 0),
                                              fontColor: AppTheme.isDarkMode()
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 13,
                                            ),
                                            const SizedBox(width: 4,),
                                            CustomSvgIcon(assetName: 'sar',width: 14,height: 14,color: AppTheme.isDarkMode()?Colors.white:Colors.black,),

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
                                              CustomNumberFormat.format(provider.coachOrderDetailsModel!.discount ?? 0),
                                              fontColor: AppTheme.isDarkMode()
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 13,
                                            ),
                                            const SizedBox(width: 4,),
                                            CustomSvgIcon(assetName: 'sar',width: 14,height: 14,color: AppTheme.isDarkMode()?Colors.white:Colors.black,),

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
                                              CustomNumberFormat.format(provider.coachOrderDetailsModel!.app_value ?? 0),
                                              fontColor: AppTheme.isDarkMode()
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 13,
                                            ),
                                            const SizedBox(width: 4,),
                                            CustomSvgIcon(assetName: 'sar',width: 14,height: 14,color: AppTheme.isDarkMode()?Colors.white:Colors.black,),

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
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),

                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CustomText(
                                              title:
                                              CustomNumberFormat.format(provider.coachOrderDetailsModel!.grand_total ?? 0),
                                              fontColor: AppTheme.isDarkMode()
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            const SizedBox(width: 4,),
                                            CustomSvgIcon(assetName: 'sar',width: 14,height: 14,color: AppTheme.isDarkMode()?Colors.white:Colors.black,),

                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          provider.coachOrderDetailsModel != null &&
                                  provider.coachOrderDetailsModel!.status == 'new'
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0,vertical: 12),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: CustomButton(
                                        title: 'Accept order'.tr(),
                                        onTap: () async {
                                          Map<String,dynamic>? data = await NavigatorHandler.push(const StartEndDateScreen());
                                          if(data!=null){
                                            String startDate = data['sDate'];
                                            String endDate = data['eDate'];
                                            provider.updateOrderStatus(widget.orderId, 'accepted', startDate,endDate);
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
                                          provider.updateOrderStatus(widget.orderId, 'refused', null,null);
                                        },
                                        fontColor: Colors.red,
                                        bg: greyColor.withOpacity(.2),

                                      ))
                                    ],
                                  ),
                                )
                              : provider.coachOrderDetailsModel != null &&
                                      provider.coachOrderDetailsModel!.status ==
                                          'accepted'
                                  ? Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 12),
                                    child: CustomButton(
                                        title: 'End order'.tr(),
                                        onTap: () {
                                          provider.updateOrderStatus(widget.orderId, 'end', null,null);
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

}
