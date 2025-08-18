/*
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/navigator/navigator.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/add_workout_screen/videoTrimmer.dart';
import 'package:video_editor/video_editor.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../data/models/local_trimmed_video_info.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';

class TrimmerViewScreen extends StatefulWidget {
  final File file;

  const TrimmerViewScreen({super.key, required this.file});

  @override
  State<TrimmerViewScreen> createState() => _TrimmerViewScreenState();
}

class _TrimmerViewScreenState extends State<TrimmerViewScreen> {
  final _exportingProgress = ValueNotifier<double>(0.0);
  final _isExporting = ValueNotifier<bool>(false);
  final double height = 60;
  bool isLoaded = false;
  late VideoEditorController _controller = VideoEditorController.file(
    widget.file,
    minDuration: const Duration(seconds: 1),
    maxDuration: const Duration(seconds: 5),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.initialize().then((_){
      isLoaded = true;
        setState(() {});


    }).catchError((error) {
      NavigatorHandler.pop();
    }, test: (e) => e is VideoMinDurationError);
  }

  */
/*  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(
      showToolBar: true,
      showBackArrow: true,
      title: 'Exercise'.tr(),
      elevation: 1,
      fontColor: Colors.white,
      isMainBack: true,
      bgColor: dark,
        actions: isLoaded?[IconButton(onPressed: (){
          saveVideo();
        }, icon: const Icon(Icons.done_rounded,color: Colors.white,))]:[],
    ),body:Column(children: [

    ],),);
  }*//*


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(
        showToolBar: true,
        showBackArrow: true,
        title: 'Exercise'.tr(),
        elevation: 1,
        fontColor: Colors.white,
        isMainBack: true,
        bgColor: dark,
        actions: isLoaded? [
          IconButton(
            onPressed: () {
              saveVideo();
            },
            icon: const Icon(Icons.done_rounded, color: Colors.white),
          ),
        ]:[],
      ),
      body:
          _controller.initialized
              ? Column(
                children: [
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CropGridViewer.preview(controller: _controller),
                        AnimatedBuilder(
                          animation: _controller.video,
                          builder:
                              (_, __) => AnimatedOpacity(
                                opacity: _controller.isPlaying ? 0 : 1,
                                duration: kThemeAnimationDuration,
                                child: GestureDetector(
                                  onTap: _controller.video.play,
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.play_arrow,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    height: 160,
                    margin: const EdgeInsets.only(top: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _trimSlider(),
                    ),
                  ),
                ],
              )
              : const Center(child: CircularProgressIndicator()),
    );
  }

  String formatter(Duration duration) => [
    duration.inMinutes.remainder(60).toString().padLeft(2, '0'),
    duration.inSeconds.remainder(60).toString().padLeft(2, '0'),
  ].join(":");

  List<Widget> _trimSlider() {
    return [
      AnimatedBuilder(
        animation: Listenable.merge([_controller, _controller.video]),
        builder: (_, __) {
          final int duration = _controller.videoDuration.inSeconds;
          final double pos = _controller.trimPosition * duration;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: height / 4),
            child: Row(
              children: [
                Text(formatter(Duration(seconds: pos.toInt()))),
                const Expanded(child: SizedBox()),
                AnimatedOpacity(
                  opacity: _controller.isTrimming ? 1 : 0,
                  duration: kThemeAnimationDuration,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(formatter(_controller.startTrim)),
                      const SizedBox(width: 10),
                      Text(formatter(_controller.endTrim)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(vertical: height / 4),
        child: TrimSlider(
          controller: _controller,
          height: height,
          horizontalMargin: height / 4,
          child: TrimTimeline(
            controller: _controller,
            padding: const EdgeInsets.only(top: 10),
          ),
        ),
      ),
    ];
  }

  void saveVideo() async {
    */
/* await _trimmer.saveTrimmedVideo(startValue: _startValue, endValue: _endValue, onSave: (path){
      double? aspectRatio =  _trimmer.videoPlayerController?.value.aspectRatio;
      LocalTrimmedVideoInfo localVideoInfo = LocalTrimmedVideoInfo(path, aspectRatio);
      NavigatorHandler.pop(localVideoInfo);

    });*//*


    */
/*if(execute.outputPath.isNotEmpty){
      LocalTrimmedVideoInfo localVideoInfo = LocalTrimmedVideoInfo(file.path, aspectRatio);
      NavigatorHandler.pop(localVideoInfo);
      print("outPut=>>${execute.outputPath}");

    }*//*


   */
/* if(await widget.file.exists()){
      print("Exist=>>>>>file found");
    }else{
      print("Exist=>>>>>file not found");

    }

    *//*


    String? path =  await VideoTrimmer.trimVideo(inputPath: widget.file.path, startTime: _controller.startTrim.inMilliseconds.toDouble(), endTime:  _controller.endTrim.inMilliseconds.toDouble() - _controller.startTrim.inMilliseconds.toDouble());
    if(path!=null){
      print('TrimmedVideopath=>>>${path}');
    }

  }

  @override
  void dispose() async {
    _exportingProgress.dispose();
    _isExporting.dispose();
    _controller.dispose();
    super.dispose();
  }
}
*/
