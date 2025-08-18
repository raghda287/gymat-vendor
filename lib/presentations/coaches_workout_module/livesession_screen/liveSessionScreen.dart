import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/navigator/navigator.dart';
import 'package:gymatvendor/data/models/liveSessionModel.dart';
import 'package:gymatvendor/injection.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/livesession_screen/webview_livesession_screen.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/livesession_screen/widgets/live_session_item_widget2.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/provider/livesession_provider.dart';
import 'package:gymatvendor/presentations/widgets/loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../../core/dimens/dimens.dart';
import '../../../core/text_styles/text_styles.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';
import '../../widgets/custom_button/custom_button.dart';
import '../../widgets/custom_svg/CustomSvgIcon.dart';
import '../../widgets/custom_text/custom_text.dart';
import '../../widgets/loading_indicator/loading_indicator_gym.dart';
import '../home_screen/widgets/live_session_item_widget.dart';
import 'addLiveSessionScreen.dart';

class LiveSessionScreen extends StatefulWidget {
  const LiveSessionScreen({super.key});

  @override
  State<LiveSessionScreen> createState() => _LiveSessionScreenState();
}

class _LiveSessionScreenState extends State<LiveSessionScreen> {
  LiveSessionProvider liveSessionProvider = getIt();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    liveSessionProvider.initLiveSession();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      liveSessionProvider.getLiveSession();
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showToolBar: true,
        showBackArrow: true,
        title: 'Live sessions'.tr(),
        elevation: 1,
        isMainBack: true,
        bgColor: AppTheme.isDarkMode() ? dark : Colors.white,
      ),
      body: Consumer<LiveSessionProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              Expanded(
                child: provider.isLoading
                    ? const LoadingIndicatorGym()
                    : provider.liveSessions.isEmpty
                    ? Center(
                    child: CustomText(
                      title: 'No live sessions to show'.tr(),
                      fontColor: AppTheme.isDarkMode()
                          ? Colors.white
                          : Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ))
                    : NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification){
                    if(!provider.isLoadingMore && scrollNotification.metrics.pixels==scrollNotification.metrics.maxScrollExtent&&provider.liveSessions.length>=19){
                      provider.loadMoreLiveSession();
                    }
                    return false;
                  },
                      child: ListView.builder(
                      itemCount: provider.liveSessions.length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                      itemBuilder: (context, index) {
                        return provider.liveSessions[index]!=null? InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            onTap: () {
                              NavigatorHandler.push(AddLiveSessionScreen(
                                liveSessionModel: provider.liveSessions[index],
                              ));

                            },
                            onLongPress: () {
                              if(provider.liveSessions[index]!.status !=LiveSessionStatus.LIVE.name){
                                showSessionActionSheet(provider.liveSessions[index]!);

                              }
                            },
                            child: LiveSessionItemWidget2(model: provider.liveSessions[index]!,)):const SizedBox(height: 48,child: LoadingIndicator(width: 24,stroke: 2,));
                      }),
                    ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                child: CustomButton(
                    title: 'Add live session'.tr(),
                    onTap: () {
                      NavigatorHandler.push(const AddLiveSessionScreen());
                    }),
              )
            ],
          );
        },
      ),
    );

  }


  void showSessionActionSheet(LiveSessionModel model) {
    showModalBottomSheet(
        isDismissible: true,
        backgroundColor: AppTheme.isDarkMode() ? dark : Colors.white,
        context: context,
        builder: (context) {
          return SizedBox(
            width: Dimens.width,
            child: Padding(
              padding: EdgeInsets.only(
                  left: 12,
                  top: 12,
                  right: 12,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Center(
                    child: Container(
                      width: 54,
                      height: 4,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: AppTheme.isDarkMode()
                              ? greyColor.withOpacity(.2)
                              : greyColor.withOpacity(.5)),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  ListTile(
                    leading: CustomSvgIcon(
                      assetName: 'delete',
                      color:
                      AppTheme.isDarkMode() ? (model.status=='ended'||model.status =='expired')? Colors.white:greyColor.withOpacity(.8) :(model.status=='ended'||model.status =='expired')? Colors.black:greyColor.withOpacity(0.8),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          title: 'Delete'.tr(),
                          fontColor:
                          AppTheme.isDarkMode() ? (model.status=='ended'||model.status =='expired')? Colors.white:greyColor.withOpacity(.8) :(model.status=='ended'||model.status =='expired')? Colors.black:greyColor.withOpacity(0.8),
                          fontSize: 16,
                        ),
                        model.status != LiveSessionStatus.ENDED.name ||  model.status != LiveSessionStatus.ENDED.name? CustomText(
                          title: 'Delete live session is not available. the session is live now'.tr(),
                          fontColor:
                          AppTheme.isDarkMode() ? Colors.white:Colors.black,
                          fontSize: 11,
                        ):const SizedBox()
                      ],
                    ),
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    dense: true,
                    onTap: () async {

                      if(model.status==LiveSessionStatus.ENDED.name||model.status==LiveSessionStatus.EXPIRED.name){
                        NavigatorHandler.pop();
                        await Future.delayed(const Duration(milliseconds: 300));
                        createDeleteAlertDialog(model);
                      }



                    },
                  ),
                 if(model.status!=LiveSessionStatus.LIVE.name.toLowerCase())ListTile(
                    leading: CustomSvgIcon(
                      assetName: 'edit2',
                      width: 18,
                      height: 18,
                      color:
                      AppTheme.isDarkMode() ? Colors.white : Colors.black,
                    ),
                    title: CustomText(
                      title: 'Edit'.tr(),
                      fontColor:
                      AppTheme.isDarkMode() ? Colors.white : Colors.black,
                      fontSize: 16,
                    ),
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () async{
                      await NavigatorHandler.pop();
                      await Future.delayed(const Duration(milliseconds: 200));
                      NavigatorHandler.push(AddLiveSessionScreen(liveSessionModel: model,));

                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
          );
        });
  }

  void createDeleteAlertDialog(LiveSessionModel model) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            surfaceTintColor: Colors.transparent,
            backgroundColor: AppTheme.isDarkMode() ? dark : Colors.white,
            contentPadding: const EdgeInsets.all(12),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 12,
                ),
                Text.rich(TextSpan(text: '${'Delete'.tr()} ',
                    style: AppTextStyles().normalText(fontSize: 13).textColorNormal(AppTheme.isDarkMode()?greyColor:Colors.black),
                    children: [
                      TextSpan(text: model.getTitle(),style: AppTextStyles().normalText(fontSize: 17).textColorBold(AppTheme.isDarkMode()?Colors.white:Colors.black))
                    ]
                )),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: (){
                          NavigatorHandler.pop();
                        },
                        child: CustomText(
                          title: 'Cancel'.tr(),
                          fontSize: 14,
                          fontColor: greyColor,
                        )),
                    const SizedBox(
                      width: 12,
                    ),

                    TextButton(

                        onPressed:() async {
                          await NavigatorHandler.pop();
                          await Future.delayed(const Duration(milliseconds: 100));
                          LiveSessionProvider provider = getIt();
                          provider.deleteLiveSession(model.id!);


                        },
                        child: CustomText(
                          title: 'Delete'.tr(),
                          fontSize: 14,
                          fontColor: Colors.red,
                        )),
                  ],
                )
              ],
            ),
          );
        });
  }


}
