import 'package:flutter/material.dart';
import 'package:gymatvendor/presentations/chat_module/provider/audio_provider.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/provider/coach_order_provider.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/provider/livesession_provider.dart';
import 'package:gymatvendor/presentations/followers_screen/provider/followers_provider.dart';
import 'package:gymatvendor/presentations/gym_module/provider/gym_order_provider.dart';
import 'package:gymatvendor/presentations/healthcub_spa_module/provider/spa_order_provider.dart';
import 'package:gymatvendor/presentations/healthy_food_module/provider/food_order_provider.dart';
import 'package:gymatvendor/presentations/healthy_food_module/provider/healthy_food_services_provider.dart';
import 'package:gymatvendor/presentations/notification_screen/provider/notifications_provider.dart';
import 'package:gymatvendor/presentations/payment_module/provider/payment_cards_provider.dart';
import 'package:gymatvendor/presentations/shop_module/provider/shop_home_provider.dart';
import 'package:gymatvendor/presentations/shop_module/provider/shop_order_provider.dart';
import 'package:gymatvendor/presentations/sport_field_module/provider/sports_field_order_provider.dart';
import 'package:gymatvendor/presentations/wallet_module/provider/wallet_provider.dart';
import 'package:provider/provider.dart';


import 'injection.dart';
import 'presentations/ads_module/ad_provider/ad_provider.dart';
import 'presentations/ask_question_module/provider/question_provider.dart';
import 'presentations/auth_module/provider/auth_provider.dart';
import 'presentations/chat_module/provider/chat_provider.dart';
import 'presentations/coaches_workout_module/provider/coach_home_provider.dart';
import 'presentations/coaches_workout_module/provider/coach_services_provider.dart';
import 'presentations/coaches_workout_module/provider/workout_provider.dart';
import 'presentations/growth_module/provider/provider.dart';
import 'presentations/gym_module/provider/gym_home_provider.dart';
import 'presentations/gym_module/provider/gym_services_provider.dart';
import 'presentations/healthcub_spa_module/provider/healthyclub_spa_home_provider.dart';
import 'presentations/healthcub_spa_module/provider/spa_services_provider.dart';
import 'presentations/healthcub_spa_module/provider/specialist_provider.dart';
import 'presentations/healthy_food_module/provider/healthy_food_home_provider.dart';
import 'presentations/map_search_screen/provider/MapProvider.dart';
import 'presentations/profile_module/provider/profile_provider.dart';
import 'presentations/settings_module/general_settings_screen/provider/general_setting_provider.dart';
import 'presentations/settings_module/language_screen/provider/language_provider.dart';
import 'presentations/shop_module/provider/shop_services_provider.dart';
import 'presentations/sport_field_module/provider/sports_field_home_provider.dart';
import 'presentations/sport_field_module/provider/sports_field_services_provider.dart';
import 'theme_provider.dart';


class GenerateMultiProviders extends StatelessWidget {
  final Widget child;

  const GenerateMultiProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<ThemeProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<AuthProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<LanguageProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<GeneralSettingProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<MapProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<AdProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<QuestionProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<GrowthProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<SpecialistProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<GymServicesProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<WorkoutProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<GymHomeProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<ProfileProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<HealthyClubSpaHomeProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<HealthyFoodHomeProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<CoachHomeProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<ShopHomeProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<SportsFieldHomeProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<SpaServicesProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<ChatProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<HealthyFoodServicesProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<SportsFieldServicesProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<ShopServicesProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<CoachServicesProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<GymOrderProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<SpaOrderProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<SportsFieldOrderProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<FoodOrderProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<ShopOrderProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<AudioProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<FollowersProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<LiveSessionProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<CoachOrderProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<NotificationsProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<WalletProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<PaymentCardsProvider>()),


      ],
      child: child,
    );
  }
}
