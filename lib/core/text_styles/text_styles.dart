import 'package:flutter/material.dart';

import '../constants/constants.dart';

class AppTextStyles {

  TextStyle normalText({double fontSize = 14,TextDecoration decoration = TextDecoration.none}){
    return TextStyle(fontSize: fontSize,fontFamily: 'font_regular',decoration: decoration,decorationColor: Colors.red);
  }




}

extension TextStyleExtension on TextStyle{
  TextStyle textColorNormal(Color color) => copyWith(color: color ,fontFamily: 'font_regular');
  TextStyle textColorBold(Color color) => copyWith(color: color,fontFamily: 'font_bold' ,fontWeight: FontWeight.bold);

}