import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/data/models/user_model.dart';
import 'package:gymatvendor/presentations/shop_module/provider/shop_order_provider.dart';
import 'package:gymatvendor/presentations/widgets/dialogs/scaffold_messanger.dart';

import 'package:provider/provider.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../../core/navigator/navigator.dart';
import '../../gym_module/gymOrderDetailsScreen/widgets/calender.dart';
import '../../widgets/custom_button/custom_button.dart';
import '../../widgets/custom_svg/CustomSvgIcon.dart';
import '../../widgets/custom_text/custom_text.dart';

class ScheduledTimeWidget extends StatelessWidget {
  final num orderId;
  final AccountsModel market;

  const ScheduledTimeWidget({super.key, required this.market, required this.orderId});

  @override
  Widget build(BuildContext context) {

    return Consumer<ShopOrderProvider>(
      builder: (context,provider,_){
        return Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 64,
                  height: 4,
                  decoration: BoxDecoration(
                      color: greyColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    title: 'Schedule time'.tr(),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontColor: AppTheme.isDarkMode() ? Colors.white : Colors.black,
                  ),
                  IconButton(onPressed: (){
                    NavigatorHandler.pop();
                  }, icon: CustomSvgIcon(assetName: 'close2',color: AppTheme.isDarkMode()?Colors.white:Colors.black,))
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              AppCalender(
                workTimeList: const [],
                onDateSelected: (DateTime? date) {
                  provider.updateDeleiveryData(date);
                },
              ),
              const SizedBox(
                height: 16,
              ),

              CustomButton(
                  title: 'Done'.tr(),
                  onTap: () async {
                    if(provider.deliveryDateTime!=null){
                      await NavigatorHandler.pop();
                      await Future.delayed(const Duration(seconds: 1));
                      provider.updateOrderStatus(orderId, 'accepted');
                    }else{
                      CustomScaffoldMessanger.showToast(title: 'Selected delivery time'.tr());
                    }
                  }),
              const SizedBox(
                height: 12,
              ),
            ],
          ),
        );
      }
    );
  }


}
