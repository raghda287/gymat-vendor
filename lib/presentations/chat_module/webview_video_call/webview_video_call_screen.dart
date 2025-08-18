

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:gymatvendor/data/models/user_model.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../../core/navigator/navigator.dart';
import '../../../core/utils/preferences.dart';
import '../../widgets/dialogs/scaffold_messanger.dart';

class WebViewVideoCallScreen extends StatefulWidget {
  final String link;


  const WebViewVideoCallScreen({super.key, required this.link,});

  @override
  State<WebViewVideoCallScreen> createState() => _WebViewVideoCallScreenState();
}

class _WebViewVideoCallScreenState extends State<WebViewVideoCallScreen> {
  InAppWebViewController? controller;

   Preferences preferences = Preferences();
   UserModel? userModel;

   @override
  void initState() {
    // TODO: implement initState

     super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      WakelockPlus.toggle(enable: true);
    });

    userModel = Preferences().getUserData();

  }







  @override
  Widget build(BuildContext context) {


    return WillPopScope(
      onWillPop: () async{

        return false;
      },
      child: Scaffold( body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(widget.link),headers: {'Authorization':userModel!=null?userModel!.auth:''}),
        initialSettings: InAppWebViewSettings(
          mediaPlaybackRequiresUserGesture: false,
          allowsInlineMediaPlayback: true,
          javaScriptEnabled: true,
          disableHorizontalScroll: true,
          disableVerticalScroll: true,
          displayZoomControls: false,
          supportZoom: false,


        ),
        onWebViewCreated: (controller){
          this.controller = controller;


        },
        onLoadStart: (controller,url) async{


        },

        onLoadStop: (controller,url) async{
          if(url?.toString()=='https://gymatapp.com/api/coach/callEnded'){
            CustomScaffoldMessanger.showToast(title: 'Meeting is ended'.tr());
            await NavigatorHandler.pop();
          }
        },

        onPermissionRequest: (controller,request) async{

          return PermissionResponse(action: PermissionResponseAction.GRANT,resources: request.resources);

        },)
      ),
    );
  }


  @override
  void dispose() {
    // TODO: implement dispose

    WakelockPlus.toggle(enable: false);
    controller = null;
    super.dispose();


  }
}
