import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/presentations/auth_module/provider/auth_provider.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/coachOrderDetailsScreen/coachOrderDetailsScreen.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/coach_orders_screen/widgets/coach_order_item.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/provider/coach_order_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../../core/navigator/navigator.dart';
import '../../../data/models/generalOrderModel.dart';
import '../../../injection.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';
import '../../widgets/custom_text/custom_text.dart';
import '../../widgets/loading_indicator/loading_indicator.dart';

class CoachOrderScreen extends StatefulWidget {
  final String orderType;
  const CoachOrderScreen({super.key,required this.orderType});

  @override
  State<CoachOrderScreen> createState() => _CoachOrderScreenState();
}

class _CoachOrderScreenState extends State<CoachOrderScreen> {
  CoachOrderProvider provider = getIt();
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
      body: Consumer<CoachOrderProvider>(builder: (context,provider,_){
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
                child: CoachOrderItem(model: model,index: index,));
          }):Center(child: CustomText(title: 'No orders to show'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,),);

    }),
    );


  }

  void _onTap(GeneralOrderModel model){
    if(model.market!=null&&model.market!.category.type==USERTYPE.coache.name){
      NavigatorHandler.push(CoachOrderDetailsScreen(orderId: model.id!));
    }
  }
}
