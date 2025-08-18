import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';

class LoadingIndicator extends StatelessWidget {
  final double? width;
  final double? stroke;
  final Color? color;

  const LoadingIndicator({super.key, this.width, this.stroke, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: width??48.0,
        height: width??48.0,
        alignment: Alignment.center,
        child: CircularProgressIndicator(color: color??(AppTheme.isDarkMode()?Colors.white:mainColor),strokeWidth: stroke??4.0,),
      ),
    );
  }
}



/*
class LoadingIndicator extends StatelessWidget {
  final double? width;
  final double? stroke;
  final Color? color;

  const LoadingIndicator({super.key, this.width, this.stroke, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: width??48.0,
        height: width??48.0,
        alignment: Alignment.center,
        child: Lottie.asset('assets/images/lottie/loader.json'),
      ),
    );
  }
}*/
