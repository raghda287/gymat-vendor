import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/dimens/dimens.dart';
import 'package:gymatvendor/core/navigator/navigator.dart';
import 'package:gymatvendor/data/models/day_unit_type.dart';
import 'package:gymatvendor/data/models/subscribtion_model.dart';
import 'package:gymatvendor/injection.dart';
import 'package:gymatvendor/presentations/gym_module/provider/gym_services_provider.dart';
import 'package:gymatvendor/presentations/widgets/custom_svg/CustomSvgIcon.dart';
import 'package:gymatvendor/presentations/widgets/toggle_button/toggle_button.dart';
import 'package:provider/provider.dart';

import '../../../../core/app_colors/app_colors.dart';
import '../../../../core/app_theme/theme.dart';
import '../../../../core/constants/constants.dart';
import '../../../widgets/custom_button/custom_button.dart';
import '../../../widgets/custom_text/custom_text.dart';
import '../../../widgets/custom_text_form/custom_text_form.dart';
import '../../../widgets/custom_text_form_discount/custom_text_form_discount.dart';
import '../../../widgets/dialogs/scaffold_messanger.dart';
import 'service_time_item.dart';

class AddSubscriptionWidget extends StatefulWidget {
  const AddSubscriptionWidget({super.key});

  @override
  State<AddSubscriptionWidget> createState() => _AddSubscriptionWidgetState();
}

class _AddSubscriptionWidgetState extends State<AddSubscriptionWidget> {
  GymServicesProvider gymServicesProvider = getIt();
  final TextEditingController _servicePriceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();

  String? durationUnitType;
  bool isDiscountActive = false;
  String discountType = 'value';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gymServicesProvider.selectedMemberShipDurationIndex = -1;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Dimens.width,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 8,
            ),
            Center(
              child: Container(
                width: 54,
                height: 4,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: greyColor
                        .withOpacity(AppTheme.isDarkMode() ? 0.2 : 0.5)),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Center(
                child: CustomText(
              title: 'Add subscribtion'.tr(),
              fontColor: AppTheme.isDarkMode() ? Colors.white : Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            )),
            const SizedBox(
              height: 24,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title: 'Service time'.tr(),
                  fontColor:
                      AppTheme.isDarkMode() ? Colors.white : Colors.black,
                ),
                const SizedBox(
                  height: 14,
                ),
                Consumer<GymServicesProvider>(builder: (context, provider, _) {
                  return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: subscribtionDuration.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 2),
                      itemBuilder: (context, index) {
                        return InkWell(
                          focusColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () {
                            //_serviceTimeController.text = subscribtionDuration[index];
                            provider.updateSelectedMemberShipDuration(index);
                          },
                          child: ServiceTimeItem(
                            title: subscribtionDuration[index],
                            selected: provider.selectedMemberShipDurationIndex == index,
                          ),
                        );
                      });
                }),
                const SizedBox(
                  height: 12,
                ),
                CustomText(
                  title: 'Price'.tr(),
                  fontColor:
                      AppTheme.isDarkMode() ? Colors.white : Colors.black,
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomTextFormField(
                  controller: _servicePriceController,
                  textInputType: const TextInputType.numberWithOptions(
                      signed: false, decimal: true),
                  maxLength: 6,
                  minPrefixSuffixWidth: 32,
                  suffix:CustomSvgIcon(assetName: 'sar',width: 14,height: 14,color: AppTheme.isDarkMode()?Colors.white:Colors.black,),
                ),
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
                    Expanded(child: CustomTextFormFieldDiscount(controller: _discountController,)),
                    Container(
                      height: 36,
                      width: 100,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(3),border: Border.all(color: AppTheme.isDarkMode()?inputBgDark:inputBg)),
                      child: Row(children: [
                        Expanded(
                          child: InkWell(
                            onTap: (){
                              discountType ='value';
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
                const SizedBox(
                  height: 24,
                ),
                CustomButton(
                    title: 'Confirm'.tr(),
                    onTap: () {
                      RegExp regExp = RegExp(r'^\d*\.?\d{1,2}$');
                      String price = _servicePriceController.text.trim();
                      String discount = _discountController.text;

                      if (gymServicesProvider.selectedMemberShipDurationIndex != -1 && regExp.hasMatch(price)) {
                        if(isDiscountActive){
                          if(!regExp.hasMatch(discount)){
                            CustomScaffoldMessanger.showToast(title: 'Invalid discount value'.tr());
                            return;
                          }else if(num.parse(discount)==0){
                            CustomScaffoldMessanger.showToast(title: 'Invalid discount value'.tr());
                            return;
                          }else if((discountType=='value'&&num.parse(discount)>=num.parse(price))||(discountType=='per'&&num.parse(discount)>=100)){
                            CustomScaffoldMessanger.showToast(title: 'Invalid discount value'.tr());
                            return;
                          }

                        }

                        num serviceTime = 0;
                        String serviceTimeUnit = '';
                        String time = subscribtionDuration[gymServicesProvider.selectedMemberShipDurationIndex];
                        if (gymServicesProvider.selectedMemberShipDurationIndex == 0) {
                          serviceTime = 1;
                          serviceTimeUnit = 'Day';
                        } else if (gymServicesProvider.selectedMemberShipDurationIndex == 1) {
                          serviceTime = 1;
                          serviceTimeUnit = 'Month';
                        } else if (gymServicesProvider.selectedMemberShipDurationIndex == 2) {
                          serviceTime = 3;
                          serviceTimeUnit = 'Month';
                        } else if (gymServicesProvider.selectedMemberShipDurationIndex == 3) {
                          serviceTime = 6;
                          serviceTimeUnit = 'Month';
                        } else if (gymServicesProvider.selectedMemberShipDurationIndex == 4) {
                          serviceTime = 1;
                          serviceTimeUnit = 'Year';
                        }

                        num? newPrice = num.parse(price);
                        if(isDiscountActive){
                          if(discountType=='value'){
                            newPrice = num.parse(price)-num.parse(discount);
                          }else{
                            newPrice = num.parse(price)-((num.parse(discount)/100)*num.parse(price));
                          }
                        }

                        num? dis ;
                        if(discount.isNotEmpty){
                          dis = num.parse(discount);
                        }
                        SubscribtionModel model = SubscribtionModel(
                            0,
                            time,
                            time,
                            num.parse(formatNumber(num.parse(price)) ?? '0.00'),
                            serviceTime,
                            serviceTimeUnit,newPrice,discountType,isDiscountActive,dis);


                        if (!isItemAdded(model)) {

                          gymServicesProvider.addSubscribtionItem(model);
                          NavigatorHandler.pop();
                        } else {

                          CustomScaffoldMessanger.showToast(
                              title:
                                  'Cannot add the same duration with different price'
                                      .tr());
                        }

                      } else if (gymServicesProvider.selectedMemberShipDurationIndex == -1) {

                        CustomScaffoldMessanger.showToast(title: 'Service time field is required'.tr());

                      } else if (!regExp.hasMatch(price)) {

                        CustomScaffoldMessanger.showToast(title: 'Invalid price'.tr());
                      }
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }

  bool isItemAdded(SubscribtionModel model) {
    for (SubscribtionModel subscribtionModel in gymServicesProvider.subscribtions) {
      if (subscribtionModel.trans_title?.toLowerCase() == model.trans_title?.toLowerCase()&&subscribtionModel.trans_title!=null&&subscribtionModel.trans_title!.isNotEmpty) {
        return true;
      }
    }
    return false;
  }
}
