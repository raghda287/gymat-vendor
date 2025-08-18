import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/presentations/widgets/custom_avatar/custom_avatar.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

import '../../../core/dateFormat/dateFormat.dart';
import '../../../core/number_format/numberFormat.dart';
import '../../../data/models/messageModel.dart';
import '../../../data/models/roomModel.dart';
import '../../widgets/custom_svg/CustomSvgIcon.dart';

class RoomItemWidget extends StatelessWidget {
  final RoomModel model;
  const RoomItemWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          CustomAvatar(radius: 48,url: model.user?.user?.photo,),
          const SizedBox(width: 12,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: 120,
                        child: CustomText(title: model.user?.user?.name,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,maxLines: 1,fontWeight: FontWeight.bold,fontSize: 15,)),
                    CustomText(title: model.latest_message!=null?CustomDateTimeFormat().getNowDate()==model.latest_message!.date?model.latest_message!.time:CustomDateTimeFormat().convertDateToCustomFormat(model.latest_message!.date!, 'd-M-yy'):'',fontSize: 12,fontColor: greyColor,maxLines: 1,)
                  ],
                ),
                const SizedBox(height: 4,),

                SizedBox(
                    width: 180,
                    child: Row(
                      children: [
                        if(model.latest_message?.type =='image'||model.latest_message?.type =='record') CustomSvgIcon(assetName:model.latest_message?.type =='image'?'gallery2':'mic2',width: 16,height: 16,color: model.latest_message?.type =='record'?mainColor: AppTheme.isDarkMode()?msgContentIconColorDark: greyColor,),
                        SizedBox(width: model.latest_message?.type =='image'||model.latest_message?.type =='record'?4:0,),
                        Expanded(child: CustomText(title: model.latest_message!=null?getMessageText(model.latest_message!):'',fontColor:AppTheme.isDarkMode()?msgContentIconColorDark: greyColor,maxLines: 1,)),
                      ],
                    )),

              ],),
          )
        ],
      ),
    );
  }

  String getMessageText(MessageModel model){
    if(model.type=='text'){
      return model.message??'';
    }else  if(model.type=='image'){
      return 'Photo'.tr();
    }else  if(model.type=='record'){
      return  CustomNumberFormat.durationFormat(model.seconds??0);
    }
    return '';
  }
}
