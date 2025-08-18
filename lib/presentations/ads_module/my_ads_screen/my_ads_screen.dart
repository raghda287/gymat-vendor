import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/navigator/navigator.dart';
import 'package:gymatvendor/presentations/ads_module/my_ads_screen/widgets/AdItem.dart';
import 'package:gymatvendor/presentations/ads_module/my_ads_screen/widgets/create_new_ad_widget.dart';
import 'package:gymatvendor/presentations/widgets/loading_indicator/loading_indicator_gym.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../../core/constants/constants.dart';
import '../../../injection.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';
import '../../widgets/custom_text/custom_text.dart';
import '../ad_details_screen/ad_details_screen.dart';
import '../ad_provider/ad_provider.dart';
import '../add_ad_screen/add_ad_screen.dart';
import 'widgets/custom_tab.dart';

class MyAdsScreen extends StatefulWidget {
  const MyAdsScreen({super.key});

  @override
  State<MyAdsScreen> createState() => _MyAdsScreenState();
}

class _MyAdsScreenState extends State<MyAdsScreen> {
  AdProvider adProvider = getIt();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    adProvider.initMyAds();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      adProvider.getAds('coming');

    });

  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: CustomAppBar(
          showToolBar: true,
          showBackArrow: true,
          isMainBack: true,
          title: 'Advertising'.tr(),
        ),
        body: Column(
          children: [
            Consumer<AdProvider>(
              builder: (context, provider, _) {
                return Column(
                  children: [
                    const SizedBox(
                      height: 24,
                    ),
                    Center(
                      child: Container(
                        width: 220,
                        height: 48,
                        padding: const EdgeInsets.only(left: 2,right: 2,top: 2),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: AppTheme.isDarkMode()?dark:mainColor,
                            borderRadius: BorderRadius.circular(24)),
                        child: TabBar(

                          dividerColor: Colors.transparent,
                          padding: EdgeInsets.zero,
                          indicatorColor: Colors.transparent,
                          dividerHeight: 0,
                          labelPadding: EdgeInsets.zero,
                          overlayColor: const MaterialStatePropertyAll<Color>(Colors.transparent),
                          onTap: (index) {
                            provider.updateSelectedIndex(index);
                            if(index==0){
                              provider.getAds('coming');
                            }else{
                              provider.getAds('old');

                            }
                          },
                          tabs: [
                            CustomTab(
                              title: 'Up coming'.tr(),
                              selected: provider.selectedIndex==0,
                            ),
                            CustomTab(
                              title: 'Complete'.tr(),
                              selected: provider.selectedIndex==1,
                            ),

                          ],
                          
                        ),
                      ),
                    ),
                    const SizedBox(height: 8,),



                  ],
                );
              },
            ),
            Expanded(child:Consumer<AdProvider>(builder: (context,provider,_){
              return provider.isLoadingAds? const LoadingIndicatorGym():provider.myAdsList.isNotEmpty?
              ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: provider.myAdsList.length,
                  shrinkWrap: false,
                  itemBuilder: (context,index){
                    return  InkWell(
                        onTap: (){
                          NavigatorHandler.push(AdDetailsScreen(adId: provider.myAdsList[index].id!,));
                        },
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        child: AdItem(model: provider.myAdsList[index],));
                  }):Center(child: CustomText(title: 'No ads to show'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,fontSize: 14,));
            })),
            const SizedBox(height: 8,),
            CreateNewAdWidget(onTap: (){
              NavigatorHandler.push(const AddAdScreen());
            }),
            const SizedBox(height: 8,),
          ],
        )),
    );

  }
}
