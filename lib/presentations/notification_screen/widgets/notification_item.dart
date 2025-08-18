import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/core/dateFormat/dateFormat.dart';
import 'package:gymatvendor/core/navigator/navigator.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/coachOrderDetailsScreen/coachOrderDetailsScreen.dart';
import 'package:gymatvendor/presentations/gym_module/gymOrderDetailsScreen/gymOrderDetailsScreen.dart';
import 'package:gymatvendor/presentations/healthcub_spa_module/spaOrderDetailsScreen/spaOrderDetailsScreen.dart';
import 'package:gymatvendor/presentations/healthy_food_module/healthyFoodOrderDetails/foodOrderDetailsScreen.dart';
import 'package:gymatvendor/presentations/profile_module/provider/profile_provider.dart';
import 'package:gymatvendor/presentations/shop_module/shop_order_details_screen/shopOrderDetailsScreen.dart';
import 'package:gymatvendor/presentations/sport_field_module/sportsFieldOrderDetailsScreen/sportsFieldOrderDetailsScreen.dart';
import 'package:gymatvendor/presentations/widgets/custom_svg/CustomSvgIcon.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

import '../../../core/utils/preferences.dart';
import '../../../data/models/notificationModel.dart';
import '../../../data/models/user_model.dart';
import '../../../injection.dart';
import '../../auth_module/provider/auth_provider.dart';
enum NotificationType{
  order,
  liveSessionOrder,
  liveSessionWillStart
}
class NotificationItem extends StatelessWidget {
  final NotificationModel model;

  const NotificationItem({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: () {
        if (model.data != null) {
          if (model.data!.noti_type == NotificationType.order.name) {
            handleActionOrderDetails(model.data!.order_id);
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            SizedBox(
                width: 42,
                height: 42,
                child: CustomSvgIcon(assetName: AppTheme.isDarkMode()
                    ? 'logo_fav_green_dark'
                    : 'logo_fav_green_light', width: 24, height: 24,)),
            const SizedBox(width: 16,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(title: model.body ?? '',
                    maxLines: 3,
                    fontColor: AppTheme.isDarkMode() ? Colors.white : Colors
                        .black,),
                  CustomText(
                    title: CustomDateTimeFormat().timeAgo(model.date, model.time),
                    fontSize: 13,
                    maxLines: 1,
                    fontColor: greyColor,),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handleActionOrderDetails(String? order_id){

    if(order_id==null){
      return;
    }

    Preferences preferences = Preferences();
    UserModel? userModel = preferences.getUserData();
    if(userModel!=null){
      if(userModel.providerModel?.mainAccount?.category.type==USERTYPE.gym.name){
        NavigatorHandler.push(GymOrderDetailsScreen(orderId: int.parse(order_id)));

      }else if(userModel.providerModel?.mainAccount?.category.type==USERTYPE.healthClubAndSpa.name){
        NavigatorHandler.push(SpaOrderDetailsScreen(orderId: int.parse(order_id)));

      }else if(userModel.providerModel?.mainAccount?.category.type==USERTYPE.healthyFood.name){
        NavigatorHandler.push(FoodOrderDetailsScreen(orderId: int.parse(order_id)));

      }else if(userModel.providerModel?.mainAccount?.category.type==USERTYPE.coache.name){
        NavigatorHandler.push(CoachOrderDetailsScreen(orderId: int.parse(order_id)));

      }else if(userModel.providerModel?.mainAccount?.category.type==USERTYPE.market.name){
        NavigatorHandler.push(ShopOrderDetailsScreen(orderId: int.parse(order_id)));

      }else if(userModel.providerModel?.mainAccount?.category.type==USERTYPE.sportFieldRentals.name){
        NavigatorHandler.push(SportsFieldOrderDetailsScreen(orderId: int.parse(order_id)));

      }
    }
  }

}
