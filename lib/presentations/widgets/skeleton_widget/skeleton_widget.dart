import 'package:flutter/material.dart';

class Skeleton extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final Color bg;

  const Skeleton({super.key, required this.width, required this.height, required this.radius, required this.bg});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: bg,borderRadius: BorderRadius.circular(radius)),
    );
  }
}
