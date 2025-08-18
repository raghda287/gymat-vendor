import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';


import '../../../../core/app_colors/app_colors.dart';
import '../../../../core/app_theme/theme.dart';
import '../../../../core/number_format/numberFormat.dart';
import '../../../../data/models/gymOrderDetailsModel.dart';
import '../../../../data/models/service_model.dart';
import '../../../widgets/custom_network_image/custom_network_image.dart';
import '../../../widgets/custom_svg/CustomSvgIcon.dart';
import '../../../widgets/custom_text/custom_text.dart';
import '../../../widgets/love_icon/love_icon.dart';

class ServiceOrderItem extends StatelessWidget {
  final GymOrderDetailsModel model ;
  const ServiceOrderItem({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      margin: const EdgeInsets.symmetric(horizontal: 12,vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(4),
                child: SizedBox(
                    width: 70,
                    height: 70*3/4,
                    child: AspectRatio(aspectRatio: 4/3,child: CustomNetworkImage(url: model.order?.service?.photo,),))
            ),
            Expanded(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(title: model.order?.service_option!=null?'${model.order?.service?.getTitle()} - ${model.order?.service_option?.getTitle()}':'${model.order?.service?.getTitle()}',fontColor: mainColor,fontSize: 14,maxLines: 1,),
                  const SizedBox(height: 8,),
                  Row(
                    children: [
                      CustomText(title: 'Price:'.tr(),fontColor: greyColor,fontSize: 12,maxLines: 1,),
                      const SizedBox(width: 4,),
                      CustomText(title: CustomNumberFormat.format(model.grand_total??0),fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,fontSize: 13,maxLines: 1,fontWeight: FontWeight.bold,),
                      const SizedBox(width: 4,),
                       CustomSvgIcon(assetName: 'sar',width: 14,height: 14,color:AppTheme.isDarkMode()?Colors.white:Colors.black,),

                    ],
                  )
              ],),
            )),

          ],
        ),
      ),
    );
  }
}
