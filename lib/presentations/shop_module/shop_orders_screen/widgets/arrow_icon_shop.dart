import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/data/models/generalOrderModel.dart';
import 'package:gymatvendor/injection.dart';
import 'package:gymatvendor/presentations/gym_module/provider/gym_order_provider.dart';
import 'package:gymatvendor/presentations/widgets/custom_svg/CustomSvgIcon.dart';

import '../../../healthcub_spa_module/provider/spa_order_provider.dart';
import '../../provider/shop_order_provider.dart';

class ArrowIconShop extends StatefulWidget {
  final GeneralOrderModel model;
  final int index ;
  const ArrowIconShop({super.key, required this.model, required this.index});

  @override
  State<ArrowIconShop> createState() => _ArrowIconShopState();
}

class _ArrowIconShopState extends State<ArrowIconShop> with TickerProviderStateMixin{
  late AnimationController _controller;

  bool isExpand = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(vsync: this,upperBound: .5,duration: const Duration(milliseconds: 150));
  }
  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween<double>(begin: 0.0,end: 1.0).animate(_controller),
      child: InkWell(
        splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: (){
            if(isExpand){
              _controller.reverse(from: 0.5);
            }else{
              _controller.forward(from: 0.0);

            }
            isExpand = !isExpand;

            widget.model.isExpanded = isExpand;
            ShopOrderProvider provider = getIt();
            provider.updateExpandedModel(widget.model, widget.index);
          },
          child: const CustomSvgIcon(assetName: 'up_arrow',width: 16,height: 16,color: greyColor,)),
    );

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }
}
