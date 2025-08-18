import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/presentations/payment_module/widgets/visa_type_checkbox.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';

enum VisaType{
  debit,
  credit
}
class VisaTypeWidget extends StatefulWidget {
  final ValueChanged<VisaType> onChecked;
  final VisaType? defaultVisaType;

  const VisaTypeWidget({super.key, required this.onChecked, this.defaultVisaType});

  @override
  State<VisaTypeWidget> createState() => _VisaTypeWidgetState();
}

class _VisaTypeWidgetState extends State<VisaTypeWidget> {
  VisaType? type;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    type =widget.defaultVisaType;
  }
  @override
  Widget build(BuildContext context) {
    return Padding(

      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(children: [
        VisaTypeCheckBox(isChecked: type==VisaType.debit, onChecked: (){
          if(mounted){
            type = VisaType.debit;
            setState(() {

            });
            widget.onChecked(type!);
          }
        }, title: 'Debit card'.tr(),),
        const SizedBox(height: 16,),
        Divider(color: greyColor.withOpacity(AppTheme.isDarkMode()?0.05:0.2),),
        const SizedBox(height: 12,),

        VisaTypeCheckBox(isChecked: type == VisaType.credit,
          onChecked: (){
          if(mounted){
            type = VisaType.credit;
            setState(() {

            });
            widget.onChecked(type!);

          }
        }, title: 'Credit card'.tr(),),
        const SizedBox(height: 36,),


      ],),
    );
  }
}
