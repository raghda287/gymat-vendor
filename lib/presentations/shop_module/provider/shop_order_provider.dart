import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/data/repositories/gym_order_repository.dart';
import 'package:gymatvendor/main.dart';
import 'package:gymatvendor/presentations/shop_module/provider/shop_home_provider.dart';
import 'package:gymatvendor/presentations/widgets/dialogs/progress_dialog.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import '../../../../../data/models/api_response.dart';
import '../../../data/models/foodOrderDetailsModel.dart';
import '../../../data/models/generalOrderModel.dart';
import '../../../data/models/gymOrderDetailsModel.dart';
import '../../../data/models/shopOrderDetailsModel.dart';
import '../../../data/models/spaOrderDetailsModel.dart';
import '../../../data/repositories/food_order_repository.dart';
import '../../../data/repositories/shop_order_repository.dart';
import '../../../data/repositories/spa_order_repository.dart';
import '../../../injection.dart';

class ShopOrderProvider with ChangeNotifier {
  final ShopOrderRepository repository = getIt();
  bool isLoading = false;
  bool isLoadingOrderDetails = false;

  List<GeneralOrderModel> orders = [];
  ShopOrderDetailsModel? shopOrderDetailsModel;
  DateTime? deliveryDateTime;


  void init() {
    orders = [];
    isLoading = true;
  }

  void initShopOrderDetails() {
    isLoadingOrderDetails = false;
    shopOrderDetailsModel = null;
  }

  void getOrders(String type) async {
    isLoading = true;
    orders.clear();
    notifyListeners();

    try {
      ApiResponse response = await repository.getOrders();
      isLoading = false;
      if (response.response != null) {
        if (response.response!.statusCode == 200 ||
            response.response!.statusCode == 201) {
          if (response.response!.data != null && response.response!.data['data'] != null) {


            if (response.response!.data['code']==200) {
              orders.clear();
              if(type=='up_coming'){
                response.response!.data['data']['current'].forEach((v) => orders.add(GeneralOrderModel.fromJson(v)));

              }else if(type=='complete'){
                response.response!.data['data']['previous'].forEach((v) => orders.add(GeneralOrderModel.fromJson(v)));

              }

            }
          } else {}
        } else {}
      }
    } catch (e) {
      print('errorOrders=>>>>$e');
    }
    notifyListeners();
  }

  void updateExpandedModel(GeneralOrderModel model, int index) {
    orders[index] = model;
    notifyListeners();
  }

  void getOrderDetails(num orderId) async {
    isLoadingOrderDetails = true;
    shopOrderDetailsModel = null;
    notifyListeners();
    try {
      ApiResponse response = await repository.getShopOrderDetails(orderId);
      isLoadingOrderDetails = false;

      if (response.response != null) {
        if (response.response!.statusCode == 200 || response.response!.statusCode == 201) {
          if (response.response!.data != null &&response.response!.data['code']==200) {
            if ( response.response!.data['data'] != null) {
              shopOrderDetailsModel = ShopOrderDetailsModel.fromJson(response.response!.data['data']);

            } else {}
          }

        } else {}
      }
    } catch (e) {
      print('errorOrderDetails=>>>>$e');
    }
    notifyListeners();
  }

  void updateOrderStatus(num orderId,String status) async {
    String title ='';
    if(status=='accepted'){
      title ='Accepting ...'.tr();
    }else if(status=='refused'){
      title ='Refusing ...'.tr();

    }else if(status=='end'){
      title ='Ending ...'.tr();

    }else{
      title ='Wait ...'.tr();

    }
    ProgressDialog dialog = createProgressDialog(context: navigatorKey.currentContext!, msg:title);
    try {
      await dialog.show();
      String? date;
      if(status =='accepted'){
        date = DateFormat('yyyy-MM-dd','en').format(deliveryDateTime!);
      }

      ApiResponse response = await repository.updateOrderStatus(orderId,status,date);
      await dialog.hide();

      if (response.response != null) {
        if (response.response!.statusCode == 200 || response.response!.statusCode == 201) {
          if (response.response!.data != null &&response.response!.data['code']==200) {
            if ( response.response!.data['data'] != null) {
              shopOrderDetailsModel!.status = status;
              if(status=='accepted'){
                shopOrderDetailsModel!.order?.delivery_date = date;
              }
              if(status=='end'||status=='refused'){
                getOrders('up_coming');
                ShopHomeProvider shopHomeProvider = getIt();
                shopHomeProvider.getStatistics();
              }

            } else {}

          }

        } else {}
      }
    } catch (e) {
      print('errorOrderUpdateStatus=>>>>$e');
    }
    notifyListeners();
  }

  void updateDeleiveryData(DateTime? date) {
    deliveryDateTime = date;

  }

}
