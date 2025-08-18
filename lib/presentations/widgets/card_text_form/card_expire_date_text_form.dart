import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../../core/constants/constants.dart';
import '../../../core/text_styles/text_styles.dart';
import 'card_expire_date_formatter.dart';
import 'card_formatter.dart';

class CardExpireDateWidget extends StatelessWidget {
  final String? hint;
  final TextEditingController controller;
  final Color? bgColor;
  final Color? borderColor;
  final double? fontSize;
  final double? height;
  final ValueChanged<String> onChange;

  const CardExpireDateWidget({super.key, this.hint, required this.controller, this.bgColor, this.borderColor, this.fontSize, this.height, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: height??54,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: bgColor?? (AppTheme.isDarkMode()?inputBgDark:inputBg),borderRadius: BorderRadius.circular(16),border: Border.all(color: borderColor??Colors.transparent)),
      child: TextFormField(
        controller: controller,
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.center,
        cursorColor: mainColor,
        style: AppTextStyles().normalText(fontSize: fontSize??14).textColorNormal(AppTheme.isDarkMode()?Colors.white:Colors.black),
        keyboardType: TextInputType.number,
        onChanged: (value){
          bool isEdited = false;
          if(value.length==7){
            int month = int.parse(value.split('/')[0]);
            int year = int.parse(value.split('/')[1]);

            String expDate = '';
            if(month==0){
              if(currentMonth().toString().length==1){
                expDate ='0${currentMonth()}';

              }else{
                expDate ='${currentMonth()}';

              }
              isEdited = true;
            }else if(month>12){
              expDate = '12';
              isEdited = true;

            }else{
              if(month.toString().length==1){
                expDate ='0$month';

              }else{
                expDate ='$month';

              }
            }




            if(year<currentYear()){
              expDate = '$expDate/${currentYear()}';
              isEdited = true;

            }else if(year>(currentYear()+19)){
              expDate = '$expDate/${currentYear()+19}';
              isEdited = true;

            }else{
              expDate = '$expDate/$year';
              isEdited = true;
            }

            if(isEdited){
              controller.text = expDate;
              controller.selection = TextSelection.fromPosition(TextPosition(offset: expDate.length),
              );

            }
            onChange(controller.text);


          }else{
            isEdited = false;
            onChange(value);

          }
        },
        inputFormatters: [FilteringTextInputFormatter.digitsOnly,LengthLimitingTextInputFormatter(6),CardExpirationFormatter()],
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: AppTextStyles().normalText(fontSize: fontSize??14).textColorNormal(hintColor),
          counterText: '',

        ),
      ),
    );
  }

  int currentYear(){
    return DateTime.now().year;
  }

  int currentMonth(){
    return DateTime.now().month;
  }
}
