import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/presentations/widgets/payment/wallet_payment_balance.dart';


import '../../../core/app_colors/app_colors.dart';
import '../../../core/navigator/navigator.dart';
import '../../../injection.dart';
import '../../wallet_module/provider/wallet_provider.dart';
import '../custom_button/custom_button.dart';
import '../dialogs/scaffold_messanger.dart';
import 'online_payment_widget.dart';
enum PaymentType{
  wallet,
  online
}
class ChoosePaymentTypeWidget extends StatefulWidget {
  final num total; // for wallet
  final ValueChanged<PaymentType> onSelected;
  final PaymentType? defaultPaymentType;
  const ChoosePaymentTypeWidget({super.key, required this.total, required this.onSelected, this.defaultPaymentType});

  @override
  State<ChoosePaymentTypeWidget> createState() => _ChoosePaymentTypeWidgetState();
}

class _ChoosePaymentTypeWidgetState extends State<ChoosePaymentTypeWidget> {
  PaymentType? paymentType;
  WalletProvider walletProvider = getIt();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    paymentType =widget.defaultPaymentType;

    walletProvider.init();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      walletProvider.getBalance();

    });

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            focusColor: Colors.transparent,
            onTap: (){
              paymentType = PaymentType.wallet;
              if(mounted){
                setState(() {

                });
              }

            },
            child:Container(
                height: 54,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                alignment: Alignment.center,
                decoration: BoxDecoration(color: mainColor.withOpacity(paymentType==PaymentType.wallet? 0.08:0),borderRadius: BorderRadius.circular(paymentType==PaymentType.wallet?12:0),border: Border.all(color:paymentType==PaymentType.wallet? mainColor.withOpacity(0.3):Colors.transparent)),
                child: const WalletPaymentBalance()) ),
        const SizedBox(height: 8,),
        InkWell(
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            focusColor: Colors.transparent,
            onTap: (){
              paymentType = PaymentType.online;
              if(mounted){
                setState(() {

                });
              }
            },
            child: Container(
              height: 54,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                alignment: Alignment.center,
                decoration: BoxDecoration(color: mainColor.withOpacity(paymentType==PaymentType.online? 0.08:0),borderRadius: BorderRadius.circular(paymentType==PaymentType.online?12:0),border: Border.all(color:paymentType==PaymentType.online? mainColor.withOpacity(.3):Colors.transparent)),
                child: const OnlinePaymentWidget())),
        const SizedBox(height: 48,),
        CustomButton(title: 'Confirm'.tr(), onTap: () async{
          if(paymentType == PaymentType.wallet){
            if(!walletProvider.isLoadingBalance){
              if(walletProvider.balance>0&&walletProvider.balance>=widget.total){
                await NavigatorHandler.pop();
                await Future.delayed(const Duration(milliseconds: 200));
                widget.onSelected(paymentType!);
              }else{
                CustomScaffoldMessanger.showToast(title: 'Wallet balance not enough'.tr());

              }
            }else{
              CustomScaffoldMessanger.showToast(title: 'Wait until loading balance'.tr());
            }
          }else if(paymentType == PaymentType.online){
            await NavigatorHandler.pop();
            await Future.delayed(const Duration(milliseconds: 200));
            widget.onSelected(paymentType!);
          }else{
            CustomScaffoldMessanger.showToast(title: 'Choose payment method'.tr());

          }
        },fontColor: Colors.white,fontSize: 15,),
        const SizedBox(height: 48,),

      ],
    );
  }
}
