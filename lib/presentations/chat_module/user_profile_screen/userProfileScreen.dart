import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/presentations/chat_module/provider/chat_provider.dart';
import 'package:gymatvendor/presentations/chat_module/user_profile_screen/nutritions.dart';
import 'package:gymatvendor/presentations/widgets/custom_avatar/custom_avatar.dart';
import 'package:gymatvendor/presentations/widgets/custom_svg/CustomSvgIcon.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';
import 'package:gymatvendor/presentations/widgets/loading_indicator/loading_indicator_gym.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../../injection.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';
import 'activities.dart';
import 'fitness_watch.dart';

class UserProfileScreen extends StatefulWidget {
  final num? userId;

  const UserProfileScreen({super.key, this.userId});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> with SingleTickerProviderStateMixin{
  ChatProvider chatProvider = getIt();
  late TabController _tabController;
  int selectedTabIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    chatProvider.initUserProfile();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      chatProvider.getUserProfile(widget.userId);
    });

    _tabController.addListener(() {
      selectedTabIndex = _tabController.index;
      if(mounted){
        setState(() {

        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showToolBar: true,
        showBackArrow: true,
        isMainBack: true,
        title: 'Profile'.tr(),
        centerTitle: false,
        elevation: 0,
        bgColor: AppTheme.isDarkMode() ? dark : Colors.white,
      ),
      body: Consumer<ChatProvider>(builder: (context, provider, _) {
        return provider.isLoadingUserProfile
            ? const LoadingIndicatorGym()
            : provider.userProfileModel != null
                ? NestedScrollView(
                    headerSliverBuilder: (context, _) {
                      return [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                            child: Column(
                              children: [

                                Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: mainColor, width: 1.5)),
                                  child: CustomAvatar(
                                    radius: 80,
                                    url: provider.userProfileModel!.user?.photo,
                                  ),
                                ),
                                const SizedBox(height: 8,),
                                Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 4),
                                    constraints: const BoxConstraints(maxWidth: 180),
                                    child: CustomText(title: provider.userProfileModel!.user?.name??'',fontSize: 16,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,maxLines: 1)),
                                const SizedBox(height: 24,),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        CustomText(title: '${provider.userProfileModel!.user?.age??0} ${'Y'.tr()}',fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,fontSize: 14,fontWeight: FontWeight.bold,),
                                        const SizedBox(height: 4,),
                                        CustomText(title: 'Age'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black.withOpacity(.7),fontSize: 14,)

                                      ],),
                                    Container(color: greyColor.withOpacity(0.2),height: 36,width: 1,),
                                    
                                    Column(
                                      children: [
                                        CustomText(title: '${provider.userProfileModel!.user?.height??0} ${'cm'.tr()}',fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,fontSize: 14,fontWeight: FontWeight.bold,),
                                        const SizedBox(height: 4,),
                                        CustomText(title: 'Height'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black.withOpacity(0.7),fontSize: 14,)

                                      ],),
                                    Container(color: greyColor.withOpacity(0.2),height: 36,width: 1,),

                                    Column(
                                      children: [
                                        CustomText(title: '${provider.userProfileModel!.user?.weight??0} ${'kg'.tr()}',fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,fontSize: 14,fontWeight: FontWeight.bold,),
                                        const SizedBox(height: 4,),
                                        CustomText(title: 'Weight'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black.withOpacity(0.7),fontSize: 14,)

                                      ],),


                                  ],
                                ),

                                const SizedBox(height: 16,),


                              ],
                            ),
                          ),
                        ),
                        SliverPersistentHeader(delegate: SliverDelegate(TabBar(
                            controller: _tabController,
                            dividerColor: AppTheme.isDarkMode()?greyColor.withOpacity(.1):greyColor.withOpacity(0.1),
                            dividerHeight: 1,
                            indicatorColor: AppTheme.isDarkMode()?Colors.white:Colors.black,
                            indicatorWeight: 1,
                            padding: EdgeInsets.zero,

                            indicatorSize: TabBarIndicatorSize.label,
                            onTap: (index){
                             /* selectedTabIndex = index;
                              if(mounted){
                                setState(() {

                                });
                              }*/
                            },
                            tabs: [
                              Tab(icon:
                              SizedBox(
                                  width:48,
                                  child: CustomSvgIcon(assetName: selectedTabIndex==0?'activity_fill':'activity_empty',color: AppTheme.isDarkMode()?selectedTabIndex==0?Colors.white:Colors.white.withOpacity(.6):selectedTabIndex==0?Colors.black:greyColor.withOpacity(.8),)),),
                              SizedBox(
                                  width: 48,
                                  child: Tab(icon: CustomSvgIcon(assetName: selectedTabIndex==1?'nutrition_fill':'nutrition_empty',color: AppTheme.isDarkMode()?selectedTabIndex==1?Colors.white:Colors.white.withOpacity(.6):selectedTabIndex==1?Colors.black:greyColor.withOpacity(.8),),)),
                              Tab(icon:
                              SizedBox(
                                  width:48,
                                  child: CustomSvgIcon(assetName: selectedTabIndex==2?'fill_fitness':'empty_fitness',color: AppTheme.isDarkMode()?selectedTabIndex==2?Colors.white:Colors.white.withOpacity(.6):selectedTabIndex==2?Colors.black:greyColor.withOpacity(.8),)),),
                            ])),pinned: true,floating: true)
                      ];
                    },
                    body: TabBarView(

                      controller: _tabController,

                      children: [
                        Activities(activities: provider.userProfileModel!.goals!=null?provider.userProfileModel!.goals!.activities:[], totalCalories:provider.userProfileModel!.goals!=null?provider.userProfileModel!.goals!.goals!.activity_calories??0:0 ,),
                        Nutritions(nutritions: provider.userProfileModel!.goals!=null?provider.userProfileModel!.goals!.nutritions:[],totalCalories:provider.userProfileModel!.goals!=null?provider.userProfileModel!.goals!.goals!.nutrition_calories??0:0),
                        FitnessWatch(model: provider.userProfileModel!.goals,)


                    ],))
                : const SizedBox();
      }),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.removeListener(() { });
    _tabController.dispose();
    super.dispose();

  }

}

class SliverDelegate extends SliverPersistentHeaderDelegate{
  final TabBar _tabBar;


  SliverDelegate(this._tabBar);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
        color: AppTheme.isDarkMode()?Colors.black:Colors.white,
        child: _tabBar);
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  // TODO: implement minExtent
  double get minExtent => _tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
   return true;
  }

}
