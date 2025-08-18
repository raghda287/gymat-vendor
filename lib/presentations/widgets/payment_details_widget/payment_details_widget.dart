import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/constants/constants.dart';
import 'package:gymatvendor/core/dimens/dimens.dart';
import 'package:gymatvendor/presentations/widgets/card_text_form/card_month_text_form.dart';
import 'package:gymatvendor/presentations/widgets/custom_button/custom_button.dart';
import 'package:gymatvendor/presentations/widgets/custom_svg/CustomSvgIcon.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../../core/navigator/navigator.dart';
import '../../../injection.dart';
import '../../ads_module/ad_provider/ad_provider.dart';
import '../card_text_form/card_number_text_form.dart';
import '../custom_text/custom_text.dart';
import '../custom_text_form/custom_text_form.dart';
import 'pay_icon_widget.dart';
import 'restaurant_summry_cost.dart';

class PaymentDetailsWidget extends StatefulWidget {
  final String adOrOrder;

  const PaymentDetailsWidget({super.key, required this.adOrOrder});

  @override
  State<PaymentDetailsWidget> createState() => _PaymentDetailsWidgetState();
}

class _PaymentDetailsWidgetState extends State<PaymentDetailsWidget> {
  String? paymentType = 'visa';
  final TextEditingController _nameOfCard = TextEditingController();
  final TextEditingController _cardNumber = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _discountCodeController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: 24,
          right: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        constraints: BoxConstraints(
            minHeight: Dimens.height * .88, maxHeight: Dimens.height * .88),
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            Center(
              child: Container(
                width: 60,
                height: 4,
                decoration: BoxDecoration(
                    color: AppTheme.isDarkMode()
                        ? Colors.black
                        : greyColor.withOpacity(.3),
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    width: 24,
                  ),
                  CustomText(
                    title: 'Payment'.tr(),
                    fontSize: 16,
                    fontColor:
                        AppTheme.isDarkMode() ? Colors.white : Colors.black,
                  ),
                  IconButton(
                      onPressed: () {
                        NavigatorHandler.pop();
                      },
                      icon: Icon(
                        Icons.close,
                        color:
                            AppTheme.isDarkMode() ? Colors.white : Colors.black,
                      ))
                ],
              ),
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Center(
                    child: CustomText(
                      title: 'Credit / Debit card payment'.tr(),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontColor:
                          AppTheme.isDarkMode() ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 36,
                  ),
                  if (widget.adOrOrder == OrderOrAd.order.name)
                    RestaurantSummryCost(
                      dishFee: '0.0',
                      deliveryFee: '0.0',
                      total: '0.0',
                      controller: _discountCodeController,
                    ),
                  if (widget.adOrOrder == OrderOrAd.order.name)
                    const SizedBox(
                      height: 24,
                    ),
                  CustomText(
                    title: 'Payment methods'.tr(),
                    fontColor:
                        AppTheme.isDarkMode() ? Colors.white : Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      if (Platform.isIOS)
                        PayIconWidget(
                          assetName: 'apple_pay',
                          bg: greyColor.withOpacity(.2),
                          onTap: () {
                            paymentType = 'apple_pay';
                            setState(() {});
                          },
                        ),
                      if (Platform.isIOS)
                        const SizedBox(
                          width: 8,
                        ),
                      PayIconWidget(
                        assetName: 'mastercard',
                        bg: mastercard,
                        onTap: () {
                          paymentType = 'mastercard';
                          setState(() {});
                        },
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      PayIconWidget(
                        assetName: 'visa',
                        bg: visa,
                        onTap: () {
                          paymentType = 'visa';
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 36,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        title: 'Name of card'.tr(),
                        fontColor:
                            AppTheme.isDarkMode() ? Colors.white : Colors.black,
                        fontSize: 14,
                      ),
                      if (paymentType != null)
                        PayIconWidget(
                          assetName: paymentType == 'visa'
                              ? 'visa'
                              : paymentType == 'mastercard'
                                  ? 'mastercard'
                                  : 'apple_pay',
                          bg: paymentType == 'visa'
                              ? visa
                              : paymentType == 'mastercard'
                                  ? mastercard
                                  : greyColor.withOpacity(.2),
                          onTap: () {},
                        ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  CustomTextFormField(
                    controller: _nameOfCard,
                    hint: 'First and last name'.tr(),
                    bgColor: Colors.transparent,
                    borderColor: greyColor.withOpacity(.3),
                    height: 48,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  CustomText(
                    title: 'Card number'.tr(),
                    fontColor:
                        AppTheme.isDarkMode() ? Colors.white : Colors.black,
                    fontSize: 14,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  CardNumberWidget(
                      controller: _cardNumber,
                      hint: 'xxxx xxxx xxxx xxxx',
                      height: 48,
                      bgColor: Colors.transparent,
                      borderColor: greyColor.withOpacity(.3), onChange: (String value) {  },),
                  const SizedBox(
                    height: 12,
                  ),
                  CustomText(
                    title: 'Expired date :'.tr(),
                    fontColor:
                        AppTheme.isDarkMode() ? Colors.white : Colors.black,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: CardMonthWidget(
                        hint: 'MM'.tr(),
                        bgColor: Colors.transparent,
                        borderColor: greyColor.withOpacity(.3),
                        height: 48,
                        controller: _monthController,
                        onChange: (value) {
                          if (value != null) {
                            int val = int.parse(value);
                            if (val > 12) {
                              _monthController.text = '12';
                            } else if (value == '00') {
                              _monthController.text = '01';
                            }
                          }
                        },
                        maxLength: 2,
                      )),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: CustomText(
                          title: '/',
                          fontColor: AppTheme.isDarkMode()
                              ? Colors.white
                              : Colors.black,
                          fontSize: 22,
                        ),
                      ),
                      Expanded(
                          child: CardMonthWidget(
                        hint: 'yyyy'.tr(),
                        bgColor: Colors.transparent,
                        borderColor: greyColor.withOpacity(.3),
                        height: 48,
                        controller: _yearController,
                        onChange: (value) {
                          if (value != null) {
                            int val = int.parse(value);
                            if (value.toString().length == 4) {
                              int maxYear = getCurrentYear() + 19;

                              if (val < getCurrentYear()) {
                                _yearController.text = '${getCurrentYear()}';
                              } else if (val > maxYear) {
                                _yearController.text = '$maxYear';
                              }
                            }
                          }
                        },
                        maxLength: 4,
                      )),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  CustomText(
                    title: 'CVV',
                    fontColor:
                        AppTheme.isDarkMode() ? Colors.white : Colors.black,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  CardMonthWidget(
                    hint: 'CVV',
                    bgColor: Colors.transparent,
                    borderColor: greyColor.withOpacity(.3),
                    height: 48,
                    controller: _cvvController,
                    onChange: (value) {},
                    maxLength: 3,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  CustomButton(
                      title: 'Pay now'.tr().toUpperCase(),
                      radius: 28,
                      onTap: () async {
                        AdProvider adProvider = getIt();
                        bool value = await adProvider.checkPayment(
                            OrderOrAd.ad.name,
                            _discountCodeController.text,
                            paymentType!,
                            _nameOfCard.text,
                            _cardNumber.text,
                            _monthController.text,
                            _yearController.text,
                            _cvvController.text);
                        if (value) {
                          NavigatorHandler.pop();
                          openSuccessSheet();
                        }
                      }),
                  const SizedBox(
                    height: 24,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void openSuccessSheet() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 16,
                ),
                Center(
                  child: Container(
                    width: 60,
                    height: 4,
                    decoration: BoxDecoration(
                        color: AppTheme.isDarkMode()
                            ? Colors.black
                            : greyColor.withOpacity(.3),
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 24,
                      ),
                      CustomText(
                        title: 'Payment'.tr(),
                        fontSize: 16,
                        fontColor:
                            AppTheme.isDarkMode() ? Colors.white : Colors.black,
                      ),
                      IconButton(
                          onPressed: () {
                            NavigatorHandler.pop();
                          },
                          icon: Icon(
                            Icons.close,
                            color: AppTheme.isDarkMode()
                                ? Colors.white
                                : Colors.black,
                          ))
                    ],
                  ),
                ),
                const CustomSvgIcon(
                  assetName: 'success',
                  width: 70,
                  height: 70,
                ),
                const SizedBox(
                  height: 36,
                ),
                CustomText(
                  title: 'Thank’s for your order'.tr(),
                  fontSize: 22,
                  fontColor:
                      AppTheme.isDarkMode() ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(
                  height: 4,
                ),
                CustomText(
                  title: 'Your payment has been confirmed.'.tr(),
                  fontSize: 14,
                  fontColor: greyColor,
                ),
                const SizedBox(
                  height: 36,
                ),
                CustomButton(
                    title: 'Done'.tr(),
                    radius: 28,
                    fontSize: 16,
                    onTap: () {
                      NavigatorHandler.pop();
                    }),
                const SizedBox(
                  height: 12,
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  onTap: () {
                    NavigatorHandler.pop();
                    NavigatorHandler.pop();
                  },
                  child: CustomText(
                    title: 'Back to home page'.tr(),
                    fontColor: greyColor,
                  ),
                ),
                const SizedBox(
                  height: 36,
                ),
              ],
            ),
          );
        });
  }
}
