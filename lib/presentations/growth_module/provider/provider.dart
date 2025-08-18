import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/data/models/goalModel.dart';
import 'package:gymatvendor/injection.dart';
import 'package:gymatvendor/main.dart';
import 'package:gymatvendor/presentations/widgets/dialogs/progress_dialog.dart';
import 'package:gymatvendor/presentations/widgets/dialogs/scaffold_messanger.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import '../../../data/models/api_response.dart';
import '../../../data/models/chart_model.dart';
import '../../../data/models/goalsBookingData.dart';
import '../../../data/repositories/growth_repository.dart';
enum GrowthFilterType {
  thisWeek,
  thisMonth,
  thisYear
}
class GrowthProvider with ChangeNotifier{
  GrowthRepository repository = getIt();
  String growthFilter = GrowthFilterType.thisWeek.name;
  bool isLoadingCharts = true;
  List<ChartModel> chartData = [];
  bool isLoadingGoalsAndBooking = true;
  GoalsBookingData? goalsBookingData;



  void init(){
    isLoadingCharts = true;
    isLoadingGoalsAndBooking = true;
    growthFilter = GrowthFilterType.thisWeek.name;
    chartData = [];
    goalsBookingData = null;

  }

  void updateGrowthFilter(String filter) {
    growthFilter = filter;
    notifyListeners();
    getCharts();
  }
  /// caling apis ////
  void getCharts() async{
    try {
      isLoadingCharts = true;
      notifyListeners();


      ApiResponse response = await repository.charts(growthFilter==GrowthFilterType.thisWeek.name?'week':growthFilter==GrowthFilterType.thisMonth.name?'month':'year');

      isLoadingCharts = false;
      notifyListeners();

      if (response.response != null) {
        if (response.response!.statusCode == 200 || response.response!.statusCode == 201) {
          if (response.response!.data != null) {
            if (response.code==200) {
              chartData.clear();

              response.response?.data['data'].forEach((v)=>chartData.add(ChartModel.fromJson(v)));
              notifyListeners();
            }
          } else {}
        } else {}
      }
    } catch (e) {
      isLoadingCharts = false;
      notifyListeners();
      print('errorLoadingCharts=>>>>$e');
    }
  }

  Future<GoalModel?> getGoals() async{

    ProgressDialog dialog = createProgressDialog(context: navigatorKey.currentContext!, msg: 'Getting goals ...'.tr());
    try {
      await dialog.show();

      ApiResponse response = await repository.getGoals();
      await dialog.hide();

      if (response.response != null) {
        if (response.response!.statusCode == 200 || response.response!.statusCode == 201) {
          if (response.response!.data != null) {
            if (response.code==200) {

              return GoalModel.fromJson(response.response?.data['data']);

            }
          } else {}
        } else {}
      }
    } catch (e) {
      await dialog.hide();

      print('errorGettingGoals=>>>>$e');
    }

    return null;
  }

  void addGoal(String? daily,String? monthly,String? yearly) async{

    ProgressDialog dialog = createProgressDialog(context: navigatorKey.currentContext!, msg: 'Adding goals ...'.tr());
    try {
      await dialog.show();

      ApiResponse response = await repository.updateGoals(daily, monthly, yearly);
      await dialog.hide();

      if (response.response != null) {
        if (response.response!.statusCode == 200 || response.response!.statusCode == 201) {
          if (response.response!.data != null) {
            if (response.code==200) {
              CustomScaffoldMessanger.showToast(title: 'Added successfully !'.tr());
            }
          } else {}
        } else {}
      }
    } catch (e) {
      await dialog.hide();

      print('errorLGettingGoals=>>>>$e');
    }

  }


  void getGoalsAndBooking() async{

    try {
      isLoadingGoalsAndBooking = true;
      notifyListeners();

      ApiResponse response = await repository.getGoalsAndBooking();
      isLoadingGoalsAndBooking = false;
      notifyListeners();
      if (response.response != null) {
        if (response.response!.statusCode == 200 || response.response!.statusCode == 201) {
          if (response.response!.data != null) {
            if (response.code==200) {

              goalsBookingData = GoalsBookingData.fromJson(response.response?.data['data']);
              notifyListeners();

            }
          } else {}
        } else {}
      }
    } catch (e) {
      isLoadingGoalsAndBooking = false;
      notifyListeners();
      print('errorGettingGoalsAnBooking=>>>>$e');
    }

  }


}