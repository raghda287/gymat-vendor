import 'package:flutter/material.dart';

import '../custom_svg/CustomSvgIcon.dart';

class CustomNotificationIcon extends StatelessWidget {
  const CustomNotificationIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        SizedBox(
          width: 16,
        ),
        CustomSvgIcon(assetName: 'notification'),
        SizedBox(
          width: 16,
        ),
      ],
    );
  }
}
