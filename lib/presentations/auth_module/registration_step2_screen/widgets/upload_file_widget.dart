import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/presentations/widgets/custom_svg/CustomSvgIcon.dart';

class UploadFileWidget extends StatelessWidget {
  final String? filePath;
  final VoidCallback onTap;

  const UploadFileWidget(
      {super.key, required this.filePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        height: 54,
        decoration: BoxDecoration(
            color: AppTheme.isDarkMode() ? inputBgDark : inputBg,
            borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 36,
            ),
            const CustomSvgIcon(assetName: 'upload_photo2'),
            filePath != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
                  child: filePath!.contains('pdf')?const CustomSvgIcon(
                    assetName: 'pdf2',
                  ):Image.file(
                      File(
                        filePath!,
                      ),
                      width: 36,
                      height: 36,
                      fit: BoxFit.cover,
                    ),
                )
                : const SizedBox(
                    width: 36,
                  )
          ],
        ),
      ),
    );
  }
}
