import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../../core/text_styles/text_styles.dart';
import '../../../data/models/chart_model.dart';

class ChartWeekWidget extends StatelessWidget {
  final List<ChartModel> dataSeries;
  const ChartWeekWidget({super.key, required this.dataSeries});
  @override
  Widget build(BuildContext context) {

    return SfCartesianChart(

      zoomPanBehavior: ZoomPanBehavior(enablePanning: false,),
      primaryXAxis: CategoryAxis(
        axisLine: AxisLine(color: AppTheme.isDarkMode()?greyColor.withOpacity(.4):greyColor,width: 1,dashArray: [5,5]),
        maximumLabels: 12,
        labelRotation: 90,
        autoScrollingDelta: 10,
        autoScrollingMode: AutoScrollingMode.start,
        majorGridLines: const MajorGridLines(color: Colors.transparent),
        axisLabelFormatter: (

            AxisLabelRenderDetails details){
          return ChartAxisLabel(details.text, AppTextStyles().normalText(fontSize: 12).textColorNormal(AppTheme.isDarkMode()?Colors.white:greyColor));
        },),
      primaryYAxis: CategoryAxis(
        majorGridLines: MajorGridLines(color: AppTheme.isDarkMode()?greyColor.withOpacity(.4):greyColor,dashArray: const [5,5]),
        axisLabelFormatter: (AxisLabelRenderDetails details){
          return ChartAxisLabel('${details.value} ${'SAR'.tr()}', AppTextStyles().normalText(fontSize: 11).textColorNormal(AppTheme.isDarkMode()?Colors.white:greyColor));
        },),

      series: <ColumnSeries<ChartModel, String>>[
        ColumnSeries(

          xValueMapper: (chart, _) => chart.title,
          yValueMapper: (chart, _) => chart.value,
          dataSource: dataSeries,
          width: .2,
          color: AppTheme.isDarkMode()?Colors.white:mainColor,
          borderRadius: BorderRadius.circular(100),
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        )
      ],
    );
  }
}
