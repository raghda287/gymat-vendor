import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';

class EmojiPickerWidget extends StatelessWidget {
  final bool isShow;
  final TextEditingController controller;
  final ValueChanged<bool> onEmojiTyping;
  const EmojiPickerWidget({super.key, required this.controller, required this.isShow, required this.onEmojiTyping});

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: isShow?256:0,
      child: EmojiPicker(

        onEmojiSelected: (category,emoji) {
          String text = '${controller.text}${emoji.emoji} ';
          controller.text = text;
        onEmojiTyping(true);
      },
        config: Config(
          height: isShow ? 256 : 0,
          checkPlatformCompatibility: true,
          categoryViewConfig: CategoryViewConfig(
              backgroundColor:AppTheme.isDarkMode() ? inputBgDark : Colors.white,
              indicatorColor: mainColor,iconColor: AppTheme.isDarkMode()?Colors.white:Colors.black,iconColorSelected: mainColor),
          skinToneConfig: const SkinToneConfig(
            indicatorColor: mainColor,
          ),
          searchViewConfig: SearchViewConfig(

              backgroundColor: AppTheme.isDarkMode() ? inputBgDark : Colors.white,buttonIconColor: AppTheme.isDarkMode() ? Colors.black : Colors.white),

          bottomActionBarConfig: const BottomActionBarConfig(enabled: false),
          emojiViewConfig: EmojiViewConfig(columns: 8, emojiSizeMax: 24,backgroundColor: AppTheme.isDarkMode() ? inputBgDark : Colors.white),
        ),
      ),
    );
  }
}
