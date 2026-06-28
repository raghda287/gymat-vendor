import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/data/models/api_response.dart';
import 'package:gymatvendor/data/models/comment_model.dart';
import 'package:gymatvendor/data/models/join_session_response.dart';
import 'package:gymatvendor/injection.dart';
import 'package:gymatvendor/main.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/live_session2/Repository/LiveSessionRepository2.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/live_session2/SessionScreen.dart';
import 'package:gymatvendor/presentations/widgets/dialogs/progress_dialog.dart';
import 'package:gymatvendor/presentations/widgets/dialogs/scaffold_messanger.dart';
import 'package:gymatvendor/socketProvider.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';

import '../../../../core/app_url/app_url.dart';
import '../../../../data/datasource/remote/dio/dio_client.dart';
import '../../../../data/datasource/remote/exception/api_error_handler.dart';

class LiveSessionProvider2 with ChangeNotifier {
  final LiveSessionRepository2 repository;

  LiveSessionProvider2({
    required this.repository,
  });

  final TextEditingController sessionTitleController =
  TextEditingController();

  final TextEditingController sessionDescriptionController =
  TextEditingController();

  final TextEditingController comentsController = TextEditingController();

  String selectedDate = '';
  String fromTime = '';
  String toTime = '';
  bool isFree = false;

  String? sessionToken;
  int? userSessionId;
  String? joinedChannelName;
  bool isCreatingInstantLive = false;
  String? recordingResourceId;
  String? recordingSid;
  String? recordingChannel;
  int? recordingUid;

  List<CommentData> comments = [];

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

  String _todayDate() {
    return DateFormat('yyyy-MM-dd', 'en_US').format(DateTime.now());
  }

  String _currentTime() {
    final TimeOfDay now = TimeOfDay.now();

    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }
  String _timeAfterMinutes(int minutes) {
    final DateTime dateTime = DateTime.now().add(Duration(minutes: minutes));

    return DateFormat('HH:mm', 'en_US').format(dateTime);
  }

  bool _isSuccess(ApiResponse response) {
    final statusCode = response.response?.statusCode;
    return statusCode == 200 || statusCode == 201;
  }

  bool _isDone(dynamic data) {
    final message = data?['message'];

    return message == 'done successfully' || message == 'تم بنجاح';
  }

  Future<void> _safeHideDialog(ProgressDialog dialog) async {
    try {
      if (dialog.isShowing()) {
        await dialog.hide();
        await Future.delayed(const Duration(milliseconds: 300));
      }
    } catch (_) {}
  }

  Map<String, dynamic>? _asMap(dynamic value) {
    if (value == null) return null;

    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    if (value is String) {
      final String text = value.trim();

      if (text.isEmpty) return null;

      try {
        final decoded = jsonDecode(text);

        if (decoded is Map<String, dynamic>) {
          return decoded;
        }

        if (decoded is Map) {
          return Map<String, dynamic>.from(decoded);
        }
      } catch (_) {}
    }

    return null;
  }
  String? _readStringFromMap(Map<String, dynamic>? map, List<String> keys) {
    if (map == null) return null;

    for (final key in keys) {
      final value = map[key];

      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString();
      }
    }

    final data = _asMap(map['data']);

    if (data != null) {
      for (final key in keys) {
        final value = data[key];

        if (value != null && value.toString().trim().isNotEmpty) {
          return value.toString();
        }
      }
    }

    return null;
  }

  Future<void> createLiveSession(int courseId, String type) async {
    if (type == 'instant') {
      await createInstantLiveSession(courseId);
    } else {
      await createScheduledLiveSession(courseId);
    }
  }

  Future<void> createScheduledLiveSession(int courseId) async {
    final title = sessionTitleController.text.trim();
    final description = sessionDescriptionController.text.trim();

    if (title.isEmpty ||
        description.isEmpty ||
        selectedDate.isEmpty ||
        fromTime.isEmpty ||
        toTime.isEmpty) {
      CustomScaffoldMessanger.showScaffoledMessanger(
        title: 'All fields are required',
      );
      return;
    }

    final ProgressDialog dialog = createProgressDialog(
      context: navigatorKey.currentContext!,
      msg: 'Wait ...'.tr(),
    );

    try {
      await dialog.show();

      final ApiResponse response = await repository.createSession(
        courseId,
        title,
        description,
        isFree,
        selectedDate,
        fromTime,
        toTime,
        'live',
      );

      await _safeHideDialog(dialog);

      if (_isSuccess(response) && _isDone(response.response?.data)) {
        CustomScaffoldMessanger.showScaffoledMessanger(
          title: 'Session created successfully',
        );

        final context = navigatorKey.currentContext;

        if (context != null) {
          Navigator.pop(context);
        }
      } else {
        CustomScaffoldMessanger.showScaffoledMessanger(
          title: 'Something went wrong',
        );
      }
    } catch (e) {
      await _safeHideDialog(dialog);

      CustomScaffoldMessanger.showScaffoledMessanger(
        title: e.toString(),
      );
    }
  }

  Future<void> createInstantLiveSession(int courseId) async {
    final ProgressDialog dialog = createProgressDialog(
      context: navigatorKey.currentContext!,
      msg: 'Wait ...'.tr(),
    );

    try {
      await dialog.show();

      final String title = sessionTitleController.text.trim().isEmpty
          ? 'Live Session'
          : sessionTitleController.text.trim();

      final String description = sessionDescriptionController.text.trim().isEmpty
          ? 'Instant live session'
          : sessionDescriptionController.text.trim();

      final String date = _todayDate();
      final String time = _currentTime();

      final ApiResponse createResponse = await repository.createSession(
        courseId,
        title,
        description,
        isFree,
        date,
        time,
        time,
        'live',
      );

      print('CREATE LIVE RESPONSE => ${createResponse.response?.data}');

      if (!_isSuccess(createResponse) ||
          !_isDone(createResponse.response?.data)) {
        await _safeHideDialog(dialog);

        CustomScaffoldMessanger.showScaffoledMessanger(
          title: 'Something went wrong',
        );
        return;
      }

      final data = createResponse.response?.data['data'];

      if (data == null) {
        await _safeHideDialog(dialog);

        CustomScaffoldMessanger.showScaffoledMessanger(
          title: 'Invalid session response',
        );
        return;
      }

      final int? sessionId = data['id'];
      final String channelName = data['channel_name'] ?? '';

      if (sessionId == null || channelName.isEmpty) {
        await _safeHideDialog(dialog);

        CustomScaffoldMessanger.showScaffoledMessanger(
          title: 'Invalid session data',
        );
        return;
      }



      final context = navigatorKey.currentContext;

      if (context == null) return;

      final provider = getIt<LiveSessionProvider2>();

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) {
            return ChangeNotifierProvider.value(
              value: provider,
              child: SessionScreen(
                channelName: channelName,
                sessionId: sessionId,
                userId: 0,
              ),
            );
          },
        ),
      );
    } catch (e) {
      await _safeHideDialog(dialog);

      CustomScaffoldMessanger.showScaffoledMessanger(
        title: e.toString(),
      );
    }
  }

  Future<bool> joinSession(int sessionId) async {
    sessionToken = null;
    userSessionId = null;
    joinedChannelName = null;

    try {
      final ApiResponse response = await repository.joinSession(sessionId);

      if (!_isSuccess(response) || response.response == null) {
        notifyListeners();
        return false;
      }

      final JoinSessionResponse joinResponse =
      JoinSessionResponse.fromJson(response.response!.data);

      sessionToken = joinResponse.rtcToken;
      userSessionId = joinResponse.userId;
      joinedChannelName = joinResponse.channelName;

      notifyListeners();

      return sessionToken != null && sessionToken!.isNotEmpty;
    } catch (e) {
      sessionToken = null;
      userSessionId = null;
      joinedChannelName = null;

      notifyListeners();

      CustomScaffoldMessanger.showScaffoledMessanger(
        title: e.toString(),
      );

      return false;
    }
  }

  Future<void> renewSessionToken(int sessionId) async {
    try {
      final ApiResponse response = await repository.renewSessionToken(sessionId);

      if (!_isSuccess(response) || response.response == null) return;

      final JoinSessionResponse joinResponse =
      JoinSessionResponse.fromJson(response.response!.data);

      sessionToken = joinResponse.rtcToken;

      notifyListeners();
    } catch (e) {
      CustomScaffoldMessanger.showScaffoledMessanger(
        title: e.toString(),
      );
    }
  }

  Future<bool> startCloudRecording({
    required num sessionId,
    required String channelName,
    required int uid,
  }) async {
    try {
      debugPrint('========== START CLOUD RECORDING HTTP ==========');
      debugPrint('SESSION ID => $sessionId');
      debugPrint('CHANNEL NAME => $channelName');
      debugPrint('UID => $uid');

      final ApiResponse response = await repository.startRecording(
        //sessionId: sessionId.toInt(),
        channelName: channelName,
        uid: uid,
        mode: 'mix',
      );

      debugPrint('START RECORDING STATUS => ${response.response?.statusCode}');
      debugPrint('START RECORDING DATA => ${response.response?.data}');

      if (!_isSuccess(response) || response.response == null) {
        debugPrint('Start Recording Failed');
        return false;
      }

      final Map<String, dynamic>? data = _asMap(response.response?.data);

      final String? resourceId = _readStringFromMap(
        data,
        const [
          'resourceId',
          'resource_id',
          'resource',
        ],
      );

      final String? sid = _readStringFromMap(
        data,
        const [
          'sid',
        ],
      );

      if (resourceId == null ||
          resourceId.trim().isEmpty ||
          sid == null ||
          sid.trim().isEmpty) {
        debugPrint('Start Recording: resourceId or sid missing');
        debugPrint('resourceId => $resourceId');
        debugPrint('sid => $sid');

        return false;
      }

      recordingResourceId = resourceId;
      recordingSid = sid;
      recordingChannel = channelName;
      recordingUid = uid;

      debugPrint('SAVED RESOURCE ID => $recordingResourceId');
      debugPrint('SAVED SID => $recordingSid');
      debugPrint('SAVED RECORDING CHANNEL => $recordingChannel');
      debugPrint('SAVED RECORDING UID => $recordingUid');

      notifyListeners();

      return true;
    } catch (e, stack) {
      debugPrint('Start Recording Error: $e');
      debugPrint(stack.toString());
      return false;
    }
  }

  Future<String?> stopCloudRecordingAndGetVideo({
    required int sessionId,
    required String channelName,
    required int uid,
    required String resourceId,
    required String sid,
  }) async {
    try {
      final SocketProvider socketProvider = getIt<SocketProvider>();

      final String? video = await socketProvider.stopRecordingAndWaitVideo(
        sessionId: sessionId,
        channelName: channelName,
        uid: uid,
        resourceId: resourceId,
        sid: sid,
        mode: 'mix',
      );

      debugPrint('stopCloudRecording socket video: $video');

      return video;
    } catch (e) {
      debugPrint('stopCloudRecording socket error: $e');
      return null;
    }
  }
  Future<ApiResponse> endSession({
    //required int sessionId,
    required String channel,
    required int uid,
    required String resourceId,
    required String sid,
    String mode = 'mix',
  }) async {
    try {
      final formData = FormData.fromMap({
        //'session_id': sessionId.toString(),
        'channel': channel,
        'uid': uid.toString(),
        'resourceId': resourceId,
        'resource': resourceId,
        'sid': sid,
        'mode': mode,
      });

      final DioClient dioClient = DioClient();

      print('========== LARAVEL END SESSION REQUEST ==========');
      print('URL => ${AppUrls.endSession}');
      print('BODY => ${formData.fields}');

      final Response response = await dioClient.post(
        AppUrls.endSession,
        formData: formData,
      );

      print('========== LARAVEL END SESSION RESPONSE ==========');
      print('STATUS => ${response.statusCode}');
      print('DATA => ${response.data}');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('LARAVEL END SESSION ERROR => $e');
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<void> getAllComments(int sessionId) async {
    try {
      final ApiResponse response = await repository.getAllComments(sessionId);

      if (_isSuccess(response) && response.response?.data['data'] != null) {
        final CommentModel commentModel =
        CommentModel.fromJson(response.response!.data);

        comments = commentModel.data;

        notifyListeners();
      } else {
        CustomScaffoldMessanger.showScaffoledMessanger(
          title: 'Something went wrong',
        );
      }
    } catch (e) {
      CustomScaffoldMessanger.showScaffoledMessanger(
        title: e.toString(),
      );
    }
  }

  Future<void> _addComment(int sessionId, String comment) async {
    try {
      final ApiResponse response =
      await repository.addComment(sessionId, comment);

      if (_isSuccess(response) && response.response?.data['data'] != null) {
        final CommentModel commentModel =
        CommentModel.fromJson(response.response!.data);

        comments = commentModel.data;
        comentsController.clear();

        notifyListeners();
      } else {
        CustomScaffoldMessanger.showScaffoledMessanger(
          title: 'Something went wrong',
        );
      }
    } catch (e) {
      CustomScaffoldMessanger.showScaffoledMessanger(
        title: e.toString(),
      );
    }
  }

  Future<void> generateCommentToken(int sessionId, String comment) async {
    try {
      final ApiResponse response = await repository.generateCommentToken();

      if (_isSuccess(response) &&
          response.response?.data['rtm_token'] != null) {
        await _addComment(sessionId, comment);
      } else {
        CustomScaffoldMessanger.showScaffoledMessanger(
          title: 'Something went wrong',
        );
      }
    } catch (e) {
      CustomScaffoldMessanger.showScaffoledMessanger(
        title: e.toString(),
      );
    }
  }

  void clearData({bool notify = true}) {
    sessionTitleController.clear();
    sessionDescriptionController.clear();
    comentsController.clear();

    selectedDate = '';
    fromTime = '';
    toTime = '';
    isFree = false;

    recordingResourceId = null;
    recordingSid = null;
    recordingChannel = null;
    recordingUid = null;

    if (notify) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    sessionTitleController.dispose();
    sessionDescriptionController.dispose();
    comentsController.dispose();

    super.dispose();
  }
}