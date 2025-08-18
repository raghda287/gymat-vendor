import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/data/models/ad_model.dart';
import 'package:gymatvendor/data/models/liveSessionModel.dart';
import 'package:gymatvendor/data/repositories/coach_livesession_repository.dart';
import 'package:gymatvendor/data/repositories/coach_workout_repository.dart';
import 'package:gymatvendor/injection.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import '../../../core/app_theme/theme.dart';
import '../../../core/navigator/navigator.dart';
import '../../../data/models/api_response.dart';
import '../../../data/models/local_workout_video_model.dart';
import '../../../data/models/workout_model.dart';
import '../../../main.dart';
import '../../widgets/dialogs/progress_dialog.dart';
import '../../widgets/dialogs/scaffold_messanger.dart';
import '../livesession_screen/webview_livesession_screen.dart';
import 'coach_home_provider.dart';

class LiveSessionProvider with ChangeNotifier {
  CoachLiveSessionRepository repository = getIt();
  bool isLoadingHomeLiveSession = true;
  List<LiveSessionModel> homeLiveSessionList = [];
  bool isLoading = true;
  bool isLoadingMore = false;
  List<LiveSessionModel?> liveSessions = [];
  String? sessionCoverUrl;
  DateTime? dateTime;

  String? date;

  String? fromTime;

  String? toTime;

  bool isFree = false;
  int page = 1;
  CancelToken? sessionCancelToken;

  void initHomeLiveSession() {
    isLoadingHomeLiveSession = true;
    homeLiveSessionList = [];
  }

  void initLiveSession() {
    isLoading = false;
    isLoadingMore = false;
    liveSessions = [];
    sessionCancelToken = null;
  }

  void initAddLiveSession(LiveSessionModel? liveSessionModel) {
    isFree = false;
    sessionCoverUrl = null;
    dateTime = DateTime.now();
    date = DateFormat('yyyy-MM-dd', 'en').format(dateTime!);
    fromTime = null;
    toTime = null;

    if (liveSessionModel != null) {
      isFree =
          liveSessionModel.new_price != null && liveSessionModel.new_price == 0;
      sessionCoverUrl = liveSessionModel.photo;
      date = liveSessionModel.date ??
          DateFormat('yyyy-MM-dd', 'en').format(DateTime.now());
      fromTime = liveSessionModel.from_time;
      toTime = liveSessionModel.to_time;
      dateTime =  DateFormat('yyyy-MM-dd', 'en').parse(date!);
    }
  }

  void pickImage(ImageSource source) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? xFile = await imagePicker.pickImage(
        source: source, maxWidth: 1024, maxHeight: 1024*9/16, imageQuality: 90);
    if (xFile != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: xFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 9),

        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarWidgetColor:
                AppTheme.isDarkMode() ? Colors.white : Colors.black,
            toolbarColor: AppTheme.isDarkMode() ? Colors.black : Colors.white,
            initAspectRatio: CropAspectRatioPreset.ratio16x9,
            lockAspectRatio: true,
            aspectRatioPresets: [
              CropAspectRatioPreset.ratio16x9,
            ],
          ),
          IOSUiSettings(
            title: 'Cropper',
            aspectRatioLockEnabled: true,
            minimumAspectRatio: 16 / 9,
            aspectRatioLockDimensionSwapEnabled: true,
            aspectRatioPresets: [
              CropAspectRatioPreset.ratio16x9,
            ],
          ),
        ],
      );

      if (croppedFile != null) {
        sessionCoverUrl = 'fileimage:${croppedFile.path}';
        notifyListeners();
      }
    }
  }

  void updateIsFree(bool value) {
    isFree = value;
    notifyListeners();
  }

  void updateSessionStartTime(String time) {
    fromTime = time;
    notifyListeners();
  }

  void updateSessionEndTime(String time) {
    toTime = time;
    notifyListeners();
  }

  void updateSessionStartDate(String date) {
    this.date = date;
    notifyListeners();
  }

  String getLiveSessionEndDate() {
    String fDate = '$date $fromTime';
    String tDate = '$date $toTime';

    DateTime fromDate = DateFormat('yyyy-MM-dd hh:mm a', 'en').parse(fDate);
    DateTime toDate = DateFormat('yyyy-MM-dd hh:mm a', 'en').parse(tDate);

    num diff = toDate.millisecondsSinceEpoch - fromDate.millisecondsSinceEpoch;

    if (diff <= 0) {
      toDate = toDate.add(const Duration(days: 1));
    }

    return DateFormat('yyyy-MM-dd', 'en').format(toDate);
  }

  void addLiveSession(String topic, String describtion, String price, bool hasOffer, String offer_type, String offer_value) async {
    ProgressDialog dialog = createProgressDialog(
        context: navigatorKey.currentState!.context,
        msg: 'Adding live session...'.tr());
    try {
      await dialog.show();
      ApiResponse response = await repository.addLiveSession(
          topic,
          describtion,
          price,
          hasOffer,
          offer_type,
          offer_value,
          sessionCoverUrl!,
          getLiveSessionEndDate(),
          fromTime!,
          toTime!);
      await dialog.hide();
      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          if (response.response!.data != null &&
              response.response!.data['data'] != null) {
            LiveSessionModel model =
                LiveSessionModel.fromJson(response.response?.data['data']);
            liveSessions.insert(0, model);
            if (homeLiveSessionList.length < 5) {
              homeLiveSessionList.insert(0, model);
            }
            notifyListeners();

            NavigatorHandler.pop();
          }
        }
      } else {
        await dialog.hide();

        if (response.error != null) {
          CustomScaffoldMessanger.showScaffoledMessanger(title: response.error);
        }
      }
    } catch (e) {
      await dialog.hide();

      print('Add live session error $e');
    }
  }

  void updateLiveSession(num? sessionId, String topic, String describtion, String price, bool hasOffer, String offer_type, String offer_value) async {
    ProgressDialog dialog = createProgressDialog(
        context: navigatorKey.currentState!.context,
        msg: 'Updating live session...'.tr());
    try {
      await dialog.show();
      ApiResponse response = await repository.updateLiveSession(
          sessionId,
          topic,
          describtion,
          price,
          hasOffer,
          offer_type,
          offer_value,
          sessionCoverUrl!,
          getLiveSessionEndDate(),
          fromTime!,
          toTime!);
      await dialog.hide();
      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          if (response.response!.data != null &&
              response.response!.data['data'] != null) {
            LiveSessionModel model =
                LiveSessionModel.fromJson(response.response?.data['data']);
            int? liveSessionHomeIndex = getHomeLiveSessionIndex(sessionId!);
            int? liveSessionIndex = getHomeLiveSessionIndex(sessionId);

            if (liveSessionHomeIndex != null&&homeLiveSessionList.isNotEmpty) {
              homeLiveSessionList[liveSessionHomeIndex] = model;
              notifyListeners();
            }

            if (liveSessionIndex != null&&liveSessions.isNotEmpty) {
              liveSessions[liveSessionIndex] = model;
              notifyListeners();
            }

            NavigatorHandler.pop();
          }
        }
      } else {
        await dialog.hide();

        if (response.error != null) {
          CustomScaffoldMessanger.showScaffoledMessanger(title: response.error);
        }
      }
    } catch (e) {
      await dialog.hide();

      print('update live session error $e');
    }
  }

  void deleteLiveSession(num? sessionId) async {
    ProgressDialog dialog = createProgressDialog(
        context: navigatorKey.currentState!.context,
        msg: 'Deleting live session...'.tr());
    try {
      await dialog.show();
      ApiResponse response = await repository.deleteLiveSession(sessionId);

      await dialog.hide();
      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          if (response.response!.data != null &&
              response.response!.data['data'] != null) {
            int? liveSessionHomeIndex = getHomeLiveSessionIndex(sessionId!);
            int? liveSessionIndex = getHomeLiveSessionIndex(sessionId);

            if (liveSessionHomeIndex != null) {
              homeLiveSessionList.removeAt(liveSessionHomeIndex);
            }

            if (liveSessionIndex != null) {
              liveSessions.removeAt(liveSessionIndex);
            }
          }
        }
      } else {
        await dialog.hide();

        if (response.error != null) {
          CustomScaffoldMessanger.showScaffoledMessanger(title: response.error);
        }
      }
    } catch (e) {
      await dialog.hide();

      print('update live session error $e');
    }
  }

  void getHomeLiveSession() async {
    homeLiveSessionList.clear();
    isLoadingHomeLiveSession = true;
    notifyListeners();
    try {
      ApiResponse response = await repository.getLiveSession(1, 5);
      isLoadingHomeLiveSession = false;

      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          response.response!.data['data'].forEach(
              (v) => homeLiveSessionList.add(LiveSessionModel.fromJson(v)));
          notifyListeners();
        }
      } else {
        isLoadingHomeLiveSession = false;
        notifyListeners();
        if (response.error != null) {
          CustomScaffoldMessanger.showScaffoledMessanger(title: response.error);
        }
      }
    } catch (e) {
      isLoadingHomeLiveSession = false;
      notifyListeners();
      if (e is DioException) {
        if (e.response!.statusCode != 500) {
          CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
        }
      }
      print('coach home live session error>>>${e.toString()}');
    }
  }

  void getLiveSession() async {
    liveSessions.clear();
    isLoading = true;
    isLoadingMore = false;
    notifyListeners();
    try {
      ApiResponse response = await repository.getLiveSession(1, 20);
      isLoading = false;

      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          response.response!.data['data'].forEach((v) => liveSessions.add(LiveSessionModel.fromJson(v)));
          notifyListeners();
        }
      } else {
        isLoading = false;
        notifyListeners();
        if (response.error != null) {
          CustomScaffoldMessanger.showScaffoledMessanger(title: response.error);
        }
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      if (e is DioException) {
        if (e.response!.statusCode != 500) {
          CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
        }
      }
      print('coach live session error>>>${e.toString()}');
    }
  }

  void loadMoreLiveSession() async {
    try {
      int p = page+1;
      isLoadingMore = true;
      liveSessions.add(null);
      notifyListeners();

      if (sessionCancelToken != null) {
        sessionCancelToken!.cancel('canceled');
        sessionCancelToken = null;
      }

      sessionCancelToken ??= CancelToken();

      ApiResponse response = await repository.getLiveSession(p, 20, cancelToken: sessionCancelToken);
      isLoadingMore = false;

      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {

          if(liveSessions.last == null){
             liveSessions.removeLast();

          }
          List<LiveSessionModel> list = [];

          response.response!.data['data'].forEach((v) => list.add(LiveSessionModel.fromJson(v)));

          if(list.isNotEmpty){
            liveSessions.addAll(list);
            page = p;
          }

          notifyListeners();
        }
      } else {
        if(liveSessions.last == null){
          liveSessions.removeLast();

        }
        isLoadingMore = false;
        notifyListeners();
        if (response.error != null) {
          CustomScaffoldMessanger.showScaffoledMessanger(title: response.error);
        }
      }
    } catch (e) {
      if(liveSessions.last == null){
        liveSessions.removeLast();

      }
      isLoadingMore = false;
      notifyListeners();
      if (e is DioException) {
        if (e.response!.statusCode != 500) {
          CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
        }
      }
      print('coach live session load more error>>>${e.toString()}');
    }
  }

  int? getHomeLiveSessionIndex(num id) {
    for (int index = 0; index < homeLiveSessionList.length; index++) {
      LiveSessionModel model = homeLiveSessionList[index];
      if (model.id == id && model.id != null) {
        return index;
      }
    }

    return null;
  }

  int? getLiveSessionIndex(num id) {
    for (int index = 0; index < liveSessions.length; index++) {
      LiveSessionModel? model = liveSessions[index];
      if (model != null && model.id == id && model.id != null) {
        return index;
      }
    }

    return null;
  }

  void startLiveSession(num sessionId,String camera) async {
    ProgressDialog dialog = createProgressDialog(
        context: navigatorKey.currentState!.context,
        msg: 'Starting live session...'.tr());
    try {
      await dialog.show();
      ApiResponse response = await repository.startLiveSession(sessionId);
      await dialog.hide();
      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          if (response.response!.data != null && response.response!.data['data'] != null) {
            String link = response.response!.data['data']['link'];
            String link_expired_time = response.response!.data['data']['end_time_link'];
            String link_end = response.response!.data['data']['end_link'];
            NavigatorHandler.pushReplacement(WebViewLivesessionScreen(link: link,link_expired_time: link_expired_time,link_end: link_end,camera: camera,));
          }
        }else if(response.code ==422){
          getHomeLiveSession();
          getLiveSession();
          CustomScaffoldMessanger.showToast(title: 'Live session already ended'.tr());
        }
      } else {
        await dialog.hide();

        if (response.error != null) {
          CustomScaffoldMessanger.showScaffoledMessanger(title: response.error);
        }
      }
    } catch (e) {
      await dialog.hide();

      print('Add live session error $e');
    }
  }

}
