import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:ui' as ui;

import 'package:provider/provider.dart';

import '../../../../core/app_colors/app_colors.dart';
import '../../../../core/app_theme/theme.dart';
import '../../../../core/dateFormat/dateFormat.dart';
import '../../../../core/number_format/numberFormat.dart';
import '../../../../data/models/messageModel.dart';
import '../../../widgets/custom_text/custom_text.dart';
import '../../../widgets/dialogs/scaffold_messanger.dart';
import '../../provider/audio_provider.dart';

class AudioLeft extends StatelessWidget {
  final MessageModel model;
  final int index;

  const AudioLeft({super.key, required this.model, required this.index});

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: ui.TextDirection.ltr,
        child:Row(
          children: [
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              elevation: 0.5,
              color: AppTheme.isDarkMode()?msgLeftDarkColor:Colors.white,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(8)),
              child: Container(
                  constraints: const BoxConstraints(maxWidth: 230, minWidth: 200, minHeight: 70, maxHeight: 70),
                  child: Consumer<AudioProvider>(builder: (context, provider, _) {

                    return Stack(children: [
                      Container(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(

                                  constraints: const BoxConstraints(minWidth: 32,minHeight: 32,maxHeight: 32,maxWidth: 32),
                                ),
                                const SizedBox(width: 12,),

                                Expanded(
                                    child:Row(children: [
                                      Expanded(child: SvgPicture.asset('assets/images/svg/wave.svg',height: 30,color: msgContentIconColorDark.withOpacity(.5),)),
                                      const SizedBox(width: 2,),
                                      Expanded(child: SvgPicture.asset('assets/images/svg/wave.svg',height: 30,color: msgContentIconColorDark.withOpacity(.5),))
                                    ],)),






                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(title: CustomNumberFormat.durationFormat(provider.isPlaying&&provider.indexPlayedAudio==index?provider.playedSeconds.toInt():model.seconds??0),fontSize: 12,fontColor: msgLeftDateDarkColor,),

                                CustomText(title:CustomDateTimeFormat().getNowDate()==model.date?'${model.time}':'${model.date} ${model.time}',fontSize: 10,fontColor: msgLeftDateDarkColor,),

                              ],)
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(color: AppTheme.isDarkMode()?playedColorDark.withOpacity(.6):greyColor.withOpacity(.05),borderRadius: BorderRadius.circular(8)),
                        width:  provider.indexPlayedAudio==index?230*((provider.playedSeconds/model.seconds!)):0,
                      ),
                      Positioned(

                        left: 0,

                        child: IconButton(
                          onPressed: () async {
                            if (provider.isPlaying && provider.indexPlayedAudio == index) {

                              provider.pause();
                            } else {
                              if (model.file != null) {
                                provider.initAudio(index,model);
                              } else {
                                CustomScaffoldMessanger.showToast(
                                    title: 'Invalid source');
                              }
                            }
                          },
                          icon: Icon(
                            provider.isPlaying && index == provider.indexPlayedAudio
                                ? Icons.pause
                                : Icons.play_arrow_rounded,
                            color: msgLeftDateDarkColor,

                          ),
                          padding: EdgeInsets.zero,
                          iconSize: 32,

                        ),
                      )
                    ],);
                  })),
            )
          ],
        ));
  }
}
