import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import '../../../core/navigator/navigator.dart';
import '../../../data/models/api_response.dart';
import '../../../data/models/paymentCardModel.dart';
import '../../../data/models/paymentResponse.dart';
import '../../../data/repositories/followers_repository.dart';
import '../../../data/repositories/payment_card_repository.dart';
import '../../../injection.dart';
import '../../../main.dart';
import '../../widgets/dialogs/progress_dialog.dart';
import '../../widgets/dialogs/scaffold_messanger.dart';
import '../webview_payment/webview_payment.dart';

class PaymentCardsProvider with ChangeNotifier{
  PaymentCardRepository repository = getIt();
  List<PaymentCardModel> cards = [];

  bool isLoading= true;


  void init(){
    isLoading = true;
    cards.clear();

  }


  void getCards() async {

    cards.clear();
    isLoading = true;
    notifyListeners();
    try {
      ApiResponse response = await repository.getCards();
      isLoading = false;

      if (response.response != null && response.response!.statusCode == 200) {

        if (response.response!.data['code']==200) {
          response.response!.data['data'].forEach((v) => cards.add(PaymentCardModel.fromJson(v)));
          notifyListeners();

        }
      }else{
        if(response.error!=null){
          CustomScaffoldMessanger.showScaffoledMessanger(title: response.error);
        }
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      if (e is DioException) {
        if (e.response!.statusCode != 500) {
          CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
        }
      }
      print('cards error>>>${e.toString()}');
    }
  }

  void addCards(String cardNumber,String cardHolder,String year,String month,String type) async {
    ProgressDialog dialog = createProgressDialog(context: navigatorKey.currentContext!, msg: 'Adding...'.tr());

    try {
      await dialog.show();

      ApiResponse response = await repository.addCard(cardNumber, cardHolder, year, month, type);
      await dialog.hide();

      if (response.response != null && response.response!.statusCode == 200) {

        if (response.response!.data['code']==200) {
          cards.insert(0, PaymentCardModel.fromJson(response.response!.data['data']));
          notifyListeners();
          NavigatorHandler.pop();

        }
      }else{
        if(response.error!=null){
          CustomScaffoldMessanger.showScaffoledMessanger(title: response.error);
        }
      }
    } catch (e) {
      await dialog.hide();

      notifyListeners();
      if (e is DioException) {
        if (e.response!.statusCode != 500) {
          CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
        }
      }
      print('add card error>>>${e.toString()}');
    }
  }

  void updateCards(num? cardId,String cardNumber,String cardHolder,String year,String month,String type) async {
    ProgressDialog dialog = createProgressDialog(context: navigatorKey.currentContext!, msg: 'Updating...'.tr());

    try {
      await dialog.show();

      ApiResponse response = await repository.updateCard(cardId, cardNumber, cardHolder, year, month, type);
      await dialog.hide();

      if (response.response != null && response.response!.statusCode == 200) {

        if (response.response!.data['code']==200) {

          getCards();
          NavigatorHandler.pop();

        }
      }else{
        if(response.error!=null){
          CustomScaffoldMessanger.showScaffoledMessanger(title: response.error);
        }
      }
    } catch (e) {
      await dialog.hide();

      notifyListeners();
      if (e is DioException) {
        if (e.response!.statusCode != 500) {
          CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
        }
      }
      print('update card error>>>${e.toString()}');
    }
  }

  void deleteCard(int index,num? cardId) async{
    ProgressDialog dialog = createProgressDialog(context: navigatorKey.currentContext!, msg: 'Deleting...'.tr());
    try {
      await dialog.show();

      ApiResponse response = await repository.deleteCard(cardId);
      await dialog.hide();

      if (response.response != null && response.response!.statusCode == 200) {

        if (response.response!.data['code']==200) {
          cards.removeAt(index);
          notifyListeners();
        }
      }else{
        if(response.error!=null){
          CustomScaffoldMessanger.showScaffoledMessanger(title: response.error);
        }
      }
    } catch (e) {
      await dialog.show();

      if (e is DioException) {
        if (e.response!.statusCode != 500) {
          CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
        }
      }
      print('delete cards error>>>${e.toString()}');
    }
  }



}