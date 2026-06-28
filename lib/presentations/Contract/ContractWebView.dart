import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ContractWebView extends StatelessWidget{
  String contractUrl;

  ContractWebView({super.key,required this.contractUrl});

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(contractUrl)),
      initialSettings: InAppWebViewSettings(
        javaScriptEnabled: true
      ),
    );
  }

}