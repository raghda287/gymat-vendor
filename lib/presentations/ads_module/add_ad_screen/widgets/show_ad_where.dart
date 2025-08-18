import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/core/dimens/dimens.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

class ShowAdWhereWidget extends StatefulWidget {
  final ValueChanged<int> onValueChanged;
  const ShowAdWhereWidget({super.key, required this.onValueChanged});

  @override
  State<ShowAdWhereWidget> createState() => _ShowAdWhereWidgetState();
}

class _ShowAdWhereWidgetState extends State<ShowAdWhereWidget> {
  int? type;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: (){
            type = 1;
            widget.onValueChanged(type!);
            setState(() {

            });
          },
          child: Container(
            width: Dimens.width*.4,
            height: 54,
            decoration: BoxDecoration(color: type!=null&&type==1?mainColor:AppTheme.isDarkMode()?inputBgDark:inputBg,borderRadius: BorderRadius.circular(8)),
            alignment: Alignment.center,
            child: CustomText(title: 'Home page'.tr(),fontColor:type!=null&&type==1?Colors.white:AppTheme.isDarkMode()?Colors.white:Colors.black ,),
          ),
        ),
        const SizedBox(width: 12,),
        InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: (){
            type = 2;
            widget.onValueChanged(type!);
            setState(() {

            });
          },
          child: Container(
            width: Dimens.width*.4,
            height: 54,
            decoration: BoxDecoration(color: type!=null&&type==2?mainColor:AppTheme.isDarkMode()?inputBgDark:inputBg,borderRadius: BorderRadius.circular(8)),
            alignment: Alignment.center,
            child: CustomText(title: 'Second page'.tr(),fontColor:type!=null&&type==2?Colors.white:AppTheme.isDarkMode()?Colors.white:Colors.black ,),
          ),
        ),

      ],
    );
  }
}
