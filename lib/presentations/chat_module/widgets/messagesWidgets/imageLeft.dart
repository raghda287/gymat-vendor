import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import '../../../../core/app_colors/app_colors.dart';
import '../../../../core/app_theme/theme.dart';
import '../../../../core/dateFormat/dateFormat.dart';
import '../../../../core/navigator/navigator.dart';
import '../../../../data/models/messageModel.dart';
import '../../../../data/models/userChatModel.dart';
import '../../../show_image_screen/showImageScreen.dart';
import '../../../widgets/custom_network_image/custom_network_image.dart';
import '../../../widgets/custom_text/custom_text.dart';


class ImageLeft extends StatelessWidget {
  final MessageModel model;
  final UserChatModel? userChatModel;
  const ImageLeft({super.key, required this.model, this.userChatModel});

  @override
  Widget build(BuildContext context) {

    return Directionality(textDirection: ui.TextDirection.ltr,
        child:Row(children: [

          InkWell(
            onTap: (){
              NavigatorHandler.push(ShowImageScreen(url: model.file??'',dimens: model.dimensions,title:userChatModel?.name,));

            },
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              color: AppTheme.isDarkMode()?msgLeftDarkColor:Colors.white,
              elevation: 0.5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 1,vertical: 1),
                  constraints: const BoxConstraints(maxWidth: 180,minWidth: 100),
                  child: Stack(children: [
                    Card(
                        color: Colors.transparent,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        margin: EdgeInsets.zero,
                        child: AspectRatio(aspectRatio: model.dimensions!=null?model.dimensions!.toDouble():1,child:CustomNetworkImage(url: model.file,),)),
                    Positioned(
                        right: 8,
                        bottom: 4,
                        child: CustomText(title: CustomDateTimeFormat().getNowDate()==model.date?model.time??'':'${model.date??''} ${model.time??''}',fontColor: Colors.white,fontSize: 12))
                  ],)
              ),
            ),
          )
        ],));
  }



}
