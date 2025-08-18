import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/core/dimens/dimens.dart';
import 'package:gymatvendor/core/navigator/navigator.dart';
import 'package:gymatvendor/core/notification/notificationActionHandler.dart';
import 'package:gymatvendor/core/utils/preferences.dart';
import 'package:gymatvendor/data/models/user_model.dart';
import 'package:gymatvendor/presentations/auth_module/splash_screen/widgets/button_start.dart';
import 'package:gymatvendor/presentations/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:gymatvendor/presentations/widgets/custom_svg/CustomSvgIcon.dart';
import '../../chat_module/webview_video_call/webview_video_call_screen.dart';
import '../../widgets/custom_asset_image/custom_asset_image.dart';
import '../login_screen/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late Animation<double> animation,buttonAnimation;
  late AnimationController controller,buttonController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    buttonController = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));

    animation = Tween<double>(begin: 0, end: 1).animate(controller);
    buttonAnimation = Tween<double>(begin: -100, end: 0).animate(buttonController);

    animation.addListener(() {
      if (animation.isCompleted) {
        buttonController.forward();
      }
      setState(() {});
    });

    buttonAnimation.addListener(() {
      setState(() {});
    });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        showToolBar: false,
      ),
      body: Stack(
        children: [
          CustomAssetImage(
            assetName: AppTheme.isDarkMode()
                ? 'user_type_bg_dark'
                : 'user_type_bg_white',
            width: Dimens.width,
            height: Dimens.height,
          ),
          Align(
              alignment:Alignment.center,
              child: Opacity(
                  opacity: animation.value,
                  child:  CustomSvgIcon(
                    assetName: AppTheme.isDarkMode()?'logo_dark_mode':'logo_light_mode',
                    width: 263,
                    height: 138,
                  ))),
          Positioned(
            bottom: buttonAnimation.value,
            left: 0,
            right: 0,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: ButtonStart(
                onTap: () async{
                  Preferences preference = Preferences();
                  UserModel? userModel = preference.getUserData();
                  if(userModel==null){
                    NavigatorHandler.pushReplacement(const LoginScreen());

                  }else{
                    RemoteMessage? remoteMessage = await FirebaseMessaging.instance.getInitialMessage();
                    if(remoteMessage!=null){
                      NotificationActionHandler.actionHandler(remoteMessage,true);
                    }else{
                      Widget? screen = NavigatorHandler().getHomeScreen();
                      if(screen!=null){
                        NavigatorHandler.pushAndRemoveUntil(screen);

                      }


                    }

                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
