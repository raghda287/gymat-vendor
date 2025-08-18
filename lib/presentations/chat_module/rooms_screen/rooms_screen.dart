import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/navigator/navigator.dart';
import 'package:gymatvendor/presentations/chat_module/chat_screen/chat_screen.dart';
import 'package:gymatvendor/presentations/chat_module/provider/chat_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../../data/models/roomModel.dart';
import '../../../data/models/userChatModel.dart';
import '../../../injection.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';
import '../../widgets/custom_text/custom_text.dart';
import '../../widgets/loading_indicator/loading_indicator.dart';
import '../widgets/room_item.dart';

class RoomsScreen extends StatefulWidget {
  const RoomsScreen({super.key});

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {

  ChatProvider chatProvider = getIt();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatProvider.initRooms();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      chatProvider.getRooms();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showToolBar: true,
        showBackArrow: true,
        title: 'Messages'.tr(),
        elevation: 1,
        isMainBack: true,
        bgColor: AppTheme.isDarkMode() ? dark : Colors.white,
      ),
      body: Consumer<ChatProvider>(
        builder: (context, provider, _) {
          return provider.isLoadingRooms
              ? const LoadingIndicator()
              : provider.rooms.isEmpty
              ? Center(
            child: CustomText(
              title: 'No conversation to show'.tr(),
              fontSize: 15,
              fontColor: AppTheme.isDarkMode()
                  ? Colors.white
                  : Colors.black,
            ),
          )
              : NotificationListener<ScrollNotification>(child:ListView.builder(
              itemCount: provider.rooms.length,
              itemBuilder: (context, index) {



                RoomModel? model = provider.rooms[index];

                if(model==null){
                  return const Center(child: Padding(
                    padding: EdgeInsets.only(top: 36,bottom: 36,),
                    child: LoadingIndicator(stroke: 2,),
                  ),);
                }else{
                  return InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      onTap: () {
                        chatProvider.updateSelectedRoom(model, index);
                        UserChatModel userChatModel = UserChatModel(model.user_id, model.user?.user?.name??'', model.user?.user?.photo,model.id);
                        NavigatorHandler.push(ChatScreen(chatUser: userChatModel));
                      },
                      child: RoomItemWidget(
                        model: model,
                      ));
                }


              }),onNotification: (notification){
            if(!provider.isLoadingMoreRooms&&provider.rooms.length>39&&notification.metrics.pixels==notification.metrics.maxScrollExtent){
              provider.loadMoreRooms();
            }
            return false;
          },);
        },
      ),
    );
  }
}
