import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gymatvendor/core/app_url/app_url.dart';
import 'package:gymatvendor/data/datasource/remote/dio/dio_client.dart';
import 'package:gymatvendor/data/models/api_response.dart';

import '../../../../data/datasource/remote/exception/api_error_handler.dart';

class LiveSessionRepository2 {
  Dio _nodeDio() {
    return Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
        },
      ),
    );
  }

  Future<ApiResponse> createSession(
      int courseId,
      String title,
      String description,
      bool isFree,
      String date,
      String fromTime,
      String toTime,
      String type,
      ) async {
    try {
      final formData = FormData.fromMap({
        'course_id': courseId,
        'title': title,
        'description': description,
        'is_free': isFree ? '1' : '0',
        'date': date,
        'from_time': fromTime,
        'to_time': toTime,
        'type': type,
      });

      final DioClient dioClient = DioClient();

      final Response response = await dioClient.post(
        AppUrls.createLiveSession,
        formData: formData,
      );

      print('CREATE SESSION STATUS => ${response.statusCode}');
      print('CREATE SESSION DATA => ${response.data}');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('CREATE SESSION ERROR => $e');
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> joinSession(int sessionId) async {
    try {
      final formData = FormData.fromMap({
        'session_id': sessionId,
      });

      final DioClient dioClient = DioClient();

      final Response response = await dioClient.post(
        AppUrls.joinLiveSession,
        formData: formData,
      );

      print('JOIN SESSION STATUS => ${response.statusCode}');
      print('JOIN SESSION DATA => ${response.data}');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('JOIN SESSION ERROR => $e');
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> renewSessionToken(int sessionId) async {
    try {
      final formData = FormData.fromMap({
        'session_id': sessionId,
        'type': 'renew',
      });

      final DioClient dioClient = DioClient();

      final Response response = await dioClient.post(
        AppUrls.joinLiveSession,
        formData: formData,
      );

      print('RENEW TOKEN STATUS => ${response.statusCode}');
      print('RENEW TOKEN DATA => ${response.data}');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('RENEW TOKEN ERROR => $e');
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> acquireRecording({
    required String channelName,
    required int uid,
    String mode = 'mix',
  }) async {
    try {
      final Dio dio = _nodeDio();

      final Map<String, dynamic> body = {
        'channel': channelName,
        'channel_name': channelName,
        'cname': channelName,
        'uid': uid.toString(),
        'mode': mode,
      };

      print('========== HTTP ACQUIRE RECORDING REQUEST ==========');
      print('URL => ${AppUrls.acquireRecordingHttp}');
      print('BODY => $body');

      final Response response = await dio.post(
        AppUrls.acquireRecordingHttp,
        data: body,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          responseType: ResponseType.plain,
        ),
      );

      final dynamic decodedData = _decodeResponseBody(response.data);
      response.data = decodedData;

      print('========== HTTP ACQUIRE RECORDING RESPONSE ==========');
      print('STATUS => ${response.statusCode}');
      print('DATA => ${response.data}');

      return ApiResponse.withSuccess(response);

    } catch (e) {
      print('HTTP ACQUIRE RECORDING ERROR => $e');
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> startRecording({
    required String channelName,
    required int uid,
    String mode = 'mix',
  }) async {
    try {
      final Dio dio = _nodeDio();

      final ApiResponse acquireApiResponse = await acquireRecording(
        channelName: channelName,
        uid: uid,
        mode: mode,
      );

      if (acquireApiResponse.response == null) {
        throw Exception('Acquire recording failed');
      }

      final dynamic acquireData = acquireApiResponse.response?.data;

      final String? resourceId = _findStringByKeys(
        acquireData,
        const [
          'resourceId',
          'resource_id',
          'resource',
        ],
      );

      if (resourceId == null || resourceId.trim().isEmpty) {
        throw Exception('resourceId missing from acquire response');
      }

      final Map<String, dynamic> body = {
        'channel': channelName,
        'channel_name': channelName,
        'cname': channelName,
        'uid': uid.toString(),
        'mode': mode,
        'resourceId': resourceId,
        'resource_id': resourceId,
        'resource': resourceId,
      };

      print('========== HTTP START RECORDING REQUEST ==========');
      print('URL => ${AppUrls.startRecordingHttp}');
      print('BODY => $body');

      final Response response = await dio.post(
        AppUrls.startRecordingHttp,
        data: body,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          responseType: ResponseType.plain,
        ),
      );

      final dynamic startRawData = _decodeResponseBody(response.data);
      response.data = startRawData;

      print('========== HTTP START RECORDING RESPONSE ==========');
      print('STATUS => ${response.statusCode}');
      print('DATA => ${response.data}');

      final String? sid = _findStringByKeys(
        response.data,
        const [
          'sid',
        ],
      );

      if (sid == null || sid.trim().isEmpty) {
        throw Exception('sid missing from start response');
      }

      response.data = {
        'success': true,
        'resourceId': resourceId,
        'resource': resourceId,
        'resource_id': resourceId,
        'sid': sid,
        'channel': channelName,
        'uid': uid,
        'mode': mode,
        'acquireRaw': acquireData,
        'startRaw': startRawData,
      };

      print('========== HTTP START FINAL DATA ==========');
      print(response.data);

      return ApiResponse.withSuccess(response);

    } catch (e) {
      print('HTTP START RECORDING ERROR => $e');
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  /// مهم:
  /// ده Laravel مش Node.
  /// هيضرب:
  /// https://gymatapp.com/api/provider/market/end-session
  Future<ApiResponse> endRecordingNode({
    required int sessionId,
    required String channelName,
    required int uid,
    required String resourceId,
    required String sid,
    String mode = 'mix',
  }) async {
    try {
      final Dio dio = _nodeDio();

      final Map<String, dynamic> body = {
        'session_id': sessionId.toString(),
        'channel': channelName,
        'channel_name': channelName,
        'cname': channelName,
        'uid': uid.toString(),
        'mode': mode,
        'resourceId': resourceId,
        'resource_id': resourceId,
        'resource': resourceId,
        'sid': sid,
      };

      print('========== HTTP NODE END RECORDING REQUEST ==========');
      print('URL => ${AppUrls.stopRecordingHttp}');
      print('BODY => $body');

      final Response response = await dio.post(
        AppUrls.stopRecordingHttp,
        data: body,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          responseType: ResponseType.plain,
          validateStatus: (_) => true,
        ),
      );

      final dynamic decodedData = _decodeResponseBody(response.data);
      response.data = decodedData;

      print('========== HTTP NODE END RECORDING RESPONSE ==========');
      print('STATUS => ${response.statusCode}');
      print('DATA => ${response.data}');

      final bool hasAxiosError =
          decodedData is Map &&
              (
                  decodedData['name'] == 'AxiosError' ||
                      decodedData['success'] == false ||
                      decodedData['status'] == 404 ||
                      decodedData['message']?.toString().contains('404') == true
              );

      if (response.statusCode == null ||
          response.statusCode! < 200 ||
          response.statusCode! >= 300 ||
          hasAxiosError) {
        throw Exception('Stop recording failed: ${response.data}');
      }

      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('HTTP NODE END RECORDING ERROR => $e');
      return ApiResponse.withError(e.toString());
    }
  }
  Future<ApiResponse> endSessionLaravel({
    required int sessionId,
    required String channel,
    required int uid,
    required String resourceId,
    required String sid,
    String mode = 'mix',
  }) async {
    try {
      final formData = FormData.fromMap({
        'session_id': sessionId.toString(),
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

  Future<ApiResponse> generateCommentToken() async {
    try {
      final DioClient dioClient = DioClient();

      final Response response = await dioClient.post(
        AppUrls.generateChatToken,
      );

      print('GENERATE COMMENT TOKEN STATUS => ${response.statusCode}');
      print('GENERATE COMMENT TOKEN DATA => ${response.data}');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('GENERATE COMMENT TOKEN ERROR => $e');
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> addComment(int sessionId, String comment) async {
    try {
      final formData = FormData.fromMap({
        'session_id': sessionId,
        'comment': comment,
      });

      final DioClient dioClient = DioClient();

      final Response response = await dioClient.post(
        AppUrls.comment,
        formData: formData,
      );

      print('ADD COMMENT STATUS => ${response.statusCode}');
      print('ADD COMMENT DATA => ${response.data}');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('ADD COMMENT ERROR => $e');
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
  }

  Future<ApiResponse> getAllComments(int sessionId) async {
    try {
      final DioClient dioClient = DioClient();

      final Response response = await dioClient.get(
        AppUrls.comment,
        queryParameters: {
          'session_id': sessionId,
        },
      );

      print('GET COMMENTS STATUS => ${response.statusCode}');
      print('GET COMMENTS DATA => ${response.data}');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('GET COMMENTS ERROR => $e');
      return ApiResponse.withError(ApiErrorHandler.handleError(e));
    }
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

      if (text.contains('=')) {
        try {
          return Map<String, dynamic>.from(Uri.splitQueryString(text));
        } catch (_) {}
      }
    }

    return null;
  }
  dynamic _decodeResponseBody(dynamic value) {
    if (value == null) return null;

    if (value is Map || value is List) {
      return value;
    }

    if (value is String) {
      final text = value.trim();

      if (text.isEmpty) return text;

      try {
        return jsonDecode(text);
      } catch (_) {
        return text;
      }
    }

    return value;
  }
  String? _findStringByKeys(
      dynamic value,
      List<String> keys,
      ) {
    if (value == null) return null;

    if (value is List) {
      for (final item in value) {
        final found = _findStringByKeys(item, keys);

        if (found != null && found.trim().isNotEmpty) {
          return found;
        }
      }

      return null;
    }

    final map = _asMap(value);

    if (map == null) return null;

    for (final key in keys) {
      final directValue = map[key];

      if (directValue != null && directValue.toString().trim().isNotEmpty) {
        return directValue.toString();
      }
    }

    for (final entry in map.entries) {
      final nestedValue = entry.value;

      if (nestedValue is Map ||
          nestedValue is String ||
          nestedValue is List) {
        final found = _findStringByKeys(nestedValue, keys);

        if (found != null && found.trim().isNotEmpty) {
          return found;
        }
      }
    }

    return null;
  }
}