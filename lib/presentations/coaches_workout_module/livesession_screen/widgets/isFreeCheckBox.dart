import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

class IsFreeCheckBox extends StatefulWidget {
  final bool isFree;
  final ValueChanged<bool> onValueChanged;
  const IsFreeCheckBox({super.key, required this.isFree, required this.onValueChanged});

  @override
  State<IsFreeCheckBox> createState() => _IsFreeCheckBoxState();
}

class _IsFreeCheckBoxState extends State<IsFreeCheckBox> {
  bool isFree = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isFree = widget.isFree;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        isFree = !isFree;
        widget.onValueChanged(isFree);

        if(mounted){
          setState(() {

          });
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 20,
            width: 20,
            child: Checkbox(

                checkColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4),side: BorderSide(width: .5,color: AppTheme.isDarkMode()?Colors.white:greyColor.withOpacity(.5))),
                activeColor: mainColor,
                value: isFree, onChanged: (value){
              isFree = value??false;
              widget.onValueChanged(isFree);
              if(mounted){
                setState(() {

                });
              }
            }),
          ),
          const SizedBox(width: 12,),
          CustomText(title: 'Free'.tr(),fontSize: 16,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,fontWeight: FontWeight.bold,)
        ],
      ),
    );
  }
}
