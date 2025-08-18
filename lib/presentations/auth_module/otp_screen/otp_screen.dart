import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/core/text_styles/text_styles.dart';
import 'package:gymatvendor/injection.dart';
import 'package:gymatvendor/presentations/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_url/app_url.dart';
import '../../../main.dart';
import '../../widgets/custom_button/custom_button.dart';
import '../../widgets/custom_text/custom_text.dart';
import '../provider/auth_provider.dart';
import 'dart:ui' as ui;

class OtpScreen extends StatefulWidget {
  final String phone;

  const OtpScreen({super.key, required this.phone});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  AuthProvider provider = getIt();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      provider.initOtp(widget.phone);
      provider.startTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        showBackArrow: true,
        showToolBar: true,
        isMainBack:  true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CustomText(
                title: 'Verify it’s you'.tr(),
                fontWeight: FontWeight.bold,
                fontColor: mainColor,
                fontSize: 24,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: RichText(
                    text: TextSpan(
                        text: 'We send a code to ( '.tr(),
                        style: AppTextStyles()
                            .normalText()
                            .textColorNormal(greyColor),
                        children: [
                      TextSpan(
                          text:
                              '****${widget.phone.substring(widget.phone.length - 3)}',
                          style: AppTextStyles()
                              .normalText()
                              .textColorNormal(mainColor)),
                      TextSpan(
                          text: ' ). Enter it here to verify your identity'.tr(),
                          style: AppTextStyles()
                              .normalText()
                              .textColorNormal(greyColor)),
                    ]))),
            const SizedBox(
              height: 32,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Directionality(
                  textDirection: ui.TextDirection.ltr,
                  child: PinCodeTextField(
                    enableActiveFill: true,
                    mainAxisAlignment: MainAxisAlignment.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    appContext: context,
                    length: 4,
                    cursorColor: mainColor,
                    autoDisposeControllers: false,
                    textStyle: AppTextStyles().normalText(fontSize: 16).textColorNormal(AppTheme.isDarkMode()?greyColor:black),
                    controller: provider.smsController,
                    pinTheme: PinTheme(
                        borderRadius: BorderRadius.circular(12),
                        fieldOuterPadding:
                            const EdgeInsets.symmetric(horizontal: 8),
                        fieldHeight: 56,
                        fieldWidth: 56,
                        activeColor: AppTheme.isDarkMode()?inputBgDark:inputBg,
                        activeFillColor: AppTheme.isDarkMode()?inputBgDark:inputBg,
                        selectedFillColor: AppTheme.isDarkMode()?inputBgDark:inputBg,
                        selectedColor: greyColor,
                        inactiveFillColor: AppTheme.isDarkMode()?inputBgDark:inputBg,
                        inactiveColor: AppTheme.isDarkMode()?inputBgDark:inputBg,
                        shape: PinCodeFieldShape.box),
                  ),
                )),
            const SizedBox(
              height: 32,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Center(child: Consumer<AuthProvider>(
                  builder: (context, provider, _) {
                    return CustomText(
                      title: provider.isTimerStoped == null
                          ? ''
                          : provider.isTimerStoped!
                              ? 'Resend code'.tr()
                              : '${provider.seconds}',
                      fontColor: mainColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    );
                  },
                ))),
            const SizedBox(
              height: 12,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Center(
                    child: Text.rich(
                  TextSpan(
                      text: 'By clicking on the Agree button, you agree to our '
                          .tr(),
                      style:
                          AppTextStyles().normalText().textColorNormal(greyColor),
                      children: [
                        TextSpan(
                            text: 'Terms and Conditions'.tr(),
                            recognizer: TapGestureRecognizer()..onTap =()async{
                              await launchUrl(Uri.parse('${AppUrls.baseUrl}webView/terms_conditions?lang=${navigatorKey.currentContext!.locale.languageCode}'),mode: LaunchMode.inAppBrowserView);

                            },
                            style: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'font_regular',
                                color: mainColor,
                                decorationColor: mainColor,
                                decoration: TextDecoration.underline)),
                        TextSpan(
                          text:
                              ' and '.tr(),
                          style: AppTextStyles()
                              .normalText()
                              .textColorNormal(greyColor),
                        ),
                        TextSpan(
                            text: 'Privacy Policy.'.tr(),

                            recognizer: TapGestureRecognizer()..onTap =() async{
                              await launchUrl(Uri.parse('${AppUrls.baseUrl}webView/privacy?lang=${navigatorKey.currentContext!.locale.languageCode}'),mode: LaunchMode.inAppBrowserView);

                            },

                            style: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'font_regular',
                                color: mainColor,
                                decorationColor: mainColor,
                                decoration: TextDecoration.underline)),
                      ]),
                  textAlign: TextAlign.center,
                ))),
            const SizedBox(height: 12,),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CustomButton(title: 'Agree and confirm'.tr(), onTap: (){
                  provider.checkSmsCode();
                },fontSize: 16,fontWeight: FontWeight.bold,)
            ),
          ],
        ),
      ),
    );
  }

}
