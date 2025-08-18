import 'package:flutter/material.dart';
import 'package:gymatvendor/core/utils/preferences.dart';
import 'package:gymatvendor/data/models/localNotificationHandler.dart';
import 'package:gymatvendor/data/models/user_model.dart';

import '../../main.dart';
import '../../presentations/auth_module/provider/auth_provider.dart';
import '../../presentations/coaches_workout_module/home_screen/coaches_workout_home_screen.dart';
import '../../presentations/gym_module/home_screen/gym_home_screen.dart';
import '../../presentations/healthcub_spa_module/home_screen/healthclub_home_screen.dart';
import '../../presentations/healthy_food_module/home_screen/healthy_food_home_screen.dart';
import '../../presentations/shop_module/home_screen/shop_home_screen.dart';
import '../../presentations/sport_field_module/home_screen/sport_field_home_screen.dart';

class NavigatorHandler {
  static Future<dynamic> push(Widget page) async {
    return await Navigator.of(navigatorKey.currentContext!)
        .push(MaterialPageRoute(builder: (_) => page));
  }

  static Future<dynamic> pushReplacement(Widget page) async {
    return await Navigator.of(navigatorKey.currentContext!)
        .pushReplacement(MaterialPageRoute(builder: (_) => page));
  }

  static  Future<dynamic> pushAndRemoveUntil(Widget page) async{
    return await Navigator.of(navigatorKey.currentContext!).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => page), (route) => false);
  }

  static Future<dynamic> pop([Object? result]) async{
    Navigator.of(navigatorKey.currentContext!).pop(result);
  }




  Widget? getHomeScreen([LocalNotificationHandler? localNotificationHandler]){
    UserModel? userModel = Preferences().getUserData();
    if(userModel!=null&&userModel.providerModel!=null&&userModel.providerModel!.mainAccount!=null){
      String type = userModel.providerModel!.mainAccount!.category.type!;

      if(type ==USERTYPE.gym.name){

        return   GymHomeScreen(localNotificationHandler: localNotificationHandler,);


      }else if(type ==USERTYPE.healthClubAndSpa.name){
        return  HealthClubSpaHomeScreen(localNotificationHandler: localNotificationHandler,);

      }else if(type ==USERTYPE.coache.name){

        return  CoachesWorkoutHomeScreen(localNotificationHandler: localNotificationHandler,);

      }else if(type ==USERTYPE.healthyFood.name){
        return  HealthyFoodHomeScreen(localNotificationHandler: localNotificationHandler,);

      }else if(type ==USERTYPE.market.name){
        return  ShopHomeScreen(localNotificationHandler: localNotificationHandler,);

      }else if(type ==USERTYPE.sportFieldRentals.name){
        return  SportFieldHomeScreen(localNotificationHandler: localNotificationHandler,);
      }else{
        return null;
      }
    }

    return null;
  }
}
