import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/presentations/widgets/phone_code_widget/phoneCodeList.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../../core/dimens/dimens.dart';
import '../../../main.dart';
import '../custom_text/custom_text.dart';


class PhoneCodeWidget extends StatefulWidget {
  CountryCode? countryCode;
  final ValueChanged<CountryCode?> onSelected;
  PhoneCodeWidget({super.key, this.countryCode, required this.onSelected});

  @override
  State<PhoneCodeWidget> createState() => _PhoneCodeWidgetState();
}

class _PhoneCodeWidgetState extends State<PhoneCodeWidget> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.countryCode = widget.countryCode!=null? widget.countryCode!:CountryCode.fromDialCode('+966');

  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        showCountryList(widget.onSelected);
      },
      child: Row(
        children: [
          Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
            child: Image.asset(widget.countryCode!.flagUri!,package: 'country_code_picker',width: 32,height: 24,),
          ),
          const SizedBox(width: 8,),
          CustomText(title: widget.countryCode!.dialCode,fontColor: mainColor,fontSize: 14,)
        ],
      ),
    );
  }

  void showCountryList(ValueChanged<CountryCode?> onSelected) {

    showDialog(context: navigatorKey.currentContext!,barrierDismissible: false,barrierColor: Colors.transparent, builder: (context){
      return AlertDialog(surfaceTintColor: Colors.transparent,contentPadding: EdgeInsets.zero,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),clipBehavior: Clip.antiAliasWithSaveLayer,scrollable: true,elevation: 4,shadowColor: Colors.black.withOpacity(.8),backgroundColor: AppTheme.isDarkMode()?dark:Colors.white,
        content: SizedBox(
          height: Dimens.height*.85,
          width: Dimens.width,
          child:  PhoneCodeList(onSelected: onSelected,),
        ),
      );
    });
  }

  @override
  void didUpdateWidget(covariant PhoneCodeWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    oldWidget.countryCode = widget.countryCode;
    if(mounted){
      setState(() {

      });
    }

  }
}
