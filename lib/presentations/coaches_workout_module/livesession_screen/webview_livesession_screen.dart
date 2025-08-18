import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:gymatvendor/data/models/user_model.dart';
import 'package:gymatvendor/injection.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/provider/livesession_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
/*import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';*/

import '../../../core/navigator/navigator.dart';
import '../../../core/utils/preferences.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';
import '../../widgets/dialogs/scaffold_messanger.dart';

class WebViewLivesessionScreen extends StatefulWidget {
  final String link;
  final String link_expired_time;
  final String link_end;
  final String camera;


  const WebViewLivesessionScreen({super.key, required this.link, required this.link_expired_time, required this.link_end, required this.camera});

  @override
  State<WebViewLivesessionScreen> createState() => _WebViewLivesessionScreenState();
}

class _WebViewLivesessionScreenState extends State<WebViewLivesessionScreen> {
   //WebViewController? controller;
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
   /* PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }


    controller = WebViewController.fromPlatformCreationParams(params,onPermissionRequest: (request) async{
      final value = await requestPermissions();
      value?await request.grant():await request.deny();
    })
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..enableZoom(false)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            print('url=>>>${url}');
          },
          onPageFinished: (String url) async{
            if(url == widget.link_end || url == widget.link_expired_time){
              LiveSessionProvider provider = getIt();
              provider.getHomeLiveSession();
              provider.getLiveSession();
              await NavigatorHandler.pop();

            }
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {

            return NavigationDecision.navigate;
          },


        ),
      )
      ..loadRequest(Uri.parse('${widget.link}?camera=${widget.camera}'),headers: {'Authorization':userModel!=null?userModel!.auth:''});

    if (controller?.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller?.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }*/


  }






  @override
  Widget build(BuildContext context) {


    return WillPopScope(
      onWillPop: () async{
        return false;
      },
      child: Scaffold(appBar:  const CustomAppBar(showBackArrow: false,),
          body:InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri('${widget.link}?camera=${widget.camera}'),headers: {'Authorization':userModel!=null?userModel!.auth:''}),
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
              if(url.toString() == widget.link_end || url.toString() == widget.link_expired_time){
                LiveSessionProvider provider = getIt();
                provider.getHomeLiveSession();
                provider.getLiveSession();
                await NavigatorHandler.pop();

              }
            },

            onPermissionRequest: (controller,request) async{

              return PermissionResponse(action: PermissionResponseAction.GRANT,resources: request.resources);

            },)

        /*  controller!=null?WebViewWidget(controller: controller!,):const SizedBox()*/

      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WakelockPlus.toggle(enable: false);
   /* controller?.loadRequest(Uri.parse('about:blank'));
    controller = null;*/
    controller = null;
    super.dispose();


  }
}
