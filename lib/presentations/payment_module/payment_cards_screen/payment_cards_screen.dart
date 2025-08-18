import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../../core/navigator/navigator.dart';
import '../../../injection.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';
import '../../widgets/custom_text/custom_text.dart';
import '../../widgets/loading_indicator/loading_indicator_gym.dart';
import '../add_card_screen/add_card_screen.dart';
import '../provider/payment_cards_provider.dart';
import '../widgets/card_item.dart';

class PaymentCardsScreen extends StatefulWidget {
  const PaymentCardsScreen({super.key});

  @override
  State<PaymentCardsScreen> createState() => _PaymentCardsScreenState();
}

class _PaymentCardsScreenState extends State<PaymentCardsScreen> {
  PaymentCardsProvider provider = getIt();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    provider.init();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      provider.getCards();
    });
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
          actions: [
            IconButton(onPressed: (){
              NavigatorHandler.push(const AddCardScreen());
            }, icon: Icon(Icons.add,color: AppTheme.isDarkMode()?Colors.white:Colors.black,))
          ],
          bgColor: AppTheme.isDarkMode() ? dark : Colors.white,
        ),
        body: Consumer<PaymentCardsProvider>(builder: (context,provider,_){
          return provider.isLoading?const LoadingIndicatorGym(): provider.cards.isNotEmpty? ListView.builder(
            padding: const EdgeInsets.all(12),
            itemBuilder: (context,index){
              return CardItem(model: provider.cards[index],index: index,);
            },itemCount: provider.cards.length,shrinkWrap: true,):
          Center(child: CustomText(title: 'No payment cards to show'.tr(),fontSize: 14,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,));
        },));

  }
}
