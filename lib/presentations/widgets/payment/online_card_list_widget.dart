import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../../core/number_format/numberFormat.dart';
import '../../../injection.dart';
import '../../../main.dart';
import '../../payment_module/provider/payment_cards_provider.dart';
import '../custom_button/custom_button.dart';
import '../custom_svg/CustomSvgIcon.dart';
import '../custom_text/custom_text.dart';
import '../dialogs/scaffold_messanger.dart';
import '../loading_indicator/loading_indicator.dart';
import 'dart:ui' as ui;

class OnlineCardListWidget extends StatefulWidget {
  final VoidCallback onBack;
  final Function onCardSelected;
  final int? defaultSelectedIndex;
  final bool? showBackArrow;
  final num totalCost;

  const OnlineCardListWidget({super.key, required this.onBack, required this.onCardSelected, this.defaultSelectedIndex, this.showBackArrow, required this.totalCost});

  @override
  State<OnlineCardListWidget> createState() => _OnlineCardListWidgetState();
}

class _OnlineCardListWidgetState extends State<OnlineCardListWidget> {
  PaymentCardsProvider paymentCardsProvider = getIt();

  RegExp visaRegex = RegExp(r'^4[0-9]{12}(?:[0-9]{3})?$');
  RegExp mastercardRegex = RegExp(r'^(5[1-5][0-9]{14}|2(22[1-9]|2[3-9][0-9]|[3-6][0-9]{2}|7([01][0-9]|20))[0-9]{12})$');
  RegExp madaRegex = RegExp(r'^(5(0(4[0-9]|6[5-9]|29)|8(4[0-9]|7[0-9]|9[0-9]))[0-9]{12})$');
  int? selectedIndex;
  String lang = navigatorKey.currentContext!.locale.languageCode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedIndex = widget.defaultSelectedIndex;

    paymentCardsProvider.init();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      paymentCardsProvider.getCards();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: Consumer<PaymentCardsProvider>(builder: (context,provider,_){
        return provider.isLoading?const
        LoadingIndicator() :
        provider.cards.isNotEmpty?
        Column(
          
          children: [



            Expanded(
              child: ListView.builder(itemBuilder: (context,index){
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: (){
                      selectedIndex = index;
                      if(mounted){
                        setState(() {

                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(color: mainColor.withOpacity(index==selectedIndex? 0.08:0),borderRadius: BorderRadius.circular(index==selectedIndex?12:0),border: Border.all(color:index==selectedIndex? mainColor.withOpacity(0.3):Colors.transparent)),
                      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),


                      child: Row(
                        children: [
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Directionality(textDirection: ui.TextDirection.ltr,
                              child: CustomText(title: provider.cards[index].getCardNumber,fontSize: 15,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,fontWeight: FontWeight.bold,)),
                              const SizedBox(height: 4,),
                              CustomText(title: provider.cards[index].card_holder??'',fontSize: 12,fontColor: AppTheme.isDarkMode()?Colors.white.withOpacity(.8):greyColor.withOpacity(.7),),

                            ],)),
                          if(visaRegex.hasMatch(provider.cards[index].getCardNumberForCheckType))const CustomSvgIcon(assetName: 'visa',width: 48,height: 36,),
                          if(mastercardRegex.hasMatch(provider.cards[index].getCardNumberForCheckType))const CustomSvgIcon(assetName: 'mastercard',width: 48,height: 36,),
                          if(madaRegex.hasMatch(provider.cards[index].getCardNumberForCheckType))const CustomSvgIcon(assetName: 'mada',width: 24,height: 16,),
                        ],
                      ),
                    ),
                  ),
                );
              },itemCount: provider.cards.length,shrinkWrap: true,),
            ),
            const SizedBox(height: 36,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(title: 'Total'.tr(),fontSize: 15,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,),
                CustomText(title: '${CustomNumberFormat.format(widget.totalCost,2)} ${'SAR'.tr()}',fontSize: 15,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,fontWeight: FontWeight.bold,),

              ],
            ),
            const SizedBox(height: 24,),
            Row(children: [
              Expanded(child:CustomButton(title: 'Confirm'.tr(), onTap: () async{
                if(selectedIndex!=null){
                  num cardId = provider.cards[selectedIndex!].id!;
                  widget.onCardSelected(cardId,selectedIndex);

                }else{
                  CustomScaffoldMessanger.showToast(title: 'Choose payment card'.tr());
                }
              },fontColor: Colors.white,fontSize: 15,),),
              const SizedBox(width: 8,),
             widget.showBackArrow==false?const SizedBox():  InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                onTap: widget.onBack,
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
              widget.showBackArrow==false?const SizedBox():const SizedBox(width: 12,)
            ],),

            const SizedBox(height: 36,),
      
          ],
        ) :
        Center(child: CustomText(title: 'No payment cards to show'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,fontSize: 14,),);
      }),
    );

  }
}
