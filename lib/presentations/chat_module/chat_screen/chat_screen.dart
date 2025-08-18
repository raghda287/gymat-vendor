import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/navigator/navigator.dart';
import 'package:gymatvendor/core/utils/preferences.dart';
import 'package:gymatvendor/data/models/chatNotificationHandler.dart';
import 'package:gymatvendor/injection.dart';
import 'package:gymatvendor/main.dart';
import 'package:gymatvendor/presentations/auth_module/provider/auth_provider.dart';
import 'package:gymatvendor/presentations/chat_module/provider/chat_provider.dart';
import 'package:gymatvendor/presentations/chat_module/user_profile_screen/userProfileScreen.dart';
import 'package:gymatvendor/presentations/chat_module/widgets/emoji_picker.dart';
import 'package:gymatvendor/presentations/chat_module/widgets/media_chooser_widget.dart';
import 'package:gymatvendor/presentations/chat_module/widgets/message_container_widget.dart';
import 'package:gymatvendor/presentations/chat_module/widgets/messagesWidgets/audioRight.dart';
import 'package:gymatvendor/presentations/profile_module/provider/profile_provider.dart';
import 'package:gymatvendor/presentations/widgets/custom_asset_image/custom_asset_image.dart';
import 'package:gymatvendor/presentations/widgets/custom_avatar/custom_avatar.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';
import 'package:gymatvendor/presentations/widgets/dialogs/scaffold_messanger.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../../data/models/messageModel.dart';
import '../../../data/models/userChatModel.dart';
import 'package:image/image.dart' as img;

import '../../widgets/custom_svg/CustomSvgIcon.dart';
import '../../widgets/loading_indicator/loading_indicator.dart';
import '../provider/audio_provider.dart';
import '../widgets/downScrollButton.dart';
import '../widgets/messagesWidgets/audioLeft.dart';
import '../widgets/messagesWidgets/imageLeft.dart';
import '../widgets/messagesWidgets/imageRight.dart';
import '../widgets/messagesWidgets/messageLeft.dart';
import '../widgets/messagesWidgets/messageRight.dart';


class ChatScreen extends StatefulWidget {
  final UserChatModel chatUser;

  const ChatScreen({super.key, required this.chatUser});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin, WidgetsBindingObserver {
  ChatProvider provider = getIt();
  ProfileProvider profileProvider = getIt();
  Preferences preferences = Preferences();

  late AnimationController _controller;
  late Animation<double> _animation;
  late bool isEmojiShowing;
  String lang = navigatorKey.currentContext!.locale.languageCode;
  AppLifecycleState? appLifecycleState;
  ScrollController scrollController = ScrollController();

  bool showScrollDown = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    provider.initChat();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      provider.createChatRoom(widget.chatUser.id!, widget.chatUser.name, widget.chatUser.image, widget.chatUser.room_id);
      preferences.saveChatNotificationData(ChatNotificationHandler(widget.chatUser.room_id, false));

    });
    isEmojiShowing = false;
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInCirc);


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        backgroundColor: AppTheme.isDarkMode() ? dark : white,
        titleSpacing: 0,
        title: Row(
          children: [
            CustomAvatar(
              radius: 42,
              url: widget.chatUser.image,
            ),
            const SizedBox(
              width: 12,
            ),
            SizedBox(
              width: 140,
              child: CustomText(
                title: widget.chatUser.name ?? '',
                fontSize: 16,
                fontColor: AppTheme.isDarkMode() ? Colors.white : Colors.black,
                maxLines: 1,
              ),
            )
          ],
        ),
        actions: profileProvider.getUserModel()?.providerModel?.mainAccount?.category.type == USERTYPE.coache.name?[
          IconButton(onPressed: (){
            provider.createChatVideoUrl(widget.chatUser.room_id,widget.chatUser.id);
          }, icon: const CustomSvgIcon(assetName: 'create_video',width: 26,height: 26,color: mainColor,)),

          IconButton(onPressed: (){
            NavigatorHandler.push(UserProfileScreen(userId: widget.chatUser.id,));

          }, icon: const CustomSvgIcon(assetName: 'info',width: 26,height: 26,color: mainColor,)),

        ]:[],
      ),
      backgroundColor: AppTheme.isDarkMode() ? Colors.black : inputBg,
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onPanDown:(details){
                if (_controller.status == AnimationStatus.forward || _controller.status == AnimationStatus.completed) {
                  _controller.reverse();
                }
              },
              child: Stack(
                children: [
                  Opacity(
                    opacity: AppTheme.isDarkMode()? 0.45:0.8,
                    child: CustomAssetImage(
                      assetName: AppTheme.isDarkMode() ? 'chat_bg_dark' : 'chat_bg_white',
                      width: 512,
                      height: 1024,
                    ),
                  ),
                  Consumer<ChatProvider>(
                    builder: (context, provider, _) {
                      return NotificationListener<ScrollNotification>(
                        child: ListView.builder(
                          controller: scrollController,
                            shrinkWrap: true,
                            reverse: true,
                            itemCount: provider.messages.length,
                            itemBuilder: (context, index) {
                              MessageModel? messageModel = provider.messages[index];
                              if(messageModel!=null){
                                if(messageModel.sender=='user'){
                                  if(messageModel.type=='text'){
                                    return MessageLeft(model: messageModel);

                                  }else if(messageModel.type=='image'){
                                    return ImageLeft(model: messageModel,userChatModel: widget.chatUser);
                                  }else{
                                    return AudioLeft(model: messageModel, index: index,);

                                  }
                                }else{

                                  if(messageModel.type=='text'){
                                    return MessageRight(model: messageModel);

                                  }else if(messageModel.type=='image'){
                                    return ImageRight(model: messageModel,userChatModel: widget.chatUser);
                                  }else{
                                    return AudioRight(model: messageModel, index: index,);

                                  }


                                }
                              }else{
                                return SizedBox(width: 36,height: 36,
                                  child: Card(
                                    surfaceTintColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: const Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: CircularProgressIndicator(color: mainColor,strokeWidth: 3,),
                                    ),
                                  ),
                                );
                              }


                            }),
                        onNotification: (scrollNotification){
                          if(scrollNotification.metrics.pixels>300&&!showScrollDown){
                            showScrollDown = true;
                            if(mounted){
                              setState(() {

                              });
                            }
                          }else if(scrollNotification.metrics.pixels==0&&showScrollDown){
                            showScrollDown = false;
                            if(mounted){
                              setState(() {

                              });
                            }
                          }
                          if(!provider.isLoadingMoreMessages&&provider.messages.length>39&&scrollNotification.metrics.pixels == scrollNotification.metrics.maxScrollExtent){
                            provider.loadMoreMessages();
                          }
                          return false;
                        },
                      );
                    },
                  ),
                  Positioned(
                      bottom: 0,
                      left: lang == 'ar' ? 0 : null,
                      right: lang == 'ar' ? null : 0,
                      child: Consumer<ChatProvider>(
                        builder: (context, provider, _) {
                          return MediaChooseWidget(
                            animation: _animation,
                            onCameraPressed: () async {
                              if (_controller.status == AnimationStatus.forward || _controller.status == AnimationStatus.completed) {
                                await _controller.reverse();
                              }

                              await Future.delayed(const Duration(seconds: 1));

                              var status = await Permission.camera.status;

                              if(status.isDenied){
                                var st = await Permission.camera.request();
                                if(st.isDenied){
                                  CustomScaffoldMessanger.showToast(title: 'Access camera denied'.tr());
                                  return;
                                }else if(st.isPermanentlyDenied){
                                  openAppSettings();
                                  return;
                                }
                              }else if(status.isPermanentlyDenied){
                                openAppSettings();
                                return;
                              }


                              String? path = await provider.pickImage(ImageSource.camera);
                              if (path != null) {
                                var imageBytes = await File(path).readAsBytes();
                                final decodedImage = img.decodeImage(imageBytes);
                                double aspectRatio = 1;
                                if(decodedImage!=null){
                                  aspectRatio = decodedImage.width/decodedImage.height;
                                }

                                ChatProvider provider = getIt();
                                provider.sendMessage(
                                    widget.chatUser.room_id, 'image', path,0,aspectRatio);
                              }
                            },
                            onGalleryPressed: () async {
                              if (_controller.status == AnimationStatus.forward ||
                                  _controller.status ==
                                      AnimationStatus.completed) {
                                await _controller.reverse();

                              }

                              await Future.delayed(const Duration(seconds: 1));


                              String? path = await provider.pickImage(ImageSource.gallery);
                              if (path != null) {
                                var imageBytes = await File(path).readAsBytes();
                                final decodedImage = img.decodeImage(imageBytes);
                                double aspectRatio = 1;
                                if(decodedImage!=null){
                                  aspectRatio = decodedImage.width/decodedImage.height;
                                }

                                ChatProvider provider = getIt();
                                provider.sendMessage(
                                    widget.chatUser.room_id, 'image', path,0,aspectRatio);
                              }
                            },
                          );
                        },
                      )),
                  Positioned(
                      top: 0,
                      bottom: 0,
                      left:0,
                      right: 0,
                      child: Consumer<ChatProvider>(
                        builder: (context, provider, _) {
                          return provider.isLoading?const LoadingIndicator():const SizedBox();
                        },
                      )),
                  Positioned(
                      bottom: 16,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: DownScrollButton(show: showScrollDown, onPressed: () {
                          scrollController.animateTo(scrollController.position.minScrollExtent, duration: const Duration(milliseconds: 1), curve: Curves.easeIn);
                        },),
                      ))
                ],
              ),
            ),
          ),
          profileProvider.getUserModel()?.providerModel?.mainAccount?.is_message==true?MessageContanerWidget(
            onPressed: () {
              if (_controller.status == AnimationStatus.forward || _controller.status == AnimationStatus.completed) {
                _controller.reverse();
              } else {
                _controller.forward();
              }
            },
            onEmojiShowing: (bool value) {
              isEmojiShowing = value;
            },
            user: widget.chatUser,
          ):
          Container(
            color: AppTheme.isDarkMode()?dark:Colors.white,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 16),
            child: Row(
              children: [
                CustomSvgIcon(assetName: 'info'.tr(),color: Colors.amber,),
                const SizedBox(width: 12,),
                Expanded(child: CustomText(title: 'Cannot send message at the moment'.tr(),fontSize: 12,fontColor: AppTheme.isDarkMode()?Colors.white:mainColor,)),
              ],
            ),
          )
          ,
        ],
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    appLifecycleState = state;
    ChatNotificationHandler? chatData = preferences.getChatNotificationData();

    if(state==AppLifecycleState.resumed){
      if(chatData!=null){
        chatData.showNotification = false;
        preferences.saveChatNotificationData(chatData);
      }
    }else{
      if(chatData!=null){
        chatData.showNotification = true;
        preferences.saveChatNotificationData(chatData);
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    AudioProvider audioProvider = getIt();
    if(audioProvider.isPlaying){
      audioProvider.audioPlayer.stop();
      audioProvider.dispose();
    }

    WidgetsBinding.instance.removeObserver(this);
    preferences.clearChatNotificationData();

    super.dispose();
  }
}