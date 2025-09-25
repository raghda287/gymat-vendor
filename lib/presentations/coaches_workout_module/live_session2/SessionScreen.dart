import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:permission_handler/permission_handler.dart';

class SessionScreen extends StatefulWidget {
  final String channelName;

  const SessionScreen({
    Key? key,
    required this.channelName,
  }) : super(key: key);

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  final String appId = "69c97f7f92994db790bb8375fba7f3e7";
  final String token = "";
  RtcEngine? _engine;

  bool _localUserJoined = false;
  List<int> _remoteUids = [];
  bool _engineInitialized = false;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  Future<void> initAgora() async {
    // Create the engine immediately to avoid late init access before first await
    _engine = createAgoraRtcEngine();

    // Request permissions
    await [Permission.microphone, Permission.camera].request();

    await _engine!.initialize(RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    // Register event handlers
    _engine!.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("Local user ${connection.localUid} joined");
          setState(() => _localUserJoined = true);
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("Remote user $remoteUid joined");
          setState(() => _remoteUids.add(remoteUid));
        },
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          debugPrint("Remote user $remoteUid left channel");
          setState(() => _remoteUids.remove(remoteUid));
        },
      ),
    );

    // Set role to broadcaster
    await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

    await _engine!.enableVideo();
    await _engine!.startPreview();

    setState(() {
      _engineInitialized = true;
    });

    // Join channel
    await _engine!.joinChannel(
      token: token,
      channelId: widget.channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  Future<void> _dispose() async {
    if (_engine != null) {
      try {
        await _engine!.leaveChannel();
      } catch (_) {}
      try {
        await _engine!.release();
      } catch (_) {}
    }
  }

  Widget _buildVideoViews() {
    if (_engine == null || !_engineInitialized) {
      return const Center(child: CircularProgressIndicator(color: mainColor,));
    }
    if (_remoteUids.isEmpty) {
      // Only coach is here → show fullscreen local preview
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: _engine!,
          canvas: const VideoCanvas(uid: 0),
        ),
      );
    } else {
      // Show coach + remote users
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: _remoteUids.length + 1, // coach + audience
        itemBuilder: (context, index) {
          if (index == 0) {
            // Coach (local video)
            return AgoraVideoView(
              controller: VideoViewController(
                rtcEngine: _engine!,
                canvas: const VideoCanvas(uid: 0),
              ),
            );
          } else {
            // Remote audience
            final uid = _remoteUids[index - 1];
            return AgoraVideoView(
              controller: VideoViewController.remote(
                rtcEngine: _engine!,
                canvas: VideoCanvas(uid: uid),
                connection: RtcConnection(channelId: widget.channelName),
              ),
            );
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Coach Live Session"),
      ),
      body: SafeArea(
        child: _buildVideoViews(),
      ),
    );
  }
}
