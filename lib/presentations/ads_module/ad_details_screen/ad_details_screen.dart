import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/core/dimens/dimens.dart';
import 'package:gymatvendor/injection.dart';
import 'package:gymatvendor/presentations/ads_module/ad_details_screen/widgets/circle_step_widget.dart';
import 'package:gymatvendor/presentations/widgets/custom_asset_image/custom_asset_image.dart';
import 'package:gymatvendor/presentations/widgets/custom_rounded_image/custom_rounded_image.dart';
import 'package:gymatvendor/presentations/widgets/custom_svg/CustomSvgIcon.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';
import 'package:gymatvendor/presentations/widgets/loading_indicator/loading_indicator_ads.dart';
import 'package:gymatvendor/presentations/widgets/loading_indicator/loading_indicator_gym.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/constants.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/models/ad_model.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';
import '../ad_provider/ad_provider.dart';

class AdDetailsScreen extends StatefulWidget {
  final num adId;
  const AdDetailsScreen({super.key, required this.adId});

  @override
  State<AdDetailsScreen> createState() => _AdDetailsScreenState();
}

class _AdDetailsScreenState extends State<AdDetailsScreen> {
  AdProvider adProvider = getIt();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      adProvider.getAdDetails(widget.adId);
    });

  }
  @override
  Widget build(BuildContext context) {
    String lang = context.locale.languageCode;
    return Scaffold(
        appBar: CustomAppBar(
          showToolBar: true,
          showBackArrow: true,
          isMainBack: true,
          title: 'Advertising'.tr(),

        ),
        body: Consumer<AdProvider>(
          builder: (context, provider, _) {
            return provider.isLoadingAdDetails?const LoadingIndicatorAds():provider.adDetails!=null?SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  CustomText(
                    title: getAdStatus(provider.adDetails!),
                    fontColor: AppTheme.isDarkMode() ? Colors.white : mainColor,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  CustomText(
                    title: '${'Ad Number :'.tr()} #${provider.adDetails!.id}',
                    fontColor: greyColor,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                          color: AppTheme.isDarkMode() ? inputBgDark : inputBg,
                          borderRadius: BorderRadius.circular(8)),
                      child: CustomRoundedImage(url: provider.adDetails!.photo,width: Dimens.width, height:Dimens.height*16/9,),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Divider(
                    color: AppTheme.isDarkMode() ? inputBgDark : inputBg,
                  ),

                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.map_outlined,
                        color: AppTheme.isDarkMode() ? greyColor : Colors.black,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      CustomText(
                          title: 'Ad location'.tr(),
                          fontColor: AppTheme.isDarkMode()
                              ? Colors.white
                              : Colors.black),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: CustomText(
                          title: provider.adDetails!.address??'',
                          fontColor: greyColor,
                          fontSize: 13,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        color: AppTheme.isDarkMode() ? greyColor : Colors.black,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      CustomText(
                          title: 'Ad date and time'.tr(),
                          fontColor: AppTheme.isDarkMode()
                              ? Colors.white
                              : Colors.black),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: CustomText(
                          title: provider.adDetails!.created_at,
                          fontColor: greyColor,
                          fontSize: 13,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),

                  Divider(
                    color: AppTheme.isDarkMode() ? inputBgDark : inputBg,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  SizedBox(
                    height: 150,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                            top: 4,
                            child: CircleStepWidget(
                              selected: getAdSteps(provider.adDetails!)>=1,
                            )),
                        Positioned(
                            left: lang == 'ar' ? null : 24,
                            right: lang == 'en' ? null : 24,
                            child: CustomText(
                              title: 'Accepted'.tr(),
                              fontSize: 13,
                              fontColor: AppTheme.isDarkMode()
                                  ? Colors.white
                                  : Colors.black,
                            )),
                        Positioned(
                          top: 16,
                            left: lang == 'ar' ? null : 5.5,
                            right: lang == 'en' ? null : 5.5,
                            child: Container(
                              width: 1,
                              height: 46,
                              decoration: BoxDecoration(color: getAdSteps(provider.adDetails!)>=1?mainColor: AppTheme.isDarkMode()?Colors.white:greyColor.withOpacity(.3),borderRadius: BorderRadius.circular(.5)),
                            )),
                        Positioned(
                            top: 62,
                            child: CircleStepWidget(
                              selected: getAdSteps(provider.adDetails!)>=2,
                            )),
                        Positioned(
                          top: 58,
                            left: lang == 'ar' ? null : 24,
                            right: lang == 'en' ? null : 24,
                            child: CustomText(
                              title: 'The ad is published'.tr(),
                              fontSize: 13,
                              fontColor: AppTheme.isDarkMode()
                                  ? Colors.white
                                  : Colors.black,
                            )),
                        Positioned(
                            top: 74,
                            left: lang == 'ar' ? null : 5.5,
                            right: lang == 'en' ? null : 5.5,
                            child: Container(
                              width: 1,
                              height: 46,
                              decoration: BoxDecoration(color: getAdSteps(provider.adDetails!)>=2?mainColor: AppTheme.isDarkMode()?Colors.white:greyColor.withOpacity(.3),borderRadius: BorderRadius.circular(.5)),
                            )),
                        Positioned(
                            top: 120,
                            child: CircleStepWidget(
                              selected: getAdSteps(provider.adDetails!)==3,
                            )),
                        Positioned(
                            top: 116,
                            left: lang == 'ar' ? null : 24,
                            right: lang == 'en' ? null : 24,
                            child: CustomText(
                              title: 'Completed ad'.tr(),
                              fontSize: 13,
                              fontColor: AppTheme.isDarkMode()
                                  ? Colors.white
                                  : Colors.black,
                            )),



                      ],
                    ),
                  ),
                  Divider(
                    color: AppTheme.isDarkMode() ? inputBgDark : inputBg,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  CustomText(title: 'Ad summary'.tr(),fontSize: 16,fontWeight: FontWeight.bold,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,),
                  const SizedBox(height: 12,),
                  /*Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(title: 'Ad fee'.tr(),fontSize: 13,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,),
                      CustomText(title: '130.00 ${'SAR'.tr()}',fontSize: 13,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,),

                    ],
                  ),
                  const SizedBox(height: 12,),*/
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(title: 'Total'.tr(),fontSize: 13,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,),
                      Row(
                        children: [
                          CustomText(title: '${formatNumber(provider.adDetails!.price??0)}',fontSize: 13,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,),
                          const SizedBox(width: 4,),
                          CustomSvgIcon(assetName: 'sar',width: 14,height: 14,color: AppTheme.isDarkMode()?Colors.white:Colors.black,)

                        ],
                      ),

                    ],
                  ),

                  const SizedBox(
                    height: 24,
                  ),
                  Divider(
                    color: AppTheme.isDarkMode() ? inputBgDark : inputBg,
                  ),

                ],
              ),
            ):const SizedBox();
          },
        ));
  }

  String getAdStatus(AdModel model){
    DateTime from = DateUtil.parseStringToDate(model.from_date!, 'yyyy-MM-dd');
    DateTime to = DateUtil.parseStringToDate(model.to_date!, 'yyyy-MM-dd');
    DateTime now = DateUtil.currentDate();
    String n = DateUtil.parseDateToString(now, 'yyyy-MM-dd');
    if(model.is_accepted==false){
      return 'In progress'.tr();
    }else if(n ==model.from_date || n == model.to_date||from.isBefore(now)||now.isBefore(to)){
      return 'Published'.tr();

    }else if(to.isBefore(now)){
      return 'Completed ad'.tr();

    }
    return '';
  }

  int getAdSteps(AdModel model){
    DateTime from = DateUtil.parseStringToDate(model.from_date!, 'yyyy-MM-dd');
    DateTime to = DateUtil.parseStringToDate(model.to_date!, 'yyyy-MM-dd');
    DateTime now = DateUtil.currentDate();
    String n = DateUtil.parseDateToString(now, 'yyyy-MM-dd');
    if(model.is_accepted==false){
      return 0;
    }else if(model.is_accepted==true){
      return 1;
    } else if(n ==model.from_date || n == model.to_date||from.isBefore(now)||now.isBefore(to)){
      return 2;

    }else if(to.isBefore(now)){
      return 3;

    }
    return 0;
  }
}
