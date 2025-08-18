import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class LoadingIndicatorAds extends StatelessWidget {
  final double? width;

  const LoadingIndicatorAds({super.key, this.width});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: width??192.0,
        height: width??192.0,
        alignment: Alignment.center,
        child: Lottie.asset('assets/images/lottie/ads_loader.json'),
      ),
    );
  }
}
