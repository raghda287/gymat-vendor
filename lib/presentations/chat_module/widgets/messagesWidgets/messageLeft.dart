import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:ui' as ui;

import '../../../../core/app_colors/app_colors.dart';
import '../../../../core/app_theme/theme.dart';
import '../../../../core/dateFormat/dateFormat.dart';
import '../../../../core/navigator/navigator.dart';
import '../../../../core/text_styles/text_styles.dart';
import '../../../../data/models/messageModel.dart';
import '../../../widgets/custom_svg/CustomSvgIcon.dart';
import '../../../widgets/custom_text/custom_text.dart';
import '../../../widgets/dialogs/dialogMicorphonePermission.dart';
import '../../../widgets/dialogs/scaffold_messanger.dart';
import '../../webview_video_call/webview_video_call_screen.dart';


class MessageLeft extends StatelessWidget {
  final MessageModel model;
  const MessageLeft({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    double textWidth = calculateTextWidth(model.message??'');

    return Directionality(textDirection: ui.TextDirection.ltr, child:
    Row(
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(textWidth>200?8:36),topLeft: Radius.circular(textWidth>200?16:24),bottomRight: Radius.circular(textWidth>200?8:36),bottomLeft: const Radius.circular(8))),
          margin: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
          color: AppTheme.isDarkMode()?msgLeftDarkColor:Colors.white,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 0.5,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
            constraints: const BoxConstraints(maxWidth: 240,minWidth: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
          /*
                CustomText(title: model.message??'',fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,fontSize: 15),
          */

                InkWell(
                  focusColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onLongPress: () async{
                    String? text = getLongPressTextToCopy();
                    if(text!=null){
                      await Clipboard.setData(ClipboardData(text: text));
                      CustomScaffoldMessanger.showToast(title: 'Copied'.tr());

                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(model.message!=null&&model.message!.contains('https://gymatapp.com/api/coach/joinCall/'))

                        Container(
                          color: AppTheme.isDarkMode()?msgLeftMeetDarkColor.withOpacity(0.7):greyColor.withOpacity(0.08),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(4)),
                                child: const CustomSvgIcon(assetName: 'logo_fav_green_light',width: 48,height: 48,),
                              ),
                              const SizedBox(width: 12,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(title: 'Gymat'.tr(),fontSize: 15,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,),
                                  CustomText(title: 'Join meet'.tr(),fontSize: 11,fontColor:AppTheme.isDarkMode()?Colors.white.withOpacity(0.8): Colors.black.withOpacity(.8),)
                                ],
                              )
                            ],
                          ),
                        ),
                      if(model.message!=null&&model.message!.contains('https://gymatapp.com/api/coach/joinCall/'))const SizedBox(height: 8,),
                      RichText(
                        text: TextSpan(
                            children: _getTextSpans(),
                            style: AppTextStyles()
                                .normalText(fontSize: 15)
                                .textColorNormal(AppTheme.isDarkMode()
                                ? Colors.white
                                : Colors.black)),
                      ),
                    ],
                  ),
                ),

                CustomText(title: CustomDateTimeFormat().getNowDate()==model.date?model.time??'':'${model.date??''} ${model.time??''}',fontColor:AppTheme.isDarkMode()?msgLeftDateDarkColor:greyColor,fontSize: 10),

              ],),
          ),
        ),
      ],
    ));
  }

  String? getLongPressTextToCopy(){
    final RegExp urlPattern = RegExp(
      r'((https?|ftp):\/\/)?((([a-zA-Z\d]([a-zA-Z\d-]*[a-zA-Z\d])*)\.)+[a-zA-Z]{2,}|((\d{1,3}\.){3}\d{1,3}))(\:\d+)?(\/[-a-zA-Z\d%_.~+]*)*(\?[;&a-zA-Z\d%_.~+=-]*)?(\#[-a-zA-Z\d_]*)?',
      caseSensitive: false,
      multiLine: false,
    );

    String remainingText = model.message ?? '';
    final matches = urlPattern.allMatches(remainingText);
    String? url;

    for (final match in matches) {
      url = match.group(0);
      return url;
    }

    url = remainingText;

    return url;

  }
  List<TextSpan> _getTextSpans() {
    final RegExp urlPattern = RegExp(
      r'((https?|ftp):\/\/)?((([a-zA-Z\d]([a-zA-Z\d-]*[a-zA-Z\d])*)\.)+[a-zA-Z]{2,}|((\d{1,3}\.){3}\d{1,3}))(\:\d+)?(\/[-a-zA-Z\d%_.~+]*)*(\?[;&a-zA-Z\d%_.~+=-]*)?(\#[-a-zA-Z\d_]*)?',
      caseSensitive: false,
      multiLine: false,
    );

    List<TextSpan> spans = [];
    String remainingText = model.message ?? '';

    // Find all matches of the URL pattern
    final matches = urlPattern.allMatches(remainingText);

    int lastMatchEnd = 0;
    for (final match in matches) {
      // Add the text before the URL
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(text: remainingText.substring(lastMatchEnd, match.start)));
      }

      // Add the URL as a clickable text span
      final url = match.group(0);
      if (url != null) {
        spans.add(
          TextSpan(
            text: url,
            style: AppTextStyles()
                .normalText(fontSize: 15)
                .textColorNormal(Colors.blue),
            recognizer: TapGestureRecognizer()
              ..onTap = () async{
              bool status = await checkPermissionsStatus();
              if(status){
                bool? result = await NavigatorHandler.push(WebViewVideoCallScreen(link: url,));

              }else{
                requestCameraAndMicrophone();
              }


                },
          ),
        );
      }

      lastMatchEnd = match.end;
    }

    // Add remaining text after the last match
    if (lastMatchEnd < remainingText.length) {
      spans.add(TextSpan(text: remainingText.substring(lastMatchEnd)));
    }

    return spans;
  }

  double calculateTextWidth (String text){
    TextSpan span = TextSpan(text: text,style: AppTextStyles().normalText());
    TextPainter painter = TextPainter(text: span,textDirection: ui.TextDirection.ltr);
    painter.layout();
    return painter.size.width;
  }

  Future<bool> checkPermissionsStatus() async {
    var cameraStatus = await Permission.camera.status;
    var micStatus = await Permission.microphone.status;
    return cameraStatus.isGranted && micStatus.isGranted;
  }

  void requestCameraAndMicrophone() async {
    Map<Permission, PermissionStatus> mapStatus =
    await [Permission.camera, Permission.microphone].request();
    if (mapStatus[Permission.camera] == PermissionStatus.denied ||
        mapStatus[Permission.camera] == PermissionStatus.permanentlyDenied ||
        mapStatus[Permission.microphone] == PermissionStatus.denied ||
        mapStatus[Permission.microphone] == PermissionStatus.permanentlyDenied) {


      MicroPhoneDialog.showMicrophoneDialogPermission(() async{
        bool status = await checkPermissionsStatus();
        if (status) {
          await NavigatorHandler.pop();

        }else{
          await openAppSettings();

        }
      },()async{
        await NavigatorHandler.pop();
        await Future.delayed(const Duration(milliseconds: 200));
        await NavigatorHandler.pop();

      });


    }
  }
}
