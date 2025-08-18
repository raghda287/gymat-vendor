import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/number_format/numberFormat.dart';
import 'package:gymatvendor/presentations/ads_module/ad_provider/ad_provider.dart';

import 'package:provider/provider.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../../core/navigator/navigator.dart';
import '../../../injection.dart';
import '../../../main.dart';
import '../../payment_module/payment_cards_screen/payment_cards_screen.dart';
import '../../payment_module/provider/payment_cards_provider.dart';
import '../custom_button/custom_button.dart';
import '../custom_text/custom_text.dart';
import '../custom_text_form/custom_text_form.dart';
import '../dialogs/scaffold_messanger.dart';
import 'choose_payment_type_widget.dart';
import 'online_card_list_widget.dart';


void showPaymentCardsSheet(num totalPrice,int? selectedIndex) {

  showModalBottomSheet(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(24),topRight: Radius.circular(24))),
      context: navigatorKey.currentContext!, builder: (contex){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const SizedBox(height: 16,),
          Center(
            child: Container(width: 64,
              height: 6,
              decoration: BoxDecoration(color: greyColor.withOpacity(AppTheme.isDarkMode()?0.1:0.5),borderRadius: BorderRadius.circular(3)),

            ),
          ),
          const SizedBox(height: 16,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(title: 'Choose payment card'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,fontSize: 16,fontWeight: FontWeight.bold,),
              Row(
                children: [
                  CustomText(title: 'Add'.tr(),fontSize: 14,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,),
                  IconButton(onPressed: (){
                    NavigatorHandler.push(const PaymentCardsScreen());
                  }, icon: Icon(Icons.add,color: AppTheme.isDarkMode()?Colors.white:Colors.black,),padding: EdgeInsets.zero,)
                ],
              )
            ],
          ),
          const SizedBox(height: 24,),



          OnlineCardListWidget(totalCost: totalPrice,defaultSelectedIndex: selectedIndex,showBackArrow: false,onBack: () async{

          }, onCardSelected: (num value,int index) async{
            await NavigatorHandler.pop();
            await Future.delayed(const Duration(milliseconds: 200));
            showPaymentCvvSheet( value, index, totalPrice,index);

          },),


        ],
      ),
    );
  });

}

void showPaymentCvvSheet(num cardId,int cardIndex,num totalPrice,int? selectedIndex) {

  String lang = navigatorKey.currentContext!.locale.languageCode;
  final TextEditingController _cvvController = TextEditingController();
  showModalBottomSheet(
    isScrollControlled: true,

      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(24),topRight: Radius.circular(24))),
      context: navigatorKey.currentContext!, builder: (contex){
    return Padding(
      padding:  EdgeInsets.only(left: 16,right: 16,bottom: MediaQuery.of(navigatorKey.currentContext!).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          const SizedBox(height: 16,),
          Center(
            child: Container(width: 64,
              height: 6,
              decoration: BoxDecoration(color: greyColor.withOpacity(AppTheme.isDarkMode()?0.1:0.5),borderRadius: BorderRadius.circular(3)),

            ),
          ),
          const SizedBox(height: 16,),
          Center(child: CustomText(title: 'Enter CVV'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,fontSize: 16,fontWeight: FontWeight.bold,)),
          const SizedBox(height: 24,),

          CustomTextFormField(controller: _cvvController,textInputType: TextInputType.number,maxLength: 4,bgColor: AppTheme.isDarkMode()?greyColor.withOpacity(0.1):inputBg,),

          const SizedBox(height: 24,),


          Row(

            children: [
            Expanded(child:CustomButton(title: 'Confirm'.tr(), onTap: () async{
              String cvv = _cvvController.text.trim();
              if(cvv.length>=3){
                await NavigatorHandler.pop();
                Future.delayed(const Duration(milliseconds: 200));

                AdProvider provider = getIt();
                provider.addAd(cardId, cvv);

              }else{
                CustomScaffoldMessanger.showToast(title: 'Invalid cvv'.tr());

              }
            },fontColor: Colors.white,fontSize: 15,),),
            const SizedBox(width: 8,),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              onTap: () async{
                await NavigatorHandler.pop();
                await Future.delayed(const Duration(milliseconds: 200));
                showPaymentCardsSheet(totalPrice,selectedIndex);
              },
              child: SizedBox(
                width: 56,
                height: 56,
                child: Card(
                  color: Colors.white,
                  elevation: 1,
                  surfaceTintColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  clipBehavior: Clip.antiAlias,
                  child:  Center(child: Icon(lang == 'en'? Icons.arrow_back:Icons.arrow_forward,color: Colors.black,),),
                ),
              ),
            ),
          ],),
          const SizedBox(height: 36,),

        ],
      ),
    );
  });

}

