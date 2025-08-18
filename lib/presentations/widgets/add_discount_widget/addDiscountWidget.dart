import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../../core/dimens/dimens.dart';
import '../custom_button/custom_button.dart';
import '../custom_svg/CustomSvgIcon.dart';
import '../custom_text/custom_text.dart';
import '../custom_text_form_discount/custom_text_form_discount.dart';
import '../toggle_button/toggle_button.dart';

class AddDiscountWidget extends StatefulWidget {
  final TextEditingController controller;
  final bool isDiscountActive;
  final String discountType;
  final ValueChanged<String> onDiscountTypeChanged;
  final ValueChanged<bool> isDiscountActiveChanged;

  const AddDiscountWidget({super.key, required this.controller, required this.onDiscountTypeChanged, required this.isDiscountActiveChanged, required this.isDiscountActive, required this.discountType});

  @override
  State<AddDiscountWidget> createState() => _AddDiscountWidgetState();
}

class _AddDiscountWidgetState extends State<AddDiscountWidget> {

  bool isDiscountActive = false;
  String discountType = 'value';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isDiscountActive = widget.isDiscountActive;
    discountType = widget.discountType;

    print('isDiscountdfsdfs=>>>${isDiscountActive}----$discountType');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Dimens.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    title: 'Add discount'.tr(),
                    fontColor:
                    AppTheme.isDarkMode() ? Colors.white : Colors.black,
                  ),
                  CustomToggleButton(
                      inActiveColor: AppTheme.isDarkMode()?dark:toggleColorDisactive,
                      onToggle: (value) {
                        isDiscountActive = value;
                        widget.isDiscountActiveChanged(value);
                        if(mounted){
                          setState(() {

                          });
                        }
                      }, selected: isDiscountActive)
                ],
              ),
              if(isDiscountActive)Column(children: [
                const SizedBox(height: 16,),
                Row(children: [
                  Expanded(child: CustomTextFormFieldDiscount(controller: widget.controller,)),
                  Container(
                    height: 36,
                    width: 100,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(3),border: Border.all(color: AppTheme.isDarkMode()?inputBgDark:inputBg)),
                    child: Row(children: [
                      Expanded(
                        child: InkWell(
                          onTap: (){
                            discountType ='value';
                            widget.onDiscountTypeChanged(discountType);
                            if(mounted){
                              setState(() {

                              });
                            }
                          },
                          child: Container(
                              padding: const EdgeInsets.all(8),
                              height: 36,
                              decoration: BoxDecoration(color: mainColor.withOpacity(discountType=='value'?AppTheme.isDarkMode()?1.0:0.2:0)),
                              child:  CustomSvgIcon(assetName: 'e_sum',color: AppTheme.isDarkMode()?Colors.white:Colors.black,width: 20,height: 20,)),
                        ),
                      ),
                      Container(
                        height: 36,
                        width: 1,
                        color: AppTheme.isDarkMode()?inputBgDark:inputBg,),
                      Expanded(
                        child: InkWell(
                          onTap: (){
                            discountType ='per';
                            widget.onDiscountTypeChanged(discountType);

                            if(mounted){
                              setState(() {

                              });
                            }
                          },
                          child: Container(
                              height: 36,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: mainColor.withOpacity(discountType=='per'?AppTheme.isDarkMode()?1.0: 0.2:0)),
                              child:  CustomSvgIcon(assetName: 'percentage',color: AppTheme.isDarkMode()?Colors.white:Colors.black)),
                        ),
                      ),

                    ],),
                  )
                ],)
              ],),

            ],
          )
        ],
      ),
    );
  }
  @override
  void didUpdateWidget(covariant AddDiscountWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if(mounted){
      isDiscountActive = widget.isDiscountActive;
      discountType = widget.discountType;
      setState(() {

      });
    }
  }
}
