import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';


import '../../../data/models/api_response.dart';
import '../../../data/models/walletModel.dart';
import '../../../data/repositories/followers_repository.dart';
import '../../../data/repositories/wallet_repository.dart';
import '../../../injection.dart';
import '../../../main.dart';
import '../../widgets/dialogs/progress_dialog.dart';
import '../../widgets/dialogs/scaffold_messanger.dart';

class WalletProvider with ChangeNotifier {
  WalletRepository repository = getIt();
  num balance = 0.0;
  bool isLoadingBalance = true;
  bool isLoadingMore = false;
  List<WalletDetails?> walletDetailsList = [];
  int page = 1;
  CancelToken? cancelToken;

  void init() {
    page = 1;
    balance = 0.0;
    walletDetailsList = [];
    isLoadingBalance = true;
    isLoadingMore = false;
    cancelToken = null;
  }

  void getBalance() async {
    isLoadingBalance = true;
    isLoadingMore = false;
    if (cancelToken != null && !cancelToken!.isCancelled) {
      cancelToken!.cancel();
      cancelToken = null;
    }
    notifyListeners();
    try {
      ApiResponse response = await repository.getBalance(1);
      isLoadingBalance = false;

      if (response.response != null && response.response!.statusCode == 200) {

        if (response.response!.data['data'] != null&&response.response!.data['code'] == 200) {
          WalletModel walletModel = WalletModel.fromJson(response.response!.data['data']);
          balance = walletModel.wallet ?? 0;
          walletDetailsList.clear();
          walletDetailsList.addAll(walletModel.details);
          notifyListeners();
        }
      } else {
        if (response.error != null) {
          CustomScaffoldMessanger.showScaffoledMessanger(title: response.error);
        }
      }
    } catch (e) {
      isLoadingBalance = false;
      notifyListeners();
      if (e is DioException) {
        if (e.response!.statusCode != 500) {
          CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
        }
      }
      print('cards error>>>${e.toString()}');
    }
  }

  void loadMoreBalance() async {
    try {
      if (cancelToken != null && !cancelToken!.isCancelled) {
        cancelToken!.cancel();
        cancelToken = null;
      }
      cancelToken ??= CancelToken();
      isLoadingMore = true;

      int p = page + 1;
      if (walletDetailsList.last != null) {
        walletDetailsList.add(null);
      }

      notifyListeners();
      ApiResponse response = await repository.getBalance(p, cancelToken);
      cancelToken = null;
      isLoadingMore = false;
      if (walletDetailsList.last == null) {
        walletDetailsList.removeLast();
      }

      if (response.response != null && response.response!.statusCode == 200) {


        if ( response.response!.data['data'] != null&&response.response?.data['code']==200 ) {
          WalletModel walletModel =
              WalletModel.fromJson(response.response!.data['data']);
          if (walletModel.details.isNotEmpty) {
            walletDetailsList.addAll(walletModel.details);
            page = p;
          }
          notifyListeners();
        }
      } else {
        if (response.error != null) {
          CustomScaffoldMessanger.showScaffoledMessanger(title: response.error);
        }
      }
    } catch (e) {
      cancelToken = null;
      isLoadingMore = false;
      if (walletDetailsList.last == null) {
        walletDetailsList.removeLast();
      }
      notifyListeners();

      print('wallet load more error>>>${e.toString()}');
    }
  }
}
