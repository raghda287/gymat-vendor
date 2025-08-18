
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'dart:ui' as ui;

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../../core/navigator/navigator.dart';
import '../../../core/text_styles/text_styles.dart';
import '../../../data/models/paymentCardModel.dart';
import '../../../injection.dart';
import '../../../main.dart';
import '../../widgets/custom_button/custom_button.dart';
import '../../widgets/custom_svg/CustomSvgIcon.dart';
import '../../widgets/custom_text/custom_text.dart';
import '../add_card_screen/add_card_screen.dart';
import '../provider/payment_cards_provider.dart';

class CardItem extends StatelessWidget {
  final int index;
  final PaymentCardModel model;
  const CardItem({super.key, required this.model, required this.index});

  @override
  Widget build(BuildContext context) {
    RegExp visaRegex = RegExp(r'^4[0-9]{12}(?:[0-9]{3})?$');
    RegExp mastercardRegex = RegExp(r'^(5[1-5][0-9]{14}|2(22[1-9]|2[3-9][0-9]|[3-6][0-9]{2}|7([01][0-9]|20))[0-9]{12})$');
    RegExp madaRegex = RegExp(r'^(5(0(4[0-9]|6[5-9]|29)|8(4[0-9]|7[0-9]|9[0-9]))[0-9]{12})$');


    return AspectRatio(aspectRatio: 1.7,
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: (){
          showCardActionSheet(model);
        },

        child: Card(
          surfaceTintColor: Colors.transparent,
          elevation: 1,
          color: mainColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Directionality(
            textDirection: ui.TextDirection.ltr,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0,right: 20,top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [

                      if(visaRegex.hasMatch(model.getCardNumberForCheckType))const CustomSvgIcon(assetName: 'visa',width: 48,height: 36,),
                      if(mastercardRegex.hasMatch(model.getCardNumberForCheckType))const CustomSvgIcon(assetName: 'mastercard',width: 48,height: 36,),
                      if(madaRegex.hasMatch(model.getCardNumberForCheckType))const CustomSvgIcon(assetName: 'mada',width: 24,height: 16,),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(

                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(children: [
                        const CustomSvgIcon(assetName: 'chip',width: 48,height: 36,),
                        const SizedBox(width: 4,),
                        CustomSvgIcon(assetName: 'hrz_wifi',width: 32,height: 32,color:Colors.white.withOpacity(.6),),

                      ],),
                    ),
                    const SizedBox(height: 12,),
                    CustomText(title: model.getCardNumber,fontSize: 21,fontColor: Colors.white.withOpacity(.9))
                  ],),
                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20,bottom: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [

                      Expanded(child: CustomText(title: model.card_holder??'',maxLines: 1,fontSize: 16,fontColor:Colors.white)),
                      const SizedBox(width: 24,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(title: 'Expire date'.tr(),fontColor: Colors.white.withOpacity(.6),fontSize: 11,),
                          const SizedBox(height: 4,),
                          CustomText(title: '${model.month}/${model.year}',fontColor: Colors.white.withOpacity(.9),fontSize: 11,),

                        ],)
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),);
  }

  void showCardActionSheet(PaymentCardModel model) {
    showModalBottomSheet(context: navigatorKey.currentContext!,shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(24),topRight: Radius.circular(24))), builder: (context){

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16,),
            Container(width: 64,
            height: 6,
              decoration: BoxDecoration(color: greyColor.withOpacity(AppTheme.isDarkMode()?0.1:0.5),borderRadius: BorderRadius.circular(3)),

            ),
            const SizedBox(height: 36,),
            InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              onTap: () async{
                await NavigatorHandler.pop();
                await Future.delayed(const Duration(milliseconds: 200));
                showDeleteCardSheet(model);

              },
              child: Row(
                children: [
                  CustomSvgIcon(assetName: 'delete',color: AppTheme.isDarkMode()?Colors.white:Colors.black,),
                  const SizedBox(width: 16,),
                  CustomText(title: 'Delete'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,fontSize: 16,),
                ],
              ),
            ),
            const SizedBox(height: 24,),

            InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              onTap: () async{
                await NavigatorHandler.pop();
                await Future.delayed(const Duration(milliseconds: 200));
                NavigatorHandler.push(AddCardScreen(paymentCardModel: model,));

              },
              child: Row(
                children: [
                  CustomSvgIcon(assetName: 'edit',width: 16,height: 16,color: AppTheme.isDarkMode()?Colors.white:Colors.black,),
                  const SizedBox(width: 16,),
                  CustomText(title: 'Update'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,fontSize: 16,),
                ],
              ),
            ),
            const SizedBox(height: 36,),

          ],
        ),
      );

    },);
  }


  void showDeleteCardSheet(PaymentCardModel model) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(24),topRight: Radius.circular(24))),
        context: navigatorKey.currentContext!, builder: (contex){
      return Directionality(
        textDirection: ui.TextDirection.ltr,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16,),
            CustomText(title: 'Delete card'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,fontSize: 16,),
            const SizedBox(height: 16,),
            Divider(color: AppTheme.isDarkMode()?dark:inputBg,),
            const SizedBox(height: 16,),
            CustomText(title: model.getCardNumber,fontColor: mainColor,fontSize: 16,fontWeight: FontWeight.bold,),


            const SizedBox(height: 24,),
        
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: CustomButton(title: 'Delete'.tr(), onTap: () async{
                PaymentCardsProvider provider = getIt();
                await NavigatorHandler.pop();
                await Future.delayed(const Duration(milliseconds: 500));
                provider.deleteCard(index,model.id);
              },bg: mainColor,fontSize: 14,fontColor: Colors.white,),
            ),
        
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: CustomButton(title: 'Cancel'.tr(), onTap: (){
                NavigatorHandler.pop();
              },bg: Colors.transparent,fontSize: 14,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,),
            ),
        
            const SizedBox(height: 16,),
        
          ],
        ),
      );
    });  }

}
