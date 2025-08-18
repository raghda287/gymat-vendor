import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound_record/flutter_sound_record.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/core/text_styles/text_styles.dart';
import 'package:gymatvendor/main.dart';
import 'package:gymatvendor/presentations/chat_module/widgets/emoji_picker.dart';
import 'package:gymatvendor/presentations/chat_module/widgets/record_timer_widget.dart';
import 'package:gymatvendor/presentations/widgets/custom_svg/CustomSvgIcon.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../data/models/userChatModel.dart';
import '../../../injection.dart';
import '../provider/chat_provider.dart';

class MessageContanerWidget extends StatefulWidget {
  final VoidCallback onPressed;
  final ValueChanged<bool> onEmojiShowing;
  final UserChatModel user;

  const MessageContanerWidget({super.key, required this.onPressed, required this.onEmojiShowing, required this.user});

  @override
  State<MessageContanerWidget> createState() => _MessageContanerWidgetState();
}

class _MessageContanerWidgetState extends State<MessageContanerWidget> {
  final TextEditingController controller = TextEditingController();
  String lang = navigatorKey.currentContext!.locale.languageCode;
  bool isTyping = false;
  FlutterSoundRecord recorder = FlutterSoundRecord();
  Timer? timer;
  int seconds = 0;
  bool isShowEmoji = false;
  FocusNode focusNode = FocusNode();
  bool isRecording = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isRecording = false;
    focusNode.addListener(() {
      if(focusNode.hasFocus){

        isShowEmoji = false;

        widget.onEmojiShowing(isShowEmoji);

        setState(() {

        });
      }
    });

  }


  void checkPermission() async {

    PermissionStatus microphonePermission = await Permission.microphone.status;
    PermissionStatus storagePermission = await Permission.storage.status;

    if(microphonePermission.isDenied||storagePermission.isDenied||microphonePermission.isPermanentlyDenied||storagePermission.isPermanentlyDenied){


      Map<Permission,PermissionStatus> mapPermission = await [Permission.microphone,Permission.storage].request();
      if(mapPermission[Permission.microphone]==PermissionStatus.granted&&mapPermission[Permission.storage] == PermissionStatus.granted){
        return;
      }else if(mapPermission[Permission.microphone]==PermissionStatus.denied&&mapPermission[Permission.storage] == PermissionStatus.denied){
        openAppSettings();
        return;
      }else if(mapPermission[Permission.microphone]==PermissionStatus.permanentlyDenied&&mapPermission[Permission.storage] == PermissionStatus.permanentlyDenied){
        openAppSettings();
        return;
      }else if(mapPermission[Permission.microphone]==PermissionStatus.denied||mapPermission[Permission.microphone]==PermissionStatus.permanentlyDenied){
        openAppSettings();
        return;
      }else if(mapPermission[Permission.storage]==PermissionStatus.denied||mapPermission[Permission.storage]==PermissionStatus.permanentlyDenied){
        openAppSettings();
        return;
      }

    }

  }


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: isRecording?64:null,
          padding: const EdgeInsets.only(left: 12,right: 12,top: 8,bottom: 8),
          color: AppTheme.isDarkMode()?msgLeftDarkColor:Colors.white,
          constraints: const BoxConstraints(minHeight: 48,maxHeight: 120),

          child: Row(
            children: [
              Expanded(child: isRecording?RecordTimerWidget(seconds: seconds,):
              TextFormField(
                focusNode: focusNode,
                maxLines: null,
                controller: controller,
                cursorColor: mainColor,
                style: AppTextStyles().normalText(fontSize: 16).textColorNormal(AppTheme.isDarkMode()?Colors.white:Colors.black),
                onChanged: (value){
                  if(value.isNotEmpty){
                    if(!isTyping){
                      isTyping = true;
                      setState(() {

                      });
                    }
                  }else{
                    if(isTyping){
                      isTyping = false;
                      setState(() {

                      });
                    }

                  }
                },
                decoration: InputDecoration(
                  hintStyle: AppTextStyles().normalText(fontSize: 16).textColorNormal(AppTheme.isDarkMode()?msgContentIconColorDark:msgContentIconColorLight),
                  hintText: 'Type a message...'.tr(),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  prefixIcon: SizedBox(
                      width: 24,
                      height: 24,
                      child: IconButton(onPressed: () {
                        focusNode.unfocus();
                        focusNode.canRequestFocus = false;
                        isShowEmoji =!isShowEmoji;
                        widget.onEmojiShowing(isShowEmoji);
                        setState(() {

                        });
                      }, icon: Icon(Icons.emoji_emotions_outlined,color: AppTheme.isDarkMode()?msgContentIconColorDark:msgContentIconColorLight,),)),

                ),

              )),
              SizedBox(
                width: isTyping?0:42,
                height: isTyping?0:42,
                child: GestureDetector(

                  onTapDown: (details) async{
                    await _start();
                  },
                  onTapUp: (details) async{
                    await _stop();

                  },
                  onPanEnd: (details) async{
                    await _stop();

                  },

                  child:  IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: null, icon: CustomSvgIcon(assetName:'mic',color: AppTheme.isDarkMode()?msgContentIconColorDark:msgContentIconColorLight,)),
                ),
              ),
              SizedBox(
                width: isTyping?0:42,
                height: isTyping?0:42,
                child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed:widget.onPressed, icon:  CustomSvgIcon(assetName:'camera',color: AppTheme.isDarkMode()?msgContentIconColorDark:msgContentIconColorLight,)),
              ),
              Visibility(
                visible: isTyping,
                child: IconButton(onPressed: (){

                  String text = controller.text.trim();
                  if(text.isEmpty){
                    return;
                  }
                  controller.clear();
                  ChatProvider provider = getIt();
                  provider.sendMessage(widget.user.room_id, 'text', text,0,null);
                  isTyping = false;
                  if(mounted){
                    setState(() {

                    });
                  }
                }, icon: Transform.scale(
                    scaleX: lang=='ar'?-1:1,
                    child: const CustomSvgIcon(assetName: 'send',color: mainColor,))),
              )

            ],
          ),
        ),
        EmojiPickerWidget(controller: controller,isShow: isShowEmoji, onEmojiTyping: (bool value) {
          if(!isTyping){
            isTyping = value;
            setState(() {
            });
          }

        },)
      ],
    );
  }


  Future<void> _start() async {
    try {
      PermissionStatus microphonePermission = await Permission.microphone.status;
      PermissionStatus storagePermission = await Permission.storage.status;

      if(microphonePermission.isDenied ||microphonePermission.isPermanentlyDenied||storagePermission.isDenied||storagePermission.isPermanentlyDenied){
        checkPermission();
        return;
      }


      final directory = await getApplicationDocumentsDirectory();

      await recorder.start(path: '${directory.path}/audio.aac', encoder: AudioEncoder.AAC);

      bool isRecording = await recorder.isRecording();
      setState(() {
        this.isRecording = isRecording;
      });
      if(isRecording){
        initTimer();

      }


    } catch (e) {
      print('recordingError=>>>$e');
    }
  }

  Future<void> _stop() async {

    final String? path = await recorder.stop();
    setState(() => isRecording = false);

    initTimer();

    if(path!=null&&seconds>1){
      ChatProvider provider = getIt();
      provider.sendMessage(widget.user.room_id, 'record', path,seconds,null);
    }

  }

  void initTimer(){

    timer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
      if(!isRecording){
        timer.cancel();
        this.timer= null;
        seconds = 0;
        setState(() {
        });

      }else{
        seconds++;
        setState(() {
        });

      }
    });
  }

  @override
  void dispose() async {
    if(isRecording){
      await _stop();
      setState(() {
      });

      initTimer();

    }
    super.dispose();
  }



}
