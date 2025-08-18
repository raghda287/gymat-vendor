import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/*
import 'package:webview_flutter/webview_flutter.dart';
*/

import '../../../core/navigator/navigator.dart';
import '../../../data/models/paymentResponse.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';
import '../../widgets/custom_svg/CustomSvgIcon.dart';

class WebViewPayment extends StatefulWidget {
  final PaymentResponse paymentResponse;
  const WebViewPayment({super.key, required this.paymentResponse});

  @override
  State<WebViewPayment> createState() => _WebViewPaymentState();
}

class _WebViewPaymentState extends State<WebViewPayment> with TickerProviderStateMixin{
  //WebViewController? controller;
  int progress = 0;
  late AnimationController animationController;
  late final CurvedAnimation _animation;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  /*  controller =WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..enableZoom(false)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            print('urlStarted=>>${url}');

          },
          onPageFinished: (String url) async{
            if(url == widget.paymentResponse.succeass_url){
              await NavigatorHandler.pop(true);
            }
          },
          onProgress: (int progress){
            if(mounted){
              this.progress = progress;
              setState(() {

              });
            }
          },
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentResponse.url??''),);*/
    animationController = AnimationController(vsync: this,duration: const Duration(milliseconds: 500))..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar:  CustomAppBar(showBackArrow: true,isMainBack: true,showToolBar: true,title: 'Payment'.tr(),), body:
        Stack(children: [
          //controller!=null?WebViewWidget(controller: controller!,):const SizedBox(),
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(widget.paymentResponse.url??''),),
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,



            ),
            onWebViewCreated: (controller){


            },
            onLoadStart: (controller,url) async{

            },
           onProgressChanged: (controller,progress){
              this.progress = progress;
              if(mounted){
                setState(() {

                });
              }
           },

            onLoadStop: (controller,url) async{
              if(url.toString() == widget.paymentResponse.success_url){
                await NavigatorHandler.pop(true);
              }
            },

            ),


          if(progress<100) Center(child: SizedBox(
            width: 72,
            height: 72,
            child: Card(
              color: Colors.white,
              elevation: 2,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child:  Center(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: FadeTransition(opacity: _animation,
                  child: const CustomSvgIcon(assetName: 'logo_fav_green_light',width: 32,height: 32,)),
                ),
              ),
            ),
          ),),

        ],)
    );
  }

  @override
  void dispose() {
    _animation.dispose();
    animationController.dispose();
    super.dispose();
  }


}
