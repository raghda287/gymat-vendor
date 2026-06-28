import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/core/text_styles/text_styles.dart';
import 'package:gymatvendor/main.dart';
import 'package:gymatvendor/presentations/chat_module/widgets/emoji_picker.dart';
import 'package:gymatvendor/presentations/chat_module/widgets/record_timer_widget.dart';
import 'package:gymatvendor/presentations/widgets/custom_svg/CustomSvgIcon.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import '../../../data/models/userChatModel.dart';
import '../../../injection.dart';
import '../provider/chat_provider.dart';

class MessageContanerWidget extends StatefulWidget {
  final VoidCallback onPressed;
  final ValueChanged<bool> onEmojiShowing;
  final UserChatModel user;

  const MessageContanerWidget({
    super.key,
    required this.onPressed,
    required this.onEmojiShowing,
    required this.user,
  });

  @override
  State<MessageContanerWidget> createState() => _MessageContanerWidgetState();
}

class _MessageContanerWidgetState extends State<MessageContanerWidget> {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final AudioRecorder recorder = AudioRecorder();

  String lang = navigatorKey.currentContext!.locale.languageCode;

  bool isTyping = false;
  bool isShowEmoji = false;
  bool isRecording = false;
  bool isStopping = false;

  Timer? timer;
  int seconds = 0;

  @override
  void initState() {
    super.initState();

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        isShowEmoji = false;
        widget.onEmojiShowing(false);
        if (mounted) setState(() {});
      }
    });
  }

  Future<bool> _checkPermission() async {
    final micStatus = await Permission.microphone.status;

    if (micStatus.isGranted) {
      return true;
    }

    final requested = await Permission.microphone.request();

    if (requested.isGranted) {
      return true;
    }

    if (requested.isDenied || requested.isPermanentlyDenied) {
      await openAppSettings();
    }

    return false;
  }

  void _startTimer() {
    timer?.cancel();
    seconds = 0;

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!isRecording) return;

      seconds++;

      if (mounted) {
        setState(() {});
      }
    });
  }

  void _stopTimer() {
    timer?.cancel();
    timer = null;
  }

  Future<void> _start() async {
    if (isRecording || isStopping) return;

    try {
      final hasPermission = await _checkPermission();
      if (!hasPermission) return;

      final directory = await getApplicationDocumentsDirectory();

      final path =
          '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.aac';

      await recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
        ),
        path: path,
      );

      final recording = await recorder.isRecording();

      if (!mounted) return;

      setState(() {
        isRecording = recording;
        seconds = 0;
      });

      if (recording) {
        _startTimer();
      }
    } catch (e) {
      debugPrint('recordingError=>>>$e');

      if (mounted) {
        setState(() {
          isRecording = false;
          seconds = 0;
        });
      }

      _stopTimer();
    }
  }

  Future<void> _stop() async {
    if (!isRecording || isStopping) return;

    isStopping = true;

    try {
      final duration = seconds;
      final String? path = await recorder.stop();

      _stopTimer();

      if (mounted) {
        setState(() {
          isRecording = false;
          seconds = 0;
        });
      }

      if (path != null && duration >= 1) {
        ChatProvider provider = getIt();
        provider.sendMessage(
          widget.user.room_id,
          'record',
          path,
          duration,
          null,
        );
      }
    } catch (e) {
      debugPrint('stopRecordingError=>>>$e');

      _stopTimer();

      if (mounted) {
        setState(() {
          isRecording = false;
          seconds = 0;
        });
      }
    } finally {
      isStopping = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: isRecording ? 64 : null,
          padding: const EdgeInsets.only(
            left: 12,
            right: 12,
            top: 8,
            bottom: 8,
          ),
          color: AppTheme.isDarkMode() ? msgLeftDarkColor : Colors.white,
          constraints: const BoxConstraints(
            minHeight: 48,
            maxHeight: 120,
          ),
          child: Row(
            children: [
              Expanded(
                child: isRecording
                    ? RecordTimerWidget(seconds: seconds)
                    : TextFormField(
                  focusNode: focusNode,
                  maxLines: null,
                  controller: controller,
                  cursorColor: mainColor,
                  style: AppTextStyles()
                      .normalText(fontSize: 16)
                      .textColorNormal(
                    AppTheme.isDarkMode()
                        ? Colors.white
                        : Colors.black,
                  ),
                  onChanged: (value) {
                    final typing = value.trim().isNotEmpty;

                    if (typing != isTyping) {
                      setState(() {
                        isTyping = typing;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    hintStyle: AppTextStyles()
                        .normalText(fontSize: 16)
                        .textColorNormal(
                      AppTheme.isDarkMode()
                          ? msgContentIconColorDark
                          : msgContentIconColorLight,
                    ),
                    hintText: 'Type a message...'.tr(),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    prefixIcon: SizedBox(
                      width: 24,
                      height: 24,
                      child: IconButton(
                        onPressed: () {
                          focusNode.unfocus();
                          focusNode.canRequestFocus = false;

                          isShowEmoji = !isShowEmoji;
                          widget.onEmojiShowing(isShowEmoji);

                          setState(() {});
                        },
                        icon: Icon(
                          Icons.emoji_emotions_outlined,
                          color: AppTheme.isDarkMode()
                              ? msgContentIconColorDark
                              : msgContentIconColorLight,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(
                width: isTyping ? 0 : 42,
                height: isTyping ? 0 : 42,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapDown: (_) async {
                    await _start();
                  },
                  onTapUp: (_) async {
                    await _stop();
                  },
                  onTapCancel: () async {
                    await _stop();
                  },
                  onPanEnd: (_) async {
                    await _stop();
                  },
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: null,
                    icon: CustomSvgIcon(
                      assetName: 'mic',
                      color: AppTheme.isDarkMode()
                          ? msgContentIconColorDark
                          : msgContentIconColorLight,
                    ),
                  ),
                ),
              ),

              SizedBox(
                width: isTyping ? 0 : 42,
                height: isTyping ? 0 : 42,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: widget.onPressed,
                  icon: CustomSvgIcon(
                    assetName: 'camera',
                    color: AppTheme.isDarkMode()
                        ? msgContentIconColorDark
                        : msgContentIconColorLight,
                  ),
                ),
              ),

              Visibility(
                visible: isTyping,
                child: IconButton(
                  onPressed: () {
                    final text = controller.text.trim();

                    if (text.isEmpty) return;

                    controller.clear();

                    ChatProvider provider = getIt();
                    provider.sendMessage(
                      widget.user.room_id,
                      'text',
                      text,
                      0,
                      null,
                    );

                    isTyping = false;

                    if (mounted) {
                      setState(() {});
                    }
                  },
                  icon: Transform.scale(
                    scaleX: lang == 'ar' ? -1 : 1,
                    child: const CustomSvgIcon(
                      assetName: 'send',
                      color: mainColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        EmojiPickerWidget(
          controller: controller,
          isShow: isShowEmoji,
          onEmojiTyping: (bool value) {
            if (isTyping != value) {
              setState(() {
                isTyping = value;
              });
            }
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    controller.dispose();
    focusNode.dispose();
    recorder.dispose();
    super.dispose();
  }
}