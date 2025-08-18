import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ListAnimation extends StatelessWidget {
  final List<Widget> children;
  const ListAnimation({super.key,required this.children});

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.synchronized(
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: AnimationLimiter(
          child: ListView.separated(
            itemCount: children.length,
            itemBuilder: (_, index) {
              return AnimationConfiguration.staggeredList(
                position: index,

                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(

                    child: children[index],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
             return const SizedBox(height:5,);
            }
          ),
        ),
      ),
    );
  }
}
