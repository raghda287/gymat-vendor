import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

class TextAnimationWidget extends StatefulWidget {
  const TextAnimationWidget({super.key});

  @override
  State<TextAnimationWidget> createState() => _TextAnimationWidgetState();
}

class _TextAnimationWidgetState extends State<TextAnimationWidget> with TickerProviderStateMixin{
  late AnimationController controller ;
  late Animation<double> animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(vsync: this,duration: const Duration(seconds: 1));
    animation = Tween<double>(begin: 0.0,end: 1.0).animate(controller);
    controller.repeat();

  }
  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity:animation,child: CustomText(title: 'Active'.tr(),fontColor: mainColor,fontSize: 16,),);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

}
