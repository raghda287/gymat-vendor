import 'package:flutter/material.dart';

class LoveAnimationWidget extends StatefulWidget {
  final Widget child;
  final bool isAnimated;
  final Duration duration;
  final bool alwayesAnimate;

  const LoveAnimationWidget({super.key,required this.child,required this.isAnimated,required this.duration,required this.alwayesAnimate});

  @override
  State<LoveAnimationWidget> createState() => _LoveAnimationWidgetState();
}

class _LoveAnimationWidgetState extends State<LoveAnimationWidget> with SingleTickerProviderStateMixin{
  late AnimationController controller;
  late Animation<double> animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(vsync: this,duration: widget.duration);
    animation = Tween<double>(begin: 1,end: 1.2).animate(controller);

  }
  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: animation,child: widget.child,);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();

  }

  @override
  void didUpdateWidget(covariant LoveAnimationWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if(widget.isAnimated != oldWidget.isAnimated){
      doAnimation();
    }
  }

  Future doAnimation() async{
    if(widget.isAnimated||widget.alwayesAnimate){
      await controller.forward();
      await controller.reverse();

    }
  }
}
