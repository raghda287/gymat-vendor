// import 'dart:async';
// import 'dart:convert';
//
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:flutter/material.dart';
// import 'package:gymatvendor/core/app_colors/app_colors.dart';
// import 'package:gymatvendor/presentations/coaches_workout_module/live_session2/Provider/LiveSessionProvider2.dart';
// import 'package:gymatvendor/presentations/coaches_workout_module/live_session2/Widgets/CommentCardItem.dart';
// import 'package:gymatvendor/presentations/widgets/custom_text_form/custom_text_form.dart';
// import 'package:gymatvendor/presentations/widgets/dialogs/scaffold_messanger.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
//
// import '../../../data/models/comment_model.dart';
// import '../../../injection.dart';
// import 'Repository/LiveSessionRepository2.dart';
//
// class SessionScreen extends StatefulWidget {
//   final String channelName;
//   final int sessionId;
//   final int userId;
//
//   const SessionScreen({
//     super.key,
//     required this.channelName,
//     required this.sessionId,
//     required this.userId,
//   });
//
//   @override
//   State<SessionScreen> createState() => _SessionScreenState();
// }
//
// class _SessionScreenState extends State<SessionScreen> {
//   final String appId = '0882413f73424b759b4feb811af9e76d';
//
//   RtcEngine? _engine;
//
//   late final LiveSessionProvider2 provider;
//   late final LiveSessionRepository2 liveSessionRepository;
//
//   final Set<int> _remoteUids = {};
//
//   bool _localUserJoined = false;
//   bool _engineReady = false;
//   bool _isJoining = false;
//   bool _isEndingSession = false;
//   bool _sessionEnded = false;
//   bool _agoraDisposed = false;
//
//   bool _recordingStarted = false;
//   bool _recordingStartRequested = false;
//   bool _isStartingRecording = false;
//
//   int? _currentUserId;
//   int? _recordingUid;
//
//   String _currentChannelName = '';
//
//   String? _resourceId;
//   String? _sid;
//
//   final String _recordingMode = 'mix';
//
//   static const bool _enableCloudRecording = true;
//
//   @override
//   void initState() {
//     super.initState();
//
//     provider = getIt<LiveSessionProvider2>();
//     liveSessionRepository = LiveSessionRepository2();
//
//     unawaited(_bootstrap());
//   }
//
//   Future<void> _bootstrap() async {
//     try {
//       debugPrint('========== LIVE BOOTSTRAP ==========');
//       debugPrint('widget sessionId => ${widget.sessionId}');
//       debugPrint('widget channelName => ${widget.channelName}');
//       debugPrint('widget userId => ${widget.userId}');
//
//       final bool permissionsGranted = await _requestPermissions();
//
//       if (!permissionsGranted) {
//         CustomScaffoldMessanger.showScaffoledMessanger(
//           title: 'Camera and microphone permissions are required',
//         );
//
//         if (mounted) Navigator.pop(context);
//         return;
//       }
//
//       final bool joined = await provider.joinSession(widget.sessionId);
//
//       debugPrint('joinSession result => $joined');
//       debugPrint('session token => ${provider.sessionToken}');
//       debugPrint('user id => ${provider.userSessionId}');
//       debugPrint('channel => ${provider.joinedChannelName}');
//
//       if (!joined ||
//           provider.sessionToken == null ||
//           provider.sessionToken!.isEmpty ||
//           provider.userSessionId == null ||
//           provider.userSessionId == 0 ||
//           provider.joinedChannelName == null ||
//           provider.joinedChannelName!.isEmpty) {
//         CustomScaffoldMessanger.showScaffoledMessanger(
//           title: 'Cannot join session',
//         );
//
//         if (mounted) Navigator.pop(context);
//         return;
//       }
//
//       _currentUserId = provider.userSessionId;
//       _currentChannelName = provider.joinedChannelName!;
//
//       _recordingUid = 900000000 + widget.sessionId;
//
//       await _initAgora();
//     } catch (e, stack) {
//       debugPrint('bootstrap error: $e');
//       debugPrint(stack.toString());
//
//       if (mounted) {
//         CustomScaffoldMessanger.showScaffoledMessanger(
//           title: e.toString(),
//         );
//       }
//     }
//   }
//
//   Future<bool> _requestPermissions() async {
//     final Map<Permission, PermissionStatus> statuses = await [
//       Permission.microphone,
//       Permission.camera,
//     ].request();
//
//     final bool micGranted =
//         statuses[Permission.microphone]?.isGranted ??
//             await Permission.microphone.isGranted;
//
//     final bool cameraGranted =
//         statuses[Permission.camera]?.isGranted ??
//             await Permission.camera.isGranted;
//
//     debugPrint('microphone permission => $micGranted');
//     debugPrint('camera permission => $cameraGranted');
//
//     return micGranted && cameraGranted;
//   }
//
//   Future<void> _initAgora() async {
//     try {
//       _engine = createAgoraRtcEngine();
//
//       await _engine!.initialize(
//         RtcEngineContext(
//           appId: appId,
//           channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
//         ),
//       );
//
//       _engine!.registerEventHandler(
//         RtcEngineEventHandler(
//           onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//             debugPrint('✅ Joined Channel: ${connection.channelId}');
//             debugPrint('✅ Local UID: ${connection.localUid}');
//
//             if (mounted) {
//               setState(() {
//                 _localUserJoined = true;
//                 _isJoining = false;
//               });
//             }
//
//             _scheduleRecordingStart();
//           },
//           onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
//             debugPrint('🟢 Remote user joined: $remoteUid');
//
//             if (mounted) {
//               setState(() {
//                 _remoteUids.add(remoteUid);
//               });
//             }
//           },
//           onUserOffline: (
//               RtcConnection connection,
//               int remoteUid,
//               UserOfflineReasonType reason,
//               ) {
//             debugPrint('🔴 Remote user left: $remoteUid');
//
//             if (mounted) {
//               setState(() {
//                 _remoteUids.remove(remoteUid);
//               });
//             }
//           },
//           onTokenPrivilegeWillExpire: (
//               RtcConnection connection,
//               String token,
//               ) async {
//             debugPrint('Agora token will expire. Renewing...');
//
//             await provider.renewSessionToken(widget.sessionId);
//
//             if (provider.sessionToken != null &&
//                 provider.sessionToken!.isNotEmpty) {
//               await _engine?.renewToken(provider.sessionToken!);
//               debugPrint('Agora token renewed');
//             }
//           },
//           onLocalVideoStateChanged: (
//               VideoSourceType source,
//               LocalVideoStreamState state,
//               LocalVideoStreamReason error,
//               ) {
//             debugPrint(
//               'LOCAL VIDEO STATE => source: $source, state: $state, error: $error',
//             );
//           },
//           onConnectionStateChanged: (
//               RtcConnection connection,
//               ConnectionStateType state,
//               ConnectionChangedReasonType reason,
//               ) {
//             debugPrint('CONNECTION STATE => state: $state, reason: $reason');
//           },
//           onError: (ErrorCodeType err, String msg) {
//             debugPrint('Agora Error: $err - $msg');
//           },
//         ),
//       );
//
//       await _engine!.setClientRole(
//         role: ClientRoleType.clientRoleBroadcaster,
//       );
//
//       await _engine!.enableVideo();
//       await _engine!.enableAudio();
//
//       await _engine!.enableLocalVideo(true);
//       await _engine!.muteLocalVideoStream(false);
//       await _engine!.muteLocalAudioStream(false);
//
//       if (mounted) {
//         setState(() {
//           _engineReady = true;
//         });
//       }
//
//       await Future<void>.delayed(const Duration(milliseconds: 300));
//
//       await _engine!.startPreview();
//
//       if (!mounted) return;
//
//       setState(() {
//         _isJoining = true;
//       });
//
//       await _engine!.joinChannel(
//         token: provider.sessionToken!,
//         channelId: _currentChannelName,
//         uid: _currentUserId!,
//         options: const ChannelMediaOptions(
//           channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
//           clientRoleType: ClientRoleType.clientRoleBroadcaster,
//           publishCameraTrack: true,
//           publishMicrophoneTrack: true,
//           autoSubscribeAudio: true,
//           autoSubscribeVideo: true,
//         ),
//       );
//
//       debugPrint('Agora joinChannel called');
//       debugPrint('Channel => $_currentChannelName');
//       debugPrint('Host UID => $_currentUserId');
//       debugPrint('Recording UID => $_recordingUid');
//     } catch (e, stack) {
//       debugPrint('❌ Agora Init Error: $e');
//       debugPrint(stack.toString());
//
//       if (mounted) {
//         setState(() {
//           _isJoining = false;
//         });
//
//         CustomScaffoldMessanger.showScaffoledMessanger(
//           title: e.toString(),
//         );
//       }
//     }
//   }
//
//   void _scheduleRecordingStart() {
//     if (!_enableCloudRecording) return;
//
//     Future<void>.delayed(const Duration(seconds: 3), () {
//       if (!mounted || _agoraDisposed || _sessionEnded) return;
//       unawaited(_startRecordingHttpOnce());
//     });
//   }
//
//   Future<void> _startRecordingHttpOnce() async {
//     if (_recordingStartRequested || _recordingStarted) return;
//
//     if (_recordingUid == null || _recordingUid == 0) {
//       debugPrint('Cannot start recording: invalid recording uid');
//       return;
//     }
//
//     if (_currentChannelName.isEmpty) {
//       debugPrint('Cannot start recording: channel is empty');
//       return;
//     }
//
//     _recordingStartRequested = true;
//
//     if (mounted) {
//       setState(() {
//         _isStartingRecording = true;
//       });
//     }
//
//     try {
//       debugPrint('========== START RECORDING FROM FLUTTER ==========');
//       debugPrint('CHANNEL => $_currentChannelName');
//       debugPrint('HOST UID => $_currentUserId');
//       debugPrint('RECORDING UID => $_recordingUid');
//
//       final apiResponse = await liveSessionRepository.startRecording(
//         channelName: _currentChannelName,
//         uid: _recordingUid!,
//         mode: _recordingMode,
//       );
//
//       final response = apiResponse.response;
//
//       if (response == null) {
//         throw Exception('Start recording failed');
//       }
//
//       final dynamic data = response.data;
//
//       final String? resourceId = _findStringByKeys(
//         data,
//         const [
//           'resourceId',
//           'resource_id',
//           'resource',
//         ],
//       );
//
//       final String? sid = _findStringByKeys(
//         data,
//         const [
//           'sid',
//         ],
//       );
//
//       if (resourceId == null || resourceId.trim().isEmpty) {
//         throw Exception('resourceId missing after acquire');
//       }
//
//       if (sid == null || sid.trim().isEmpty) {
//         throw Exception('sid missing after start');
//       }
//
//       if (!mounted) return;
//
//       setState(() {
//         _recordingStarted = true;
//         _resourceId = resourceId;
//         _sid = sid;
//       });
//
//       debugPrint('✅ HTTP recording started');
//       debugPrint('RESOURCE ID => $_resourceId');
//       debugPrint('SID => $_sid');
//     } catch (e, stack) {
//       _recordingStartRequested = false;
//
//       debugPrint('❌ HTTP start recording failed: $e');
//       debugPrint(stack.toString());
//
//       if (mounted) {
//         CustomScaffoldMessanger.showScaffoledMessanger(
//           title: 'Recording failed, live is still running',
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isStartingRecording = false;
//         });
//       }
//     }
//   }
//
//   Future<void> _endSessionAndBack() async {
//     if (_isEndingSession || _sessionEnded) return;
//
//     setState(() {
//       _isEndingSession = true;
//     });
//
//     try {
//       if (_recordingStarted &&
//           _resourceId != null &&
//           _resourceId!.trim().isNotEmpty &&
//           _sid != null &&
//           _sid!.trim().isNotEmpty &&
//           _recordingUid != null &&
//           _recordingUid != 0) {
//
//         final nodeEndResponse = await liveSessionRepository.endRecordingNode(
//           sessionId: widget.sessionId,
//           channelName: _currentChannelName,
//           uid: _recordingUid!,
//           resourceId: _resourceId!,
//           sid: _sid!,
//           mode: _recordingMode,
//         );
//
//         final nodeData = nodeEndResponse.response?.data;
//         debugPrint('NODE END RESPONSE => $nodeData');
//
//         final bool nodeStopped =
//             nodeEndResponse.response?.statusCode == 200 &&
//                 nodeData is Map &&
//                 nodeData['success'] == true;
//
//         if (!nodeStopped) {
//           CustomScaffoldMessanger.showScaffoledMessanger(
//             title: 'فشل حفظ التسجيل، لا تنهي الجلسة الآن',
//           );
//
//           if (mounted) {
//             setState(() {
//               _isEndingSession = false;
//             });
//           }
//           return;
//         }
//
//         final laravelResponse = await liveSessionRepository.endSessionLaravel(
//           sessionId: widget.sessionId,
//           channel: _currentChannelName,
//           uid: _recordingUid!,
//           resourceId: _resourceId!,
//           sid: _sid!,
//           mode: _recordingMode,
//         );
//
//         debugPrint('LARAVEL END RESPONSE => ${laravelResponse.response?.data}');
//       } else {
//         debugPrint('Recording not started. Closing live only.');
//       }
//
//       _sessionEnded = true;
//
//       await _disposeAgora();
//
//       if (!mounted) return;
//       Navigator.of(context).pop(true);
//     } catch (e, stack) {
//       debugPrint('❌ End session error: $e');
//       debugPrint(stack.toString());
//
//       if (mounted) {
//         setState(() {
//           _isEndingSession = false;
//         });
//
//         CustomScaffoldMessanger.showScaffoledMessanger(
//           title: 'حدث خطأ أثناء إنهاء الجلسة',
//         );
//       }
//     }
//   }
//   Future<void> _disposeAgora() async {
//     if (_agoraDisposed) return;
//
//     _agoraDisposed = true;
//
//     try {
//       await _engine?.stopPreview();
//     } catch (e) {
//       debugPrint('stopPreview error: $e');
//     }
//
//     try {
//       await _engine?.leaveChannel();
//     } catch (e) {
//       debugPrint('leaveChannel error: $e');
//     }
//
//     try {
//       await _engine?.release();
//       _engine = null;
//       debugPrint('Agora disposed successfully');
//     } catch (e) {
//       debugPrint('release error: $e');
//     }
//   }
//
//   Map<String, dynamic>? _asMap(dynamic value) {
//     if (value == null) return null;
//
//     if (value is Map<String, dynamic>) {
//       return value;
//     }
//
//     if (value is Map) {
//       return Map<String, dynamic>.from(value);
//     }
//
//     if (value is String) {
//       final String text = value.trim();
//
//       if (text.isEmpty) return null;
//
//       try {
//         final decoded = jsonDecode(text);
//
//         if (decoded is Map<String, dynamic>) {
//           return decoded;
//         }
//
//         if (decoded is Map) {
//           return Map<String, dynamic>.from(decoded);
//         }
//       } catch (_) {}
//
//       if (text.contains('=')) {
//         try {
//           return Map<String, dynamic>.from(Uri.splitQueryString(text));
//         } catch (_) {}
//       }
//     }
//
//     return null;
//   }
//
//   String? _findStringByKeys(dynamic value, List<String> keys) {
//     if (value == null) return null;
//
//     if (value is List) {
//       for (final item in value) {
//         final found = _findStringByKeys(item, keys);
//
//         if (found != null && found.trim().isNotEmpty) {
//           return found;
//         }
//       }
//
//       return null;
//     }
//
//     final map = _asMap(value);
//
//     if (map == null) return null;
//
//     for (final key in keys) {
//       final directValue = map[key];
//
//       if (directValue != null && directValue.toString().trim().isNotEmpty) {
//         return directValue.toString();
//       }
//     }
//
//     for (final entry in map.entries) {
//       final nestedValue = entry.value;
//
//       if (nestedValue is Map || nestedValue is String || nestedValue is List) {
//         final found = _findStringByKeys(nestedValue, keys);
//
//         if (found != null && found.trim().isNotEmpty) {
//           return found;
//         }
//       }
//     }
//
//     return null;
//   }
//
//   Widget _localVideo() {
//     if (_engine == null || !_engineReady) {
//       return _loadingView();
//     }
//
//     return SizedBox.expand(
//       child: AgoraVideoView(
//         key: ValueKey(
//           'local_agora_${_currentChannelName}_${_currentUserId}_${_engineReady ? 1 : 0}',
//         ),
//         controller: VideoViewController(
//           rtcEngine: _engine!,
//           canvas: const VideoCanvas(
//             uid: 0,
//             sourceType: VideoSourceType.videoSourceCameraPrimary,
//             renderMode: RenderModeType.renderModeHidden,
//           ),
//           useFlutterTexture: true,
//           useAndroidSurfaceView: false,
//         ),
//       ),
//     );
//   }
//   Widget _remoteVideos() {
//     if (_engine == null || _remoteUids.isEmpty) {
//       return const SizedBox();
//     }
//
//     final List<int> remoteList = _remoteUids.toList();
//
//     return Positioned(
//       top: 40,
//       right: 16,
//       child: SizedBox(
//         width: 100,
//         height: MediaQuery.of(context).size.height * 0.6,
//         child: ListView.separated(
//           itemCount: remoteList.length,
//           separatorBuilder: (_, __) => const SizedBox(height: 8),
//           itemBuilder: (context, index) {
//             final int remoteUid = remoteList[index];
//
//             return ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: Container(
//                 width: 100,
//                 height: 140,
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     color: Colors.white,
//                     width: 2,
//                   ),
//                   color: Colors.black,
//                 ),
//                 child: AgoraVideoView(
//                   controller: VideoViewController.remote(
//                     rtcEngine: _engine!,
//                     canvas: VideoCanvas(
//                       uid: remoteUid,
//                       renderMode: RenderModeType.renderModeHidden,
//                     ),
//                     connection: RtcConnection(
//                       channelId: _currentChannelName,
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _loadingView() {
//     return Container(
//       color: Colors.black,
//       child: const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircularProgressIndicator(
//               color: Colors.white,
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Connecting...',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _debugInfo() {
//     return Positioned(
//       bottom: 100,
//       left: 20,
//       child: Container(
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: Colors.black.withOpacity(0.7),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: DefaultTextStyle(
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 12,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Engine Ready: ${_engineReady ? "✅" : "❌"}'),
//               Text('Local Joined: ${_localUserJoined ? "✅" : "❌"}'),
//               Text('Joining: ${_isJoining ? "⏳" : "✅"}'),
//               Text(
//                 'Recording: ${_isStartingRecording ? "⏳" : (_recordingStarted ? "✅" : "❌")}',
//               ),
//               Text('Channel: $_currentChannelName'),
//               Text('Host UID: $_currentUserId'),
//               Text('Recording UID: $_recordingUid'),
//               Text('Remote UIDs: ${_remoteUids.toList()}'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _commentsButton(LiveSessionProvider2 liveProvider) {
//     return PositionedDirectional(
//       bottom: 20,
//       end: 20,
//       child: InkWell(
//         child: Container(
//           width: 70,
//           height: 70,
//           decoration: const BoxDecoration(
//             shape: BoxShape.circle,
//             color: mainColor,
//           ),
//           child: const Icon(
//             Icons.message,
//             size: 30,
//             color: Colors.white,
//           ),
//         ),
//         onTap: () async {
//           await liveProvider.getAllComments(widget.sessionId);
//
//           if (!mounted) return;
//
//           showModalBottomSheet(
//             isScrollControlled: true,
//             context: context,
//             backgroundColor: Colors.white,
//             shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.vertical(
//                 top: Radius.circular(20),
//               ),
//             ),
//             builder: (context) {
//               return ChangeNotifierProvider.value(
//                 value: liveProvider,
//                 child: Consumer<LiveSessionProvider2>(
//                   builder: (context, provider, child) {
//                     return Padding(
//                       padding: EdgeInsets.only(
//                         bottom: MediaQuery.of(context).viewInsets.bottom,
//                       ),
//                       child: SizedBox(
//                         height: MediaQuery.of(context).size.height * 0.7,
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 20,
//                             vertical: 20,
//                           ),
//                           child: Column(
//                             children: [
//                               Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   const Text(
//                                     'Comments',
//                                     style: TextStyle(
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   IconButton(
//                                     onPressed: () => Navigator.pop(context),
//                                     icon: const Icon(Icons.close),
//                                   ),
//                                 ],
//                               ),
//                               const Divider(),
//                               const SizedBox(height: 10),
//                               Expanded(
//                                 child: provider.comments.isEmpty
//                                     ? const Center(
//                                   child: Text(
//                                     'No comments yet',
//                                     style: TextStyle(
//                                       color: Colors.grey,
//                                       fontSize: 16,
//                                     ),
//                                   ),
//                                 )
//                                     : ListView.separated(
//                                   itemCount: provider.comments.length,
//                                   separatorBuilder: (_, __) {
//                                     return const SizedBox(height: 20);
//                                   },
//                                   itemBuilder: (context, index) {
//                                     final CommentData currentComment =
//                                     provider.comments[index];
//
//                                     return CommentCardItem(
//                                       comment: currentComment,
//                                     );
//                                   },
//                                 ),
//                               ),
//                               const SizedBox(height: 10),
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Expanded(
//                                     child: CustomTextFormField(
//                                       controller: provider.comentsController,
//                                       hint: 'Write a comment',
//                                     ),
//                                   ),
//                                   const SizedBox(width: 10),
//                                   Container(
//                                     width: 50,
//                                     height: 50,
//                                     decoration: const BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: mainColor,
//                                     ),
//                                     child: IconButton(
//                                       onPressed: () async {
//                                         final String comment = provider
//                                             .comentsController.text
//                                             .trim();
//
//                                         if (comment.isEmpty) return;
//
//                                         await provider.generateCommentToken(
//                                           widget.sessionId,
//                                           comment,
//                                         );
//
//                                         provider.comentsController.clear();
//
//                                         await provider.getAllComments(
//                                           widget.sessionId,
//                                         );
//                                       },
//                                       icon: const Icon(
//                                         Icons.send,
//                                         size: 20,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         await _endSessionAndBack();
//         return false;
//       },
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         appBar: AppBar(
//           title: const Text('Coach Live Session'),
//           actions: [
//             TextButton(
//               onPressed: _isEndingSession ? null : _endSessionAndBack,
//               child: _isEndingSession
//                   ? const SizedBox(
//                 width: 18,
//                 height: 18,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2,
//                   color: Colors.white,
//                 ),
//               )
//                   : const Text(
//                 'End',
//                 style: TextStyle(
//                   color: Colors.red,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         body: Consumer<LiveSessionProvider2>(
//           builder: (context, liveProvider, _) {
//             return Stack(
//               children: [
//                 Positioned.fill(
//                   child: _localVideo(),
//                 ),
//                 _remoteVideos(),
//                 _debugInfo(),
//                 _commentsButton(liveProvider),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     unawaited(_disposeAgora());
//     super.dispose();
//   }
// }


import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/live_session2/Provider/LiveSessionProvider2.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/live_session2/Widgets/CommentCardItem.dart';
import 'package:gymatvendor/presentations/widgets/custom_text_form/custom_text_form.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../data/models/comment_model.dart';
import '../../../injection.dart';

class SessionScreen extends StatefulWidget {
  final String channelName;
  final int sessionId;
  final int userId;

  const SessionScreen({
    Key? key,
    required this.channelName,
    required this.sessionId,
    required this.userId,
  }) : super(key: key);

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  final String appId = "dc4246621a9843a4afc108102cd7cf2d";
  RtcEngine? _engine;
  late LiveSessionProvider2 provider;

  // Track remote users
  final Set<int> _remoteUids = {};
  bool _localUserJoined = false;
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _engine = createAgoraRtcEngine();
    provider = getIt();
    _joinSession(provider, widget.sessionId);
  }

  Future<void> _joinSession(
      LiveSessionProvider2 provider,
      int sessionId,
      ) async {
    await provider.joinSession(sessionId);

    // Use the userId from joinSession response
    _currentUserId = provider.userSessionId ?? widget.userId;

    debugPrint("🔑 Using User ID: $_currentUserId");
    debugPrint("🔑 Session Token: ${provider.sessionToken}");

    initAgora(provider);
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Coach Live Session")),
      body: Consumer<LiveSessionProvider2>(
        builder: (context, provider, _) {
          return Stack(
            children: [
              // Local video background (FULL SCREEN)
              Positioned.fill(
                child: _localUserJoined
                    ? _localVideo()
                    : const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 20),
                      Text(
                        'Connecting...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Remote users in small canvases (top-right)
              if (_remoteUids.isNotEmpty)
                Positioned(
                  top: 40,
                  right: 16,
                  child: Container(
                    width: 100,
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.6,
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: _remoteUids.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final remoteUid = _remoteUids.toList()[index];
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: 100,
                            height: 140,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 2),
                              color: Colors.black,
                            ),
                            child: AgoraVideoView(
                              controller: VideoViewController.remote(
                                rtcEngine: _engine!,
                                canvas: VideoCanvas(uid: remoteUid),
                                connection: RtcConnection(
                                  channelId: widget.channelName,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

              // Debug info (REMOVE IN PRODUCTION)
              Positioned(
                bottom: 100,
                left: 20,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Local: ${_localUserJoined ? "✅" : "❌"}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'Remote UIDs: ${_remoteUids.toList()}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'Channel: ${widget.channelName}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'My UID: $_currentUserId',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'Total Users: ${_remoteUids.length + (_localUserJoined ? 1 : 0)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Comments button (bottom-right)
              PositionedDirectional(
                bottom: 20,
                end: 20,
                child: InkWell(
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: mainColor,
                    ),
                    child: const Icon(
                      Icons.message,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () async {
                    await provider.getAllComments(widget.sessionId);
                    if (!mounted) return;

                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (context) {
                        return ChangeNotifierProvider.value(
                          value: provider,
                          child: Consumer<LiveSessionProvider2>(
                            builder: (context, provider, child) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context)
                                      .viewInsets
                                      .bottom,
                                ),
                                child: Container(
                                  height:
                                  MediaQuery.of(context).size.height * 0.7,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 20,
                                  ),
                                  child: Column(
                                    children: [
                                      // Header
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Comments",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            icon: const Icon(Icons.close),
                                          ),
                                        ],
                                      ),
                                      const Divider(),
                                      const SizedBox(height: 10),

                                      // Comments List
                                      Expanded(
                                        child: provider.comments.isEmpty
                                            ? const Center(
                                          child: Text(
                                            "No comments yet",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16,
                                            ),
                                          ),
                                        )
                                            : ListView.separated(
                                          scrollDirection: Axis.vertical,
                                          itemBuilder: (context, index) {
                                            CommentData currentComment =
                                            provider.comments[index];
                                            return CommentCardItem(
                                              comment: currentComment,
                                            );
                                          },
                                          separatorBuilder:
                                              (context, index) {
                                            return const SizedBox(
                                              height: 20,
                                            );
                                          },
                                          itemCount:
                                          provider.comments.length,
                                        ),
                                      ),

                                      const SizedBox(height: 10),

                                      // Comment Input
                                      Row(
                                        spacing: 10,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: CustomTextFormField(
                                              controller:
                                              provider.comentsController,
                                              hint: "Write a comment",
                                            ),
                                          ),
                                          Container(
                                            width: 50,
                                            height: 50,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: mainColor,
                                            ),
                                            child: IconButton(
                                              onPressed: () {
                                                if (provider.comentsController
                                                    .text
                                                    .trim()
                                                    .isNotEmpty) {
                                                  provider.generateCommentToken(
                                                    widget.sessionId,
                                                    provider
                                                        .comentsController.text,
                                                  );
                                                }
                                              },
                                              icon: const Icon(
                                                Icons.send,
                                                size: 20,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> initAgora(LiveSessionProvider2 provider) async {
    // Request permissions
    await [Permission.microphone, Permission.camera].request();

    // Validate token and channel name before initializing
    if (provider.sessionToken == null || provider.sessionToken!.isEmpty) {
      debugPrint("❌ Error: Session token is null or empty");
      return;
    }

    if (widget.channelName.isEmpty) {
      debugPrint("❌ Error: Channel name is empty");
      return;
    }

    if (_currentUserId == null) {
      debugPrint("❌ Error: User ID is null");
      return;
    }

    // Initialize Agora engine
    await _engine?.initialize(
      RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ),
    );

    // Register event handlers BEFORE joining channel
    _engine?.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          debugPrint("✅ Successfully joined channel: ${connection.channelId}");
          debugPrint("✅ Local UID: ${connection.localUid}");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (connection, remoteUid, elapsed) {
          debugPrint("🟢 Remote user joined: $remoteUid");
          setState(() {
            _remoteUids.add(remoteUid);
          });
        },
        onUserOffline: (connection, remoteUid, reason) {
          debugPrint("🔴 Remote user left: $remoteUid, reason: $reason");
          setState(() {
            _remoteUids.remove(remoteUid);
          });
        },
        onTokenPrivilegeWillExpire: (connection, token) async {
          debugPrint("⚠️ Token will expire, renewing...");
          await provider.renewSessionToken(widget.sessionId);
          if (provider.sessionToken != null) {
            await _engine?.renewToken(provider.sessionToken!);
            debugPrint("✅ Token renewed successfully");
          }
        },
        onError: (ErrorCodeType err, String msg) {
          debugPrint("❌ Agora Error: $err - $msg");
        },
        onConnectionStateChanged: (connection, state, reason) {
          debugPrint("🔄 Connection state changed: $state, reason: $reason");
        },
        onRtcStats: (connection, stats) {
          debugPrint("📊 Users in channel: ${stats.userCount}");
        },
      ),
    );

    // Set client role to broadcaster
    await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

    // Enable video
    await _engine!.enableVideo();
    await _engine!.startPreview();

    try {
      // Join channel with proper options using the correct user ID
      await _engine?.joinChannel(
        token: provider.sessionToken!,
        channelId: widget.channelName,
        uid: _currentUserId!,
        options: const ChannelMediaOptions(
          publishCameraTrack: true,
          publishMicrophoneTrack: true,
          autoSubscribeAudio: true,
          autoSubscribeVideo: true,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
        ),
      );

      debugPrint("✅ Join channel request sent successfully");
      debugPrint("🔑 Token: ${provider.sessionToken}");
      debugPrint("📡 Channel: ${widget.channelName}");
      debugPrint("👤 UID: $_currentUserId");
    } catch (e) {
      debugPrint("❌ Error joining channel: $e");
    }
  }

  // Local video widget (FULL SCREEN)
  Widget _localVideo() {
    if (_engine == null) return Container();
    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: _engine!,
        canvas: const VideoCanvas(uid: 0),
      ),
    );
  }

  // Dispose Agora resources
  void _dispose() async {
    try {
      await _engine?.leaveChannel();
      await _engine?.release();
      debugPrint("✅ Agora engine disposed successfully");
    } catch (e) {
      debugPrint("❌ Error disposing engine: $e");
    }
  }
}