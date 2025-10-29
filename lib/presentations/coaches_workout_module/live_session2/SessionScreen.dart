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
  final int sessionId,userId;
  int? remotUi;

  SessionScreen({Key? key, required this.channelName, required this.sessionId,required this.userId})
    : super(key: key);

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  final String appId = "dc4246621a9843a4afc108102cd7cf2d";
  RtcEngine? _engine;
  late LiveSessionProvider2 provider;

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
    initAgora(provider);
  }

  @override
  void dispose() {
    super.dispose();
    _dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Coach Live Session")),
      body: Consumer<LiveSessionProvider2>(
        builder: (context, provider, _) {
          return Stack(
            children: [
              Center(child: _localVideo()),
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
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return ChangeNotifierProvider.value(
                          value: provider,
                          child: Consumer<LiveSessionProvider2>(
                            builder: (context, provider, child) {
                              return Padding(padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 20,
                                ),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: ListView.separated(
                                        scrollDirection: Axis.vertical,
                                        itemBuilder: (context, index) {
                                          CommentData currentComment =
                                          provider.comments[index];
                                          return CommentCardItem(
                                            comment: currentComment,
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return const SizedBox(height: 20);
                                        },
                                        itemCount: provider.comments.length,
                                      ),
                                    ),
                                    Row(
                                      spacing: 20,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: CustomTextFormField(
                                            controller: provider.comentsController,
                                            hint: "Write a comment",
                                          ),
                                        ),
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: mainColor,
                                          ),
                                          child: IconButton(
                                            onPressed: () {
                                              provider.generateCommentToken(
                                                widget.sessionId,
                                                provider.comentsController.text,
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.send,
                                              size: 15,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),);
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
    await [Permission.microphone, Permission.camera].request();
    await _engine?.initialize(
      RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ),
    );

    await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine!.enableVideo();
    await _engine!.startPreview();
    _engine?.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {},
        onUserJoined: (connection, remoteId, elapsed) {
          setState(() {
            widget.remotUi = remoteId;
          });
        },
        onUserOffline: (connection, remoteId, reason) {},
        onTokenPrivilegeWillExpire: (connection, token) {
          provider.renewSessionToken(widget.sessionId);
          setState(() {
            if (provider.sessionToken != null) {
              token = provider.sessionToken!;
            }
          });
        },
      ),
    );

    if (provider.sessionToken != null) {
      await _engine?.joinChannel(
        token: provider.sessionToken!,
        channelId: widget.channelName,
        uid: widget.userId,
        options: const ChannelMediaOptions(
          publishCameraTrack: true,
          publishMicrophoneTrack: true,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
        ),
      );

      print("testToken${provider.sessionToken} channelName${widget.channelName} userId${widget.userId}");
    }
  }
  Widget _localVideo() {
    if (_engine == null) return Container();
    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: _engine!,
        canvas: const VideoCanvas(uid: 0),
      ),
    );
  }

  void _dispose() async{
    await _engine?.leaveChannel();
    await _engine?.release();
  }

}
