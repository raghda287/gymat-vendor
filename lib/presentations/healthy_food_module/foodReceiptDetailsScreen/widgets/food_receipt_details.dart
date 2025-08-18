import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/presentations/gym_module/gymReceiptDetailsScreen/widgets/service_order_item.dart';
import 'package:gymatvendor/presentations/healthcub_spa_module/spaReceiptDetailsScreen/widgets/service_order_item.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../core/app_colors/app_colors.dart';
import '../../../../core/app_theme/theme.dart';
import '../../../../core/number_format/numberFormat.dart';
import '../../../../data/models/foodOrderDetailsModel.dart';
import '../../../../data/models/gymOrderDetailsModel.dart';
import '../../../../data/models/spaOrderDetailsModel.dart';
import '../../../widgets/custom_avatar/custom_avatar.dart';
import '../../../widgets/custom_svg/CustomSvgIcon.dart';
import '../../../widgets/custom_text/custom_text.dart';
import 'food_service_order_item.dart';

class FoodReciptDetails extends StatelessWidget {
  final FoodOrderDetailsModel model;

  const FoodReciptDetails({super.key,required this.model});

  @override
  Widget build(BuildContext context) {

    return Container(
      color: AppTheme.isDarkMode()?Colors.black:Colors.white,
      child: SingleChildScrollView(
        child:Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomAvatar(radius: 24,url: model.market?.logo,),
                  const SizedBox(width: 4,),
                  CustomText(title: model.market?.business_name??'',fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,fontSize: 15,),

                ],
              ),
              const SizedBox(height: 4,),
              CustomText(title: (model.market?.desc??''),fontColor: greyColor,fontSize: 12),
              const SizedBox(height: 24,),
              QrImageView(data: '${model.id!}',size: 200,backgroundColor: Colors.white,),
              const SizedBox(height: 8,),
              CustomText(title:'${'Order Number:'.tr()} #${model.id!}',fontColor: greyColor,fontSize: 12),

              const SizedBox(height: 24,),

              Row(
                children: [

                  Expanded(
                      flex: 1,
                      child: CustomText(title: 'Address'.tr(),fontSize: 14,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,)),
                  Expanded(
                      flex: 3,
                      child: CustomText(textAlign: TextAlign.end,title: model.order?.address?.address??'',fontSize: 14,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,))
                ],
              ),
              const SizedBox(height: 16,),
              Row(
                children: [

                  Expanded(
                      flex: 1,
                      child: CustomText(title: 'Name'.tr(),fontSize: 14,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,)),
                  Expanded(
                      flex: 3,
                      child: CustomText(textAlign: TextAlign.end,title: model.user?.user?.name??'',fontSize: 14,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,))
                ],
              ),
              const SizedBox(height: 16,),
              Row(
                children: [

                  Expanded(
                      flex: 2,
                      child: CustomText(title: 'Phone number'.tr(),fontSize: 14,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,)),
                  Expanded(
                      flex: 4,
                      child: CustomText(textAlign: TextAlign.end,title: '${model.user?.user?.phone_code??''}${model.user?.user?.phone??''}',fontSize: 14,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,))
                ],
              ),
              const SizedBox(height: 16,),
              Row(
                children: [

                  Expanded(
                      flex: 2,
                      child: CustomText(title: 'Booking date'.tr(),fontSize: 14,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,)),
                  Expanded(
                      flex: 4,
                      child: CustomText(textAlign: TextAlign.end,title: model.date??'',fontSize: 14,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,))
                ],
              ),
              const SizedBox(height: 16,),

              Row(
                children: [

                  Expanded(
                      flex: 2,
                      child: CustomText(title: 'Booking time'.tr(),fontSize: 14,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,)),
                  Expanded(
                      flex: 4,
                      child: CustomText(textAlign: TextAlign.end,title: model.time??'',fontSize: 14,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,))
                ],
              ),

              const SizedBox(height: 16,),

              Row(
                children: [

                  Expanded(
                      flex: 2,
                      child: CustomText(title: 'Expected pick up date'.tr(),fontSize: 14,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,)),
                  Expanded(
                      flex: 4,
                      child: CustomText(textAlign: TextAlign.end,title: '${model.order?.date??''} ${model.order?.time??''}',fontSize: 13,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,))
                ],
              ),


              const SizedBox(height: 12,),
              Divider(color: AppTheme.isDarkMode()?dark:inputBg,),
              const SizedBox(height: 12,),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context,index){
                  return FoodServiceOrderItem(model: model.order!.details[index]);
                },itemCount: model.order!.details.length,),


              const SizedBox(height: 12,),

              Divider(color: AppTheme.isDarkMode()?dark:inputBg,),
              const SizedBox(height: 12,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(title: 'Total'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,fontSize: 13,),

                  Row(
                    children: [
                      CustomText(title:CustomNumberFormat.format(model.grand_total??0),fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,fontSize: 13,),

                      const SizedBox(width: 4,),

                      CustomSvgIcon(assetName: 'sar',width: 14,height: 14,color: AppTheme.isDarkMode()
                          ? Colors.white
                          : Colors.black,),

                    ],
                  )
                ],
              ),

            ],),
        ),
      ),
    );

  }
}
