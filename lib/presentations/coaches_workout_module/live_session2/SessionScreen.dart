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