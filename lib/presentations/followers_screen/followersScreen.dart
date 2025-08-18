import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/data/models/followerModel.dart';
import 'package:gymatvendor/injection.dart';
import 'package:gymatvendor/presentations/followers_screen/provider/followers_provider.dart';
import 'package:gymatvendor/presentations/followers_screen/widgets/followerItem.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';
import 'package:gymatvendor/presentations/widgets/loading_indicator/loading_indicator.dart';
import 'package:gymatvendor/presentations/widgets/loading_indicator/loading_indicator_gym.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors/app_colors.dart';
import '../../core/app_theme/theme.dart';
import '../widgets/custom_app_bar/custom_app_bar.dart';

class FollowersScreen extends StatefulWidget {
  const FollowersScreen({super.key});

  @override
  State<FollowersScreen> createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {
  FollowersProvider provider= getIt();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      provider.getFollowers();
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          showToolBar: true,
          showBackArrow: true,
          isMainBack: true,
          title: 'Followers2'.tr(),
          elevation: 1,
          bgColor: AppTheme.isDarkMode() ? dark : Colors.white,
        ),
        body: Consumer<FollowersProvider>(
          builder: (context,provider,_) {
            return provider.isLoading?const LoadingIndicatorGym():provider.followers.isEmpty?Center(child: CustomText(title: 'No followers to show'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,fontSize: 15,)):NotificationListener<ScrollNotification>(
              child: ListView.builder(itemCount: provider.followers.length, itemBuilder: (context,index){

              FollowerModel? model = provider.followers[index];
              if(model!=null){
                return FollowerItem(model: model,index: index,);
              }else{
                return const Padding(
                  padding: EdgeInsets.only(top: 16,bottom: 16),
                  child: LoadingIndicator(),
                );
              }


            }),onNotification: (notificiationScroll){
              if(!provider.isLoadingMore&&provider.followers.length>39&&notificiationScroll.metrics.pixels==notificiationScroll.metrics.maxScrollExtent){
                provider.loadMoreFollowers();
              }
              return false;
            },);
          }
        ));
  }
}
