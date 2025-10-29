import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/data/models/api_response.dart';
import 'package:gymatvendor/data/models/comment_model.dart';
import 'package:gymatvendor/data/models/join_session_response.dart';
import 'package:gymatvendor/injection.dart';
import 'package:gymatvendor/main.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/live_session2/Repository/LiveSessionRepository2.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/live_session2/SessionScreen.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';

import '../../../widgets/dialogs/progress_dialog.dart';
import '../../../widgets/dialogs/scaffold_messanger.dart';

class LiveSessionProvider2 with ChangeNotifier {
  TextEditingController sessionTitleController = TextEditingController();
  TextEditingController sessionDescriptionController = TextEditingController();
  TextEditingController comentsController = TextEditingController();
  String selectedDate = "";
  String fromTime = "";
  String toTime = "";
  bool isFree = false;
  String? sessionToken;
  int? userSessionId;
  List<CommentData> comments = [];
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
      context: navigatorKey.currentContext!,
      msg: 'Wait ...'.tr(),
    );

    try {
      if (type != "instant") {
        if (sessionTitleController.text.isNotEmpty &&
            sessionDescriptionController.text.isNotEmpty &&
            selectedDate.isNotEmpty &&
            fromTime.isNotEmpty &&
            toTime.isNotEmpty) {
          await dialog.show();
          ApiResponse apiResponse = await repository.createSession(
            courseId,
            sessionTitleController.text,
            sessionDescriptionController.text,
            isFree,
            selectedDate,
            fromTime,
            toTime,
            "live",
          );

          if (apiResponse.response?.statusCode == 200 ||
              apiResponse.response?.statusCode == 201) {
            if (apiResponse.response!.data['message'] == "done successfully" ||
                apiResponse.response!.data['message'] == "تم بنجاح") {
              if (dialog.isShowing()) {
                await dialog.hide();
              }
              CustomScaffoldMessanger.showScaffoledMessanger(
                title: "Session created successfully",
              );
              Navigator.pop(navigatorKey.currentContext!);
            } else {
              CustomScaffoldMessanger.showScaffoledMessanger(
                title: "Something went wrong",
              );
            }
          } else {
            CustomScaffoldMessanger.showScaffoledMessanger(
              title: "Something went wrong",
            );
          }
        } else {
          CustomScaffoldMessanger.showScaffoledMessanger(
            title: "All fields are required",
          );
        }
      } else {
        ApiResponse apiResponse = await repository.createSession(
          courseId,
          sessionTitleController.text,
          sessionDescriptionController.text,
          isFree,
          DateFormat('yyyy-MM-dd', 'en_US').format(DateTime.now()),
          "${TimeOfDay.now().hour.toString().padLeft(2, '0')}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}",
          "${TimeOfDay.now().hour.toString().padLeft(2, '0')}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}",
          "live",
        );

        if (dialog.isShowing()) {
          await dialog.hide();
        }

        if (apiResponse.response!.data['message'] == "done successfully" ||
            apiResponse.response!.data['message'] == "تم بنجاح") {
          final provider = getIt<LiveSessionProvider2>();
          var responseData = apiResponse.response!.data['data'];
          int id = responseData['id'];
          String channelName = responseData['channel_name'] ?? "";
          int userId = responseData['user_id'];
          notifyListeners();
          Navigator.pop(navigatorKey.currentContext!);
          if (id != null && channelName.isNotEmpty) {
            Navigator.push(
              navigatorKey.currentContext!,
              MaterialPageRoute(
                builder:
                    (context) => ChangeNotifierProvider.value(
                      value: provider,
                      child: SessionScreen(
                        channelName: channelName,
                        sessionId: id,
                        userId: userId,
                      ),
                    ),
              ),
            );
          }
        } else {
          CustomScaffoldMessanger.showScaffoledMessanger(
            title: "Something went wrong",
          );
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

  Future<void> joinSession(int sessionId) async {
    try {
      ApiResponse apiResponse = await repository.joinSession(sessionId);
      if (apiResponse.response!.statusCode == 200 ||
          apiResponse.response!.statusCode == 201) {
        JoinSessionResponse joinSessionResponse = JoinSessionResponse.fromJson(
          apiResponse.response!.data,
        );
        sessionToken = joinSessionResponse.rtcToken;
        userSessionId = joinSessionResponse.userId;
        notifyListeners();
      }
    } catch (e) {
      CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
    }
  }

  Future<void> renewSessionToken(int sessionId) async {
    try {
      ApiResponse apiResponse = await repository.joinSession(sessionId);
      if (apiResponse.response!.statusCode == 200 ||
          apiResponse.response!.statusCode == 201) {
        JoinSessionResponse joinSessionResponse = JoinSessionResponse.fromJson(
          apiResponse.response!.data,
        );
        sessionToken = joinSessionResponse.rtcToken;
        notifyListeners();
      }
    } catch (e) {
      CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
    }
  }

  Future<void> generateCommentToken(int sessionId, String comment) async {
    try {
      ApiResponse apiResponse = await repository.generateCommentToken();
      if ((apiResponse.response!.statusCode == 200 ||
              apiResponse.response!.statusCode == 201) &&
          apiResponse.response!.data['rtm_token'] != null) {
        await _addComment(sessionId, comment);
      } else {
        CustomScaffoldMessanger.showScaffoledMessanger(
          title: "Something went wrong",
        );
      }
    } catch (e) {
      CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
    }
  }

  Future<void> _addComment(int sessionId, String comment) async {
    try {
      ApiResponse apiResponse = await repository.addComment(sessionId, comment);
      if ((apiResponse.response!.statusCode == 200 ||
              apiResponse.response!.statusCode == 201) &&
          apiResponse.response!.data['data'] != null) {
        CommentModel commentModel = CommentModel.fromJson(
          apiResponse.response!.data,
        );
        comments.clear();
        comments = commentModel.data;
        comentsController.clear();
        notifyListeners();
      } else {
        CustomScaffoldMessanger.showScaffoledMessanger(
          title: "Something went wrong",
        );
      }
    } catch (e) {
      CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
    }
  }

  Future<void> getAllComments(int sessionId) async {
    try {
      ApiResponse apiResponse = await repository.getAllComments(sessionId);
      if ((apiResponse.response!.statusCode == 200 ||
              apiResponse.response!.statusCode == 201) &&
          apiResponse.response!.data['data'] != null) {
        CommentModel commentModel = CommentModel.fromJson(
          apiResponse.response!.data,
        );
        comments = commentModel.data;
        notifyListeners();
      } else {
        CustomScaffoldMessanger.showScaffoledMessanger(
          title: "Something went wrong",
        );
      }
    } catch (e) {
      CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
    }
  }

  void clearData() {
    sessionTitleController.text = "";
    sessionDescriptionController.text = "";
    selectedDate = "";
    fromTime = "";
    toTime = "";
    isFree = false;
    comentsController.text = "";
  }
}
