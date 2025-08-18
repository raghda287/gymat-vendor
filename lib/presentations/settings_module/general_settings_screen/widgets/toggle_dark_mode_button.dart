import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/presentations/widgets/custom_svg/CustomSvgIcon.dart';
import 'dart:math' as math;
class CustomDarkModelToggleButton extends StatelessWidget {
  final  ValueChanged<bool> onToggle;
  final bool selected;
  const CustomDarkModelToggleButton({super.key,required this.onToggle,required this.selected});

  @override
  Widget build(BuildContext context) {
    String lang = context.locale.languageCode;

    return Transform.rotate(
      angle: lang=='ar'?math.pi:0,
      child: SizedBox(
        width: 54,
        height: 29,
        child: FlutterSwitch(
            activeColor: dark,
            inactiveColor: toggleColorDisactive,
            toggleColor: Colors.black,
            height:29,
            width: 54,
            activeIcon: Transform.rotate(angle: lang=='ar'?math.pi:0, child: Center(child: Image.asset('assets/images/gif/dark_mode.gif',width: 200,height: 200,))),
            inactiveIcon: Transform.rotate(
                angle: lang=='ar'?math.pi:0,
                child: const Center(child: CustomSvgIcon(assetName: 'sun',width: 200,height: 200,))),
            value: selected, onToggle: onToggle),
      ),
    );
  }
}
