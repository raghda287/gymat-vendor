import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

class IsDeliveryServiceWidget extends StatefulWidget {
  bool defaultValue;
  final ValueChanged<bool> onChecked;
  IsDeliveryServiceWidget({super.key, required this.onChecked, required this.defaultValue});

  @override
  State<IsDeliveryServiceWidget> createState() => _IsDeliveryServiceWidgetState();
}

class _IsDeliveryServiceWidgetState extends State<IsDeliveryServiceWidget> {
  bool isChecked = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isChecked = widget.defaultValue;
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: (){
        isChecked =!isChecked;
        widget.onChecked(isChecked);
        setState(() {

        });
      },
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(value: isChecked,

                activeColor: mainColor,
                onChanged: (value){
              isChecked =!isChecked;
              widget.onChecked(isChecked);
              setState(() {

              });

            }),
          ),
          const SizedBox(width: 12,),
          CustomText(title: 'Delivery service'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,fontSize: 15,)
        ],
      ),
    );
  }

  @override
  void didUpdateWidget(covariant IsDeliveryServiceWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    oldWidget.defaultValue = widget.defaultValue;
  }
}

/*CheckboxListTile(
      value: isChecked,contentPadding: EdgeInsets.zero, onChanged:(value){
      isChecked =!isChecked;
      widget.onChecked(isChecked);
      setState(() {

      },);
    },title: CustomText(title: 'Delivery service',fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,fontSize: 15,),);*/