import 'package:flutter/material.dart';
import 'package:gymatvendor/presentations/widgets/custom_svg/CustomSvgIcon.dart';

class PayIconWidget extends StatelessWidget {
  final String assetName;
  final VoidCallback onTap;
  final Color bg;
  const PayIconWidget({super.key, required this.assetName,required this.bg, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        width: 42,
        height: 30,
        padding: const EdgeInsets.all(6),
        alignment: Alignment.center,
        decoration: BoxDecoration(color: bg,borderRadius: BorderRadius.circular(4)),
        child: CustomSvgIcon(assetName: assetName,width: 42,height: 30,),
      ),
    );
  }
}
