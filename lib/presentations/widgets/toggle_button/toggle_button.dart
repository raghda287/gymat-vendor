import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/presentations/widgets/custom_svg/CustomSvgIcon.dart';
import 'dart:math' as math;

class CustomToggleButton extends StatelessWidget {
  final  ValueChanged<bool> onToggle;
  final bool selected;
  final Color? inActiveColor;
  const CustomToggleButton({super.key,required this.onToggle,required this.selected, this.inActiveColor});

  @override
  Widget build(BuildContext context) {
    String lang = context.locale.languageCode;

    return Transform.rotate(
        angle: lang=='ar'?math.pi:0,
        child:SizedBox(
      width: 54,
      height: 29,
      child: FlutterSwitch(
          activeColor: mainColor,
          inactiveColor: inActiveColor??dark,
          toggleColor: Colors.white,
          height:29,
          width: 54,
          value: selected, onToggle: onToggle),
    ));
  }


}
