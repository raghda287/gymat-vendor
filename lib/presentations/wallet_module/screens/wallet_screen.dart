import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import 'package:provider/provider.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../../core/dimens/dimens.dart';
import '../../../core/number_format/numberFormat.dart';
import '../../../data/models/walletModel.dart';
import '../../../injection.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';
import '../../widgets/custom_svg/CustomSvgIcon.dart';
import '../../widgets/custom_text/custom_text.dart';
import '../../widgets/loading_indicator/loading_indicator.dart';
import '../../widgets/loading_indicator/loading_indicator_gym.dart';
import '../provider/wallet_provider.dart';
import '../widgets/walletHistoryItem.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  WalletProvider walletProvider = getIt();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    walletProvider.init();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      walletProvider.getBalance();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          showToolBar: true,
          showBackArrow: true,
          isMainBack: true,
          title: 'Wallet'.tr(),
          elevation: 1,
          bgColor: AppTheme.isDarkMode() ? dark : Colors.white,
        ),
        body: Consumer<WalletProvider>(builder: (context, provider, _) {
          return provider.isLoadingBalance
              ? const LoadingIndicatorGym()
              : LazyLoadScrollView(
                onEndOfPage: () {
                  if(!provider.isLoadingMore&&provider.walletDetailsList.length>=49){
                    provider.loadMoreBalance();
                  }


                },
                child: CustomScrollView(slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      SizedBox(
                        width: Dimens.width,
                        child: Card(
                          color: AppTheme.isDarkMode() ? dark : Colors.white,
                          elevation: 1,
                          margin: const EdgeInsets.all(16),
                          surfaceTintColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  title: 'Balance'.tr(),
                                  fontColor: AppTheme.isDarkMode()
                                      ? Colors.white.withOpacity(.5)
                                      : Colors.black,
                                  fontSize: 16,
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                CustomText(
                                  title: CustomNumberFormat.format(provider.balance),
                                  fontColor: AppTheme.isDarkMode()
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                const SizedBox(height: 8,),
                                CustomSvgIcon(assetName: 'sar',width: 14,height: 14,color: AppTheme.isDarkMode()
                                    ? Colors.white.withOpacity(.5)
                                    : Colors.black,)

                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: CustomText(title: 'History'.tr(),fontSize: 15,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,),
                      ),
                        const SizedBox(height: 16,),

                      ],),
                  ),
                  SliverList.builder(

                      itemBuilder: (context,index){
                        WalletDetails? model = provider.walletDetailsList[index];
                        if(model!=null){
                          return WalletHistoryItem(model: model,);

                        }else{
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: LoadingIndicator(width: 36,stroke: 3,),
                          );
                        }
                      },itemCount: provider.walletDetailsList.length)
                ],),
              );
        }));
  }
}
