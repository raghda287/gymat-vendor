import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

class TermsWidget extends StatefulWidget {
  final ValueChanged<bool> onTermsChecked;
  const TermsWidget({super.key, required this.onTermsChecked});

  @override
  State<TermsWidget> createState() => _TermsWidgetState();
}

class _TermsWidgetState extends State<TermsWidget> {
  bool _isChecked = false;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      horizontalTitleGap: 0,
      leading: Checkbox(
        activeColor: AppTheme.isDarkMode()?Colors.white:mainColor,
        checkColor: AppTheme.isDarkMode()?mainColor:Colors.white,
        side: BorderSide(color: AppTheme.isDarkMode()?Colors.white:greyColor),
        value: _isChecked, onChanged: (bool? value) {
        _isChecked = value!;
        widget.onTermsChecked(value);
        setState(() {

        });
      },),
      title: CustomText(title: 'Terms and conditons'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:mainColor,),
    );
  }
}

