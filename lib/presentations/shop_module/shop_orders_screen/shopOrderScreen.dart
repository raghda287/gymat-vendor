import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/presentations/auth_module/provider/auth_provider.dart';
import 'package:gymatvendor/presentations/gym_module/gym_orders_screen/widgets/gym_order_item.dart';
import 'package:gymatvendor/presentations/gym_module/provider/gym_order_provider.dart';
import 'package:gymatvendor/presentations/healthy_food_module/food_orders_screen/widgets/food_order_item.dart';
import 'package:gymatvendor/presentations/shop_module/shop_orders_screen/widgets/shop_order_item.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../../core/navigator/navigator.dart';
import '../../../data/models/generalOrderModel.dart';
import '../../../injection.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';
import '../../widgets/custom_text/custom_text.dart';
import '../../widgets/loading_indicator/loading_indicator.dart';
import '../provider/shop_order_provider.dart';
import '../shop_order_details_screen/shopOrderDetailsScreen.dart';

class ShopOrderScreen extends StatefulWidget {
  final String orderType;
  const ShopOrderScreen({super.key,required this.orderType});

  @override
  State<ShopOrderScreen> createState() => _ShopOrderScreenState();
}

class _ShopOrderScreenState extends State<ShopOrderScreen> {
  ShopOrderProvider provider = getIt();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      provider.getOrders(widget.orderType);

    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(
        showToolBar: true,
        showBackArrow: true,
        title: 'Orders'.tr(),
        elevation: 1,
        isMainBack: true,
        bgColor: AppTheme.isDarkMode() ? dark : Colors.white,
      ),
      body: Consumer<ShopOrderProvider>(builder: (context,provider,_){
      return provider.isLoading?const LoadingIndicator(): provider.orders.isNotEmpty?
      ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemCount: provider.orders.length,
          shrinkWrap: true,
          itemBuilder: (context,index){
            GeneralOrderModel model = provider.orders[index];

            return InkWell(
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: (){
                  _onTap(model);
                },
                child: ShopOrderItem(model: model,index: index,));
          }):Center(child: CustomText(title: 'No orders to show'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,),);

    }),
    );


  }

  void _onTap(GeneralOrderModel model){
    if(model.market!=null&&model.market!.category.type==USERTYPE.market.name){
      NavigatorHandler.push(ShopOrderDetailsScreen(orderId: model.id!));
    }
  }
}
