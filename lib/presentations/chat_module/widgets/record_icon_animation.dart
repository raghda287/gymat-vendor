import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gymatvendor/presentations/widgets/custom_svg/CustomSvgIcon.dart';

class RecordIconAnimation extends StatefulWidget {
  const RecordIconAnimation({super.key});

  @override
  State<RecordIconAnimation> createState() => _RecordIconAnimationState();
}

class _RecordIconAnimationState extends State<RecordIconAnimation> with TickerProviderStateMixin{
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(vsync: this,duration: const Duration(milliseconds: 1000),);

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.repeat();

  }
  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
        scale: _animation,
        child: const CustomSvgIcon(assetName: 'mic',color: Colors.red,width: 16,height: 16,));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();

  }
}
