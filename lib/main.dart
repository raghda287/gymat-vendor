import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/core/notification/notificationActionHandler.dart';
import 'package:gymatvendor/core/utils/preferences.dart';
import 'package:gymatvendor/socketProvider.dart';
import 'package:gymatvendor/theme_provider.dart';
import 'package:provider/provider.dart';
import 'core/constants/constants.dart';
import 'core/notification/notificationService.dart';
import 'injection.dart';
import 'multiproviders.dart';
import 'package:firebase_core/firebase_core.dart';

import 'presentations/auth_module/splash_screen/splash_screen.dart';


final navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  await init();
  NotificationService().init();



  runApp(GenerateMultiProviders(
      child: EasyLocalization(
        supportedLocales: appLanguage.map((e) => Locale(e.languageCode,e.countryCode)).toList(),
        startLocale: Locale(appLanguage[1].languageCode,appLanguage[1].countryCode),
        saveLocale: true,
        useOnlyLangCode: false,
        useFallbackTranslations: true,
        fallbackLocale: Locale(appLanguage[1].languageCode,appLanguage[1].countryCode),
        path: 'assets/languages',
        child: const MyApp(),
      )));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Allow landscape on larger screens (e.g., tablets) so the app can use full width.
    final views = WidgetsBinding.instance.platformDispatcher.views;
    final devicePixelRatio = views.first.devicePixelRatio;
    final logicalSize = views.first.physicalSize / devicePixelRatio;
    final bool isTablet = logicalSize.shortestSide >= 600;

    SystemChrome.setPreferredOrientations(isTablet
        ? [
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]
        : [
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]);

    Future.delayed(const Duration(seconds: 5)).then((value){
      SocketProvider socketProvider = getIt();
      socketProvider.connectToSocket();
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) async{
      try{
       // await Future.delayed(const Duration(seconds: 2));

        NotificationActionHandler.actionHandler(message);
      }catch (e){
        print('mainErrorNotification');
      }

    });

    Preferences preferences = Preferences();
    preferences.clearChatNotificationData();




  }
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context,provider,_){
      return MaterialApp(
        title: context.locale.languageCode=='en'?'Gymat business':'جمات أعمال',
        theme: AppTheme.theme(context),
        locale: context.locale,
        themeMode: AppTheme.isDarkMode()?ThemeMode.dark:ThemeMode.light,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        home:  const SplashScreen(),
      );
    });
  }
}