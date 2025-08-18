import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';


import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../../core/navigator/navigator.dart';
import '../../../data/models/paymentCardModel.dart';
import '../../../injection.dart';
import '../../../main.dart';
import '../../widgets/card_text_form/card_expire_date_text_form.dart';
import '../../widgets/card_text_form/card_name_text_form.dart';
import '../../widgets/card_text_form/card_number_text_form.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';
import 'dart:ui' as ui;

import '../../widgets/custom_button/custom_button.dart';
import '../../widgets/custom_svg/CustomSvgIcon.dart';
import '../../widgets/custom_text/custom_text.dart';
import '../../widgets/dialogs/scaffold_messanger.dart';
import '../provider/payment_cards_provider.dart';
import '../widgets/visa_type_widget.dart';
enum CardType {
  visa,
  mastercard,
  mada
}
class AddCardScreen extends StatefulWidget {
  final PaymentCardModel? paymentCardModel;
  const AddCardScreen({super.key, this.paymentCardModel});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardExpireDateController = TextEditingController();

  CardType? cardType;
  String? cardNameText;
  String? expDateText;
  String? formatCard;

  RegExp visaRegex = RegExp(r'^4[0-9]{12}(?:[0-9]{3})?$');
  RegExp mastercardRegex = RegExp(r'^(5[1-5][0-9]{14}|2(22[1-9]|2[3-9][0-9]|[3-6][0-9]{2}|7([01][0-9]|20))[0-9]{12})$');
  RegExp madaRegex = RegExp(r'^(5(0(4[0-9]|6[5-9]|29)|8(4[0-9]|7[0-9]|9[0-9]))[0-9]{12})$');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.paymentCardModel!=null){
      _nameController.text = widget.paymentCardModel!.card_holder??'';
      _cardNumberController.text = widget.paymentCardModel!.card_number??'';
      _cardExpireDateController.text = '${widget.paymentCardModel!.month??''}/${widget.paymentCardModel!.year??''}';

      String number = _cardNumberController.text.replaceAll('-', '').replaceAll(' ', '');
      if(visaRegex.hasMatch(number)){
        cardType = CardType.visa;

      }else if(mastercardRegex.hasMatch(number)){
        cardType = CardType.mastercard;
      }else if(madaRegex.hasMatch(number)){
        cardType = CardType.mada;
      }
      cardNameText = _nameController.text;
      expDateText = _cardExpireDateController.text;
      formatCard = _cardNumberController.text;


    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          showToolBar: true,
          showBackArrow: true,
          isMainBack: true,
          title: 'Payment'.tr(),
          elevation: 1,
          bgColor: AppTheme.isDarkMode() ? dark : Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(aspectRatio: 1.7,
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
                                if(cardType==CardType.visa)const CustomSvgIcon(assetName: 'visa',width: 48,height: 36,),
                                if(cardType==CardType.mastercard)const CustomSvgIcon(assetName: 'mastercard',width: 48,height: 36,),
                                if(cardType==CardType.mada)const CustomSvgIcon(assetName: 'mada',width: 24,height: 16,),
                                if(cardType==null)const CustomSvgIcon(assetName: 'double_circle',width: 36,height: 24,)

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
                                  CustomSvgIcon(assetName: 'hrz_wifi',width: 32,height: 32,color: Colors.white.withOpacity(.6),),
                          
                                ],),
                              ),
                              const SizedBox(height: 12,),
                              CustomText(title: formatCard??'XXXX  XXXX  XXXX  XXXX',fontSize: 21,fontColor: Colors.white.withOpacity(.9),)
                          ],),
                          Padding(
                            padding: const EdgeInsets.only(left: 20,right: 20,bottom: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [

                                Expanded(child: CustomText(title: cardNameText??'',maxLines: 1,fontSize: 16,fontColor: Colors.white,)),
                                const SizedBox(width: 24,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(title: 'Expire date'.tr(),fontColor: Colors.white.withOpacity(.6),fontSize: 11,),
                                    const SizedBox(height: 4,),
                                    CustomText(title: expDateText??'00/0000',fontColor: Colors.white.withOpacity(.9),fontSize: 11,),

                                  ],)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),),

                CustomText(title: 'Name on the card'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,fontSize: 14,),
                const SizedBox(height: 12,),
                CardNameField(controller: _nameController,maxLength: 30,onChange: (value){
                  if(mounted){
                    cardNameText = value;
                    setState(() {

                    });
                  }
                },),
                const SizedBox(height: 12,),

                CustomText(title: 'Card number'.tr(),fontSize: 14,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,),
                const SizedBox(height: 12,),
                CardNumberWidget(controller: _cardNumberController,height: 60,hint: 'xxxx-xxxx-xxxx-xxxx',onChange: (value){
                  String val = value.replaceAll(' ', '').replaceAll('-', '');
                  if(val.isEmpty){
                    if(mounted){
                      formatCard ='XXXX  XXXX  XXXX  XXXX';

                    }
                    setState(() {

                    });
                  }else{
                    String remX = '';
                    for(int index =val.length;index<16;index++){
                      remX = '${remX}X';
                    }

                    formatCard = '$val$remX'.replaceAll(' ', '');
                    String group1 = formatCard!.substring(0,4);
                    String group2 = formatCard!.substring(4,8);
                    String group3 = formatCard!.substring(8,12);
                    String group4 = formatCard!.substring(12,16);
                    formatCard = '$group1  $group2  $group3  $group4';


                    if(visaRegex.hasMatch(val)){
                      cardType =CardType.visa;
                    }else if(mastercardRegex.hasMatch(val)){
                      cardType = CardType.mastercard;
                    }else if(madaRegex.hasMatch(val)){
                      cardType = CardType.mada;
                    }else{
                      cardType = null;
                    }

                    setState(() {

                    });

                  }


                },),

                const SizedBox(height: 12,),
                CustomText(title: 'Expire date'.tr(),fontSize: 14,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,),
                const SizedBox(height: 12,),
                SizedBox(
                    width: 120,
                    child: CardExpireDateWidget(controller: _cardExpireDateController,hint: 'MM/YYYY', onChange: (String value) {
                      if(mounted){
                        expDateText = value;
                        setState(() {

                        });
                      }
                    },)),
                const SizedBox(height: 48,),
                CustomButton(title: 'Save'.tr(), onTap: (){
                  String name = _nameController.text.trim();
                  String cardNumber = _cardNumberController.text.trim();
                  String expDate = _cardExpireDateController.text.trim();
                  if(name.length>2&&cardType!=null&&expDate.length==7){
                    if(cardType==CardType.visa){
                      showVisaCardTypeSheet(name,cardNumber,expDate);
                    }else{
                      PaymentCardsProvider provider = getIt();
                      if(widget.paymentCardModel==null){
                        provider.addCards(cardNumber, name, expDate.split('/')[1], expDate.split('/')[0], VisaType.credit.name);
                      }else{
                        provider.updateCards(widget.paymentCardModel?.id,cardNumber, name, expDate.split('/')[1], expDate.split('/')[0], VisaType.credit.name);

                      }
                    }
                  }else if(name.length<3){
                    CustomScaffoldMessanger.showToast(title: 'Invalid card holder name'.tr());
                  }else if(cardType==null){
                    CustomScaffoldMessanger.showToast(title: 'Invalid card number'.tr());

                  }else if(expDate.length<7){
                    CustomScaffoldMessanger.showToast(title: 'Invalid expire date'.tr());

                  }

                },bg: mainColor,fontColor: Colors.white,fontSize: 14),
                const SizedBox(height: 24,),

              ],
            )));

  }

  void showVisaCardTypeSheet(String name, String cardNumber, String expDate) {
    VisaType? visaType;

    showModalBottomSheet(context: navigatorKey.currentContext!,shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(24),topLeft: Radius.circular(24))), builder: (context){
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24,),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: () async{
                  await NavigatorHandler.pop();
                }, icon: CustomSvgIcon(assetName: 'close2',color: AppTheme.isDarkMode()?Colors.white:Colors.black,)),
                CustomText(title: 'Payment'.tr(),fontSize: 14,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,fontWeight: FontWeight.bold,),
                const SizedBox(
                  width: 48,
                  height: 48,
                )
              ],
            ),
          ),
          Divider(color: AppTheme.isDarkMode()?greyColor.withOpacity(.05):inputBg,),
          const SizedBox(height: 24,),
          VisaTypeWidget(
            defaultVisaType: widget.paymentCardModel!=null?widget.paymentCardModel!.type==VisaType.debit.name?VisaType.debit:VisaType.credit:null,
            onChecked: (VisaType value) {
            visaType = value;
          },),

          Padding(

            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: CustomButton(title: 'Save'.tr(), onTap: () async{
              if(visaType!=null){
                await NavigatorHandler.pop();
                await Future.delayed(const Duration(milliseconds: 200));
                PaymentCardsProvider provider = getIt();
                if(widget.paymentCardModel==null){
                  provider.addCards(cardNumber, name, expDate.split('/')[1], expDate.split('/')[0], visaType!.name);
                }else{
                  provider.updateCards(widget.paymentCardModel?.id,cardNumber, name, expDate.split('/')[1], expDate.split('/')[0], visaType!.name);

                }
              }else{
                CustomScaffoldMessanger.showToast(title: 'Choose visa card type'.tr());

              }
            },bg: mainColor,fontSize: 15,fontColor: Colors.white,),
          ),
          const SizedBox(height: 12,),
        ],
      );
    });
  }

}
