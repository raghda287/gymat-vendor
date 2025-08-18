import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/dimens/dimens.dart';
import 'package:gymatvendor/core/navigator/navigator.dart';
import 'package:gymatvendor/core/text_styles/text_styles.dart';
import 'package:gymatvendor/data/models/chart_model.dart';
import 'package:gymatvendor/data/models/goalModel.dart';
import 'package:gymatvendor/injection.dart';
import 'package:gymatvendor/main.dart';
import 'package:gymatvendor/presentations/growth_module/provider/provider.dart';
import 'package:gymatvendor/presentations/growth_module/widgets/card_earning_placeholder_widget.dart';
import 'package:gymatvendor/presentations/growth_module/widgets/card_statistics_placeholder_widget.dart';
import 'package:gymatvendor/presentations/growth_module/widgets/chart_month.dart';
import 'package:gymatvendor/presentations/growth_module/widgets/chart_week.dart';
import 'package:gymatvendor/presentations/growth_module/widgets/chart_year.dart';
import 'package:gymatvendor/presentations/widgets/custom_button/custom_button.dart';
import 'package:gymatvendor/presentations/widgets/custom_svg/CustomSvgIcon.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';
import 'package:gymatvendor/presentations/widgets/custom_text_form/custom_text_form.dart';
import 'package:gymatvendor/presentations/widgets/dialogs/scaffold_messanger.dart';
import 'package:gymatvendor/presentations/widgets/loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors/app_colors.dart';
import '../../core/app_theme/theme.dart';
import '../widgets/custom_app_bar/custom_app_bar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'widgets/card_earning_widget.dart';
import 'widgets/card_statistics_widget.dart';

class GrowthScreen extends StatefulWidget {
  const GrowthScreen({super.key});

  @override
  State<GrowthScreen> createState() => _GrowthScreenState();
}

class _GrowthScreenState extends State<GrowthScreen> {
  GrowthProvider growthProvider = getIt();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    growthProvider.init();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      growthProvider.getCharts();
      growthProvider.getGoalsAndBooking();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showToolBar: true,
        showBackArrow: true,
        title: 'Data'.tr(),
        elevation: 1,
        isMainBack: true,
        bgColor: AppTheme.isDarkMode() ? dark : Colors.white,
      ),
      body: Consumer<GrowthProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                const SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CustomButton(
                          width: 120,
                          title: 'Goals'.tr(),
                          height: 48,
                          radius: 24,
                          onTap: () async {
                            GoalModel? goal = await growthProvider.getGoals();
                            creatGoalSheet(goal);
                          },
                        ),
                        CustomText(
                          title: 'Add or edit your goals'.tr(),
                          fontColor:
                              AppTheme.isDarkMode() ? Colors.white : greyColor,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  children: [
                    const CustomSvgIcon(
                      assetName: 'growth',
                      width: 16,
                      height: 16,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    CustomText(
                      title: 'Growth Chart'.tr(),
                      fontSize: 16,
                      fontColor: mainColor,
                      fontWeight: FontWeight.bold,
                    )
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                SizedBox(
                  height: Dimens.height * .38,
                  width: Dimens.width,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    elevation: 1.5,
                    surfaceTintColor: Colors.transparent,
                    color: AppTheme.isDarkMode() ? inputBgDark : Colors.white,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 1),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomButton(
                                title: 'This week'.tr(),
                                onTap: () {
                                  provider.updateGrowthFilter(
                                      GrowthFilterType.thisWeek.name);
                                },
                                width: 92,
                                height: 32,
                                radius: 4,
                                borderWidth: 1,
                                bg: provider.growthFilter ==
                                        GrowthFilterType.thisWeek.name
                                    ? mainColor
                                    : Colors.transparent,
                                borderColor: provider.growthFilter ==
                                        GrowthFilterType.thisWeek.name
                                    ? Colors.transparent
                                    : AppTheme.isDarkMode()
                                        ? Colors.white.withOpacity(.2)
                                        : mainColor,
                                fontColor: provider.growthFilter ==
                                        GrowthFilterType.thisWeek.name
                                    ? Colors.white
                                    : AppTheme.isDarkMode()
                                        ? Colors.white
                                        : Colors.black,
                                fontSize: 12,
                              ),
                              CustomButton(
                                title: 'This month'.tr(),
                                onTap: () {
                                  provider.updateGrowthFilter(
                                      GrowthFilterType.thisMonth.name);
                                },
                                width: 92,
                                height: 32,
                                radius: 4,
                                borderWidth: 1,
                                bg: provider.growthFilter ==
                                        GrowthFilterType.thisMonth.name
                                    ? mainColor
                                    : Colors.transparent,
                                borderColor: provider.growthFilter ==
                                        GrowthFilterType.thisMonth.name
                                    ? Colors.transparent
                                    : AppTheme.isDarkMode()
                                        ? Colors.white.withOpacity(.2)
                                        : mainColor,
                                fontColor: provider.growthFilter ==
                                        GrowthFilterType.thisMonth.name
                                    ? Colors.white
                                    : AppTheme.isDarkMode()
                                        ? Colors.white
                                        : Colors.black,
                                fontSize: 12,
                              ),
                              CustomButton(
                                title: DateTime.now().year.toString(),
                                onTap: () {
                                  provider.updateGrowthFilter(
                                      GrowthFilterType.thisYear.name);
                                },
                                width: 92,
                                height: 32,
                                radius: 4,
                                borderWidth: 1,
                                bg: provider.growthFilter ==
                                        GrowthFilterType.thisYear.name
                                    ? mainColor
                                    : Colors.transparent,
                                borderColor: provider.growthFilter ==
                                        GrowthFilterType.thisYear.name
                                    ? Colors.transparent
                                    : AppTheme.isDarkMode()
                                        ? Colors.white.withOpacity(.2)
                                        : mainColor,
                                fontColor: provider.growthFilter ==
                                        GrowthFilterType.thisYear.name
                                    ? Colors.white
                                    : AppTheme.isDarkMode()
                                        ? Colors.white
                                        : Colors.black,
                                fontSize: 12,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Expanded(
                              child: provider.isLoadingCharts
                                  ? const Center(
                                      child: LoadingIndicator(),
                                    )
                                  : provider.growthFilter ==
                                          GrowthFilterType.thisWeek.name
                                      ? ChartWeekWidget(
                                          dataSeries: provider.chartData,
                                        )
                                      : provider.growthFilter ==
                                              GrowthFilterType.thisMonth.name
                                          ? ChartMonthWidget(
                                              dataSeries: provider.chartData,
                                            )
                                          : provider.growthFilter ==
                                                  GrowthFilterType.thisYear.name
                                              ? ChartYearWidget(
                                                  dataSeries:
                                                      provider.chartData,
                                                )
                                              : const SizedBox())
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                provider.isLoadingGoalsAndBooking||provider.goalsBookingData==null?
                const Row(
                  children: [
                    Expanded(
                        child: CardEarningPlaceholderWidget()),
                    Expanded(
                        child: CardEarningPlaceholderWidget()),
                    Expanded(
                        child: CardEarningPlaceholderWidget())
                  ],
                ) :Row(
                  children: [
                    Expanded(
                        child: CardEarningWidget(
                          day: 'today',
                          percentage: provider.goalsBookingData!.goal?.today?.percent??0.0,
                          total: provider.goalsBookingData!.goal?.today?.value??0.0,
                        )),
                    Expanded(
                        child: CardEarningWidget(
                          day: 'month',
                          percentage: provider.goalsBookingData!.goal?.month?.percent??0.0,
                          total: provider.goalsBookingData!.goal?.month?.value??0.0,
                        )),
                    Expanded(
                        child: CardEarningWidget(
                          day: 'year',
                          percentage: provider.goalsBookingData!.goal?.year?.percent??0.0,
                          total: provider.goalsBookingData!.goal?.year?.value??0.0,
                        ))
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  children: [
                    const CustomSvgIcon(
                      assetName: 'booking',
                      width: 16,
                      height: 16,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    CustomText(
                      title: 'Number of bookings'.tr(),
                      fontSize: 16,
                      fontColor: mainColor,
                      fontWeight: FontWeight.bold,
                    )
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),

                provider.isLoadingGoalsAndBooking||provider.goalsBookingData==null?
                const Row(
                  children: [
                    Expanded(
                        child: CardStatisticsPlaceholderWidget()),
                    Expanded(
                        child: CardStatisticsPlaceholderWidget()),
                    Expanded(
                        child: CardStatisticsPlaceholderWidget())
                  ],
                )
                    : Row(
                  children: [
                    Expanded(
                        child: CardStatisticsWidget(
                          title: 'Today'.tr(),
                          count: provider.goalsBookingData?.booking?.today??0.0,
                          onTap: () {},
                        )),
                    Expanded(
                        child: CardStatisticsWidget(
                          title: 'This month'.tr(),
                          count: provider.goalsBookingData?.booking?.this_month??0.0,
                          onTap: () {},
                        )),
                    Expanded(
                        child: CardStatisticsWidget(
                          title: 'Last month'.tr(),
                          count: provider.goalsBookingData?.booking?.last_month??0.0,
                          onTap: () {},
                        ))
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void creatGoalSheet(GoalModel? goal) {
    TextEditingController dailyController = TextEditingController(
        text: goal != null && goal.daily != null ? goal.daily!.toString() : '');
    TextEditingController monthlyController = TextEditingController(
        text: goal != null && goal.monthly != null
            ? goal.monthly!.toString()
            : '');
    TextEditingController yearlyController = TextEditingController(
        text:
            goal != null && goal.yearly != null ? goal.yearly!.toString() : '');

    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(16), topLeft: Radius.circular(16))),
      context: navigatorKey.currentContext!,
      builder: (context) {
        return Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                width: 70,
                height: 4,
                decoration: BoxDecoration(
                    color: AppTheme.isDarkMode()
                        ? greyColor.withOpacity(.2)
                        : greyColor.withOpacity(.4),
                    borderRadius: BorderRadius.circular(4)),
              ),
              const SizedBox(
                height: 4,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () async {
                        await NavigatorHandler.pop();
                      },
                      icon: CustomSvgIcon(
                        assetName: 'close2',
                        color:
                            AppTheme.isDarkMode() ? Colors.white : Colors.black,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    CustomText(
                      title: 'Add Your Goal'.tr(),
                      textAlign: TextAlign.center,
                      fontColor:
                          AppTheme.isDarkMode() ? Colors.white : Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(
                      width: 36,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 24,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      title: 'Add daily goal'.tr(),
                      fontColor:
                      AppTheme.isDarkMode() ? Colors.white : greyColor,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomTextFormField(controller: dailyController,textInputType: const TextInputType.numberWithOptions(signed: false,decimal: true),suffix: CustomText(title: 'SAR'.tr(),fontColor: mainColor,fontWeight: FontWeight.bold,),),
                    const SizedBox(
                      height: 12,
                    ),

                    CustomText(
                      title: 'Add monthly goal'.tr(),
                      fontColor:
                      AppTheme.isDarkMode() ? Colors.white : greyColor,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomTextFormField(controller: monthlyController,textInputType: const TextInputType.numberWithOptions(signed: false,decimal: true),suffix: CustomText(title: 'SAR'.tr(),fontColor: mainColor,fontWeight: FontWeight.bold,),),

                    const SizedBox(
                      height: 12,
                    ),

                    CustomText(
                      title: 'Add yearly goal'.tr(),
                      fontColor:
                      AppTheme.isDarkMode() ? Colors.white : greyColor,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomTextFormField(controller: yearlyController,textInputType: const TextInputType.numberWithOptions(signed: false,decimal: true),suffix: CustomText(title: 'SAR'.tr(),fontColor: mainColor,fontWeight: FontWeight.bold,),),

                    const SizedBox(height: 24,),
                    CustomButton(title: 'Save'.tr(),borderWidth: 0,bg: mainColor, onTap: () async{

                      String daily = dailyController.text.trim();
                      String monthly = monthlyController.text.trim();
                      String yearly = yearlyController.text.trim();
                      if(daily.isNotEmpty||monthly.isNotEmpty||yearly.isNotEmpty){
                        await NavigatorHandler.pop();
                        await Future.delayed(const Duration(milliseconds: 500));
                        growthProvider.addGoal(daily.isEmpty?null:daily,monthly.isEmpty?null:monthly,yearly.isEmpty?null:yearly);

                      }else{
                        CustomScaffoldMessanger.showToast(title: 'Add one of your goals'.tr());
                      }


                    }),
                    const SizedBox(height: 24,),

                  ],),
              ),


            ],
          ),
        );
      },
    );
  }
}
