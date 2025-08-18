import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';
import 'package:gymatvendor/presentations/widgets/custom_text_form/custom_text_form.dart';

class RestaurantSummryCost extends StatefulWidget {
  final String? dishFee;
  final String? deliveryFee;
  final String? total;
  final TextEditingController controller;

  const RestaurantSummryCost({super.key, this.dishFee, this.deliveryFee, this.total, required this.controller});

  @override
  State<RestaurantSummryCost> createState() => _RestaurantSummryCostState();
}

class _RestaurantSummryCostState extends State<RestaurantSummryCost> {
  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(title: 'Dish fee'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:greyColor,),
            CustomText(title: widget.dishFee!=null?'${widget.dishFee} ${'SAR'.tr()}':'',fontColor: AppTheme.isDarkMode()?Colors.white:greyColor,),

          ],
        ),
        const SizedBox(height: 12,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(title: 'Delivery fee'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:greyColor,),
            CustomText(title: widget.deliveryFee!=null?'${widget.deliveryFee} ${'SAR'.tr()}':'',fontColor: AppTheme.isDarkMode()?Colors.white:greyColor,),

          ],
        ),
        const SizedBox(height: 12,),
        CustomTextFormField(controller: widget.controller,hint: 'Special code'.tr(),bgColor: Colors.transparent,borderColor:greyColor.withOpacity(.3),height: 48,),
        const SizedBox(height: 12,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(title: 'Total'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:greyColor,),
            CustomText(title: widget.total!=null?'${widget.total} ${'SAR'.tr()}':'',fontColor: AppTheme.isDarkMode()?Colors.white:greyColor,),

          ],
        ),

      ],
    );
  }
}
