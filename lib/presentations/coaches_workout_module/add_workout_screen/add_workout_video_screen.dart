import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:gymatvendor/data/models/local_workout_video_model.dart';
import 'package:gymatvendor/presentations/widgets/custom_button/custom_button.dart';
import 'package:gymatvendor/presentations/widgets/dialogs/scaffold_messanger.dart';
import 'package:gymatvendor/presentations/widgets/loading_indicator/loading_indicator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../../core/navigator/navigator.dart';
import '../../../injection.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';
import '../../widgets/custom_svg/CustomSvgIcon.dart';
import '../../widgets/custom_text/custom_text.dart';
import '../../widgets/custom_text_form/custom_text_form.dart';
import '../provider/workout_provider.dart';
import 'widgets/add_workout_videoPlayer.dart';
import 'widgets/upload_workout_image.dart';

class AddWorkoutVideoScreen extends StatefulWidget {
  final LocalWorkoutVideoModel? localWorkoutVideoModel;

  const AddWorkoutVideoScreen({super.key, this.localWorkoutVideoModel});

  @override
  State<AddWorkoutVideoScreen> createState() => _AddWorkoutVideoScreenState();
}

class _AddWorkoutVideoScreenState extends State<AddWorkoutVideoScreen> {
  late VideoPlayerController playerController;
  final WorkoutProvider workoutProvider = getIt();
  final TextEditingController _exerciseController = TextEditingController();
  String? videoPath;
  num? videoAspectRatio;
  String? duration;
  bool isPrepared = false;

  //String? videoImagePath; not used user upload image

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    workoutProvider.initAddVideo();
    if (widget.localWorkoutVideoModel != null) {
      _exerciseController.text =
          widget.localWorkoutVideoModel!.videoTitle ?? '';
      videoPath = widget.localWorkoutVideoModel!.videoThumbnail.videoPath;
      videoAspectRatio = widget.localWorkoutVideoModel!.aspectRatio;
      duration = widget.localWorkoutVideoModel!.duration;
      workoutProvider.videoPhoto =
          widget.localWorkoutVideoModel!.videoThumbnail.videoImagePath;
      if (videoPath != null) {
        initPlayer(videoPath!);
      }
    }
  }

  initPlayer(String path) async {
    if (path.startsWith('http')) {
      playerController = VideoPlayerController.networkUrl(Uri.parse(path));
    } else {
      playerController = VideoPlayerController.file(File(path));
    }

    playerController.addListener(() {});

    playerController.initialize().then((value) async {
      int minutes = (playerController.value.duration.inSeconds%3600) ~/60;
      int seconds = playerController.value.duration.inSeconds % 60;
      duration = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2,'0')}';
      isPrepared = true;
      videoAspectRatio = playerController.value.aspectRatio;

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showToolBar: true,
        showBackArrow: true,
        title: 'Workouts'.tr(),
        elevation: 1,
        isMainBack: true,
        bgColor: AppTheme.isDarkMode() ? dark : Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    CustomText(
                      title: 'Exercise name'.tr(),
                      fontColor:
                          AppTheme.isDarkMode() ? Colors.white : Colors.black,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    CustomTextFormField(controller: _exerciseController),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomText(
                      title: 'Add video picture cover'.tr(),
                      fontSize: 14,
                      fontColor: greyColor,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Consumer<WorkoutProvider>(builder: (context, provider, _) {
                      return UploadWorkoutImage(
                        url: provider.videoPhoto,
                        onDeleteTap: () {
                          provider.removeWorkoutCoverPicture();
                        },
                        onTap: () {
                          showPhotoSheet();
                        },
                      );
                    }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          title: 'Add workout video'.tr(),
                          fontColor: AppTheme.isDarkMode()
                              ? Colors.white
                              : Colors.black,
                        ),
                        IconButton(
                            onPressed: () async {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles(
                                      allowCompression: false,
                                      type: FileType.video);
                              if (result != null) {
                                final tempDir = await getTemporaryDirectory();
                                final newFile = File('${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.${result.files.single.extension??'mp4'}');
                                File orignalFile = File(result.files.single.path!);
                                orignalFile.copy(newFile.path);

                                FlutterVideoInfo info = FlutterVideoInfo();
                                VideoData? vData = await info.getVideoInfo(orignalFile.path);
                                if(vData!=null){
                                  Duration d = Duration(milliseconds: vData.duration!.toInt());
                                  int seconds = d.inSeconds;
                                  if(seconds<61){
                                    videoPath = orignalFile.path;
                                    setState(() {});
                                    initPlayer(videoPath!);
                                  }else{
                                    CustomScaffoldMessanger.showToast(title: 'The video duration is more than 60 seconds.');
                                  }
                                }
                                /*;*/

                               /* LocalTrimmedVideoInfo? trimmedVideo = await NavigatorHandler.push(TrimmerViewScreen(file: newFile,));

                                if (trimmedVideo != null) {
                                  videoPath = trimmedVideo.path;
                                  videoAspectRatio = trimmedVideo.aspectRatio;

                                  print('videoPath=>>>${videoPath}');
                                  File file = File(videoPath!);
                                  if(await file.exists()){
                                    print("file exist");
                                  }else{
                                    print("file not found");
                                  }

                                }*/


                              }
                            },
                            icon: Icon(
                              Icons.add,
                              color: AppTheme.isDarkMode()
                                  ? Colors.white
                                  : Colors.black,
                            ))
                      ],
                    ),
                    buildVideoView()
                  ],
                ),
              ),
            ),
            CustomButton(
                title: 'Save'.tr(),
                onTap: () {
                  String videoTitle = _exerciseController.text.trim();
                  if (videoTitle.isNotEmpty &&
                      videoPath != null &&
                      workoutProvider.videoPhoto != null &&
                      duration != null) {

                    if(widget.localWorkoutVideoModel!=null){
                      if(widget.localWorkoutVideoModel?.id!=null){
                        workoutProvider.updateWorkoutVideo(widget.localWorkoutVideoModel!.id!, videoTitle, videoPath,videoAspectRatio!, duration!);

                      }else{
                        LocalWorkoutVideoModel model = LocalWorkoutVideoModel(
                            widget.localWorkoutVideoModel?.id,
                            VideoThumbnail(videoPath!, workoutProvider.videoPhoto!),
                            videoTitle,
                            duration!,
                            videoAspectRatio);
                        NavigatorHandler.pop(model);
                      }
                    }else{
                      LocalWorkoutVideoModel model = LocalWorkoutVideoModel(
                          widget.localWorkoutVideoModel?.id,
                          VideoThumbnail(videoPath!, workoutProvider.videoPhoto!),
                          videoTitle,
                          duration!,
                          videoAspectRatio);
                      NavigatorHandler.pop(model);
                    }

                  } else if (videoTitle.isEmpty) {
                    CustomScaffoldMessanger.showToast(
                        title: 'Exercise title is required'.tr());
                  } else if (videoPath == null) {
                    CustomScaffoldMessanger.showToast(
                        title: 'Choose video'.tr());
                  } else if (workoutProvider.videoPhoto == null) {
                    CustomScaffoldMessanger.showToast(
                        title: 'Video cover is required'.tr());
                  }
                }),
            const SizedBox(
              height: 24,
            )
          ],
        ),
      ),
    );
  }

  void showPhotoSheet() {
    showModalBottomSheet(
        context: context,
        backgroundColor: AppTheme.isDarkMode() ? sheetBg : Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: 24,
                    ),
                    CustomText(
                      title: 'Choose photo'.tr(),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontColor:
                          AppTheme.isDarkMode() ? Colors.white : Colors.black,
                    ),
                    IconButton(
                        onPressed: () {
                          NavigatorHandler.pop();
                        },
                        icon: Icon(
                          Icons.close,
                          color: AppTheme.isDarkMode()
                              ? Colors.white
                              : Colors.black,
                        ))
                  ],
                ),
              ),
              Divider(
                color: AppTheme.isDarkMode()
                    ? Colors.white.withOpacity(.05)
                    : greyColor.withOpacity(.1),
                height: 1,
              ),
              const SizedBox(
                height: 36,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      NavigatorHandler.pop();
                      workoutProvider.pickImage(ImageSource.camera, 'video');
                    },
                    child: Column(
                      children: [
                        CustomSvgIcon(
                          assetName: 'camera',
                          color: AppTheme.isDarkMode()
                              ? Colors.white
                              : Colors.black,
                          width: 18,
                          height: 18,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        CustomText(
                          title: 'Camera'.tr(),
                          fontColor: AppTheme.isDarkMode()
                              ? Colors.white
                              : Colors.black,
                          fontSize: 16,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 48,
                  ),
                  InkWell(
                    onTap: () {
                      NavigatorHandler.pop();
                      workoutProvider.pickImage(ImageSource.gallery, 'video');
                    },
                    child: Column(
                      children: [
                        CustomSvgIcon(
                          assetName: 'gallery',
                          color: AppTheme.isDarkMode()
                              ? Colors.white
                              : Colors.black,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        CustomText(
                          title: 'Gallery'.tr(),
                          fontColor: AppTheme.isDarkMode()
                              ? Colors.white
                              : Colors.black,
                          fontSize: 16,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 36,
              ),
            ],
          );
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    playerController.dispose();
  }

  Widget buildVideoView() {
    if (videoPath == null) {
      return const SizedBox();
    } else if (isPrepared) {
      return AddWorkoutVideoPlayer(
        videoPath: videoPath!,
        aspectRatio: videoAspectRatio,
        onVideoLoaded: (duration, videoImagePath) {
          this.duration = duration;
          //this.videoImagePath = videoImagePath;
        },
        playerController: playerController,
      );
    } else {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24.0),
        child: LoadingIndicator(
          width: 24,
          stroke: 3,
        ),
      );
    }
  }
}
