import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/data/models/api_response.dart';
import 'package:gymatvendor/main.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/live_session2/Repository/LiveSessionRepository2.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/live_session2/SessionScreen.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import '../../../widgets/dialogs/progress_dialog.dart';
import '../../../widgets/dialogs/scaffold_messanger.dart';

class LiveSessionProvider2 with ChangeNotifier {
  TextEditingController sessionTitleController = TextEditingController();
  TextEditingController sessionDescriptionController = TextEditingController();
  String selectedDate = "";
  String fromTime = "";
  String toTime = "";
  bool isFree = false;
  LiveSessionRepository2 repository;
  LiveSessionProvider2({required this.repository});

  void updatedSelectedDate(String date) {
    selectedDate = date;
    notifyListeners();
  }

  void updatedFromTime(String time) {
    fromTime = time;
    notifyListeners();
  }

  void updatedToTime(String time) {
    toTime = time;
    notifyListeners();
  }

  void updateIsFree(bool value) {
    isFree = value;
    notifyListeners();
  }

  void createLiveSession(int courseId, String type) async {
    ProgressDialog dialog = createProgressDialog(
        context: navigatorKey.currentContext!, msg: 'Wait ...'.tr());

    try {
      await dialog.show();

      if (type != "instant") {
        if (sessionTitleController.text.isNotEmpty &&
            sessionDescriptionController.text.isNotEmpty &&
            selectedDate.isNotEmpty &&
            fromTime.isNotEmpty &&
            toTime.isNotEmpty) {
          ApiResponse apiResponse = await repository.createSession(
              courseId,
              sessionTitleController.text,
              sessionDescriptionController.text,
              isFree,
              selectedDate,
              fromTime,
              toTime,
              "live");

          if (apiResponse.response?.statusCode == 200 ||
              apiResponse.response?.statusCode == 201) {
            if (apiResponse.response!.data['message'] == "done successfully") {
              if (dialog.isShowing()) {
                await dialog.hide();
              }
              CustomScaffoldMessanger.showScaffoledMessanger(
                  title: "Session created successfully");
              Navigator.pop(navigatorKey.currentContext!);
            } else {
              CustomScaffoldMessanger.showScaffoledMessanger(
                  title: "Something went wrong");
            }
          } else {
            CustomScaffoldMessanger.showScaffoledMessanger(
                title: "Something went wrong");
          }
        } else {
          CustomScaffoldMessanger.showScaffoledMessanger(
              title: "All fields are required");
        }
      } else {
        ApiResponse apiResponse = await repository.createSession(
            courseId,
            sessionTitleController.text,
            sessionDescriptionController.text,
            isFree,
            DateFormat('yyyy-MM-dd').format(DateTime.now()),
            "${TimeOfDay.now().hour.toString().padLeft(2, '0')}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}",
            "${TimeOfDay.now().hour.toString().padLeft(2, '0')}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}",
            "live");

        if (dialog.isShowing()) {
          await dialog.hide();
        }

        if (apiResponse.response!.data['message'] == "done successfully") {
          String channelName = apiResponse.response!.data['channelName'] ?? "";
          Navigator.pop(navigatorKey.currentContext!);
          Navigator.push(
              navigatorKey.currentContext!,
              MaterialPageRoute(
                  builder: (context) => SessionScreen(channelName: channelName)));
        } else {
          CustomScaffoldMessanger.showScaffoledMessanger(
              title: "Something went wrong");
        }
      }
    } catch (e) {
      CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
    } finally {
      if (dialog.isShowing() && navigatorKey.currentContext != null) {
        await dialog.hide();
      }
    }
  }




  void clearData(){
    sessionTitleController.text = "";
     sessionDescriptionController.text ="";
    selectedDate = "";
    fromTime = "";
     toTime = "";
    isFree = false;
  }
}