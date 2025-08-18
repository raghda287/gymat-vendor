import 'package:flutter/material.dart';

class CircleRedPointWidget extends StatelessWidget {
  const CircleRedPointWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(width: 6,height: 6,decoration: const BoxDecoration(color: Colors.red,shape: BoxShape.circle));

  }
}
