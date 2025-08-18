import 'dart:async';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/navigator/navigator.dart';
import 'package:gymatvendor/core/text_styles/text_styles.dart';
import 'package:gymatvendor/presentations/widgets/custom_button/custom_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../../injection.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';
import '../../widgets/dialogs/dialogMicorphonePermission.dart';
import '../provider/livesession_provider.dart';
import 'dart:math' as math;
enum CameraType{
  front,
  back
}
class CameraPreviewLiveSession extends StatefulWidget {
  final num liveSessionId;
  const CameraPreviewLiveSession({super.key, required this.liveSessionId});

  @override
  State<CameraPreviewLiveSession> createState() =>
      _CameraPreviewLiveSessionState();
}

class _CameraPreviewLiveSessionState extends State<CameraPreviewLiveSession>
    with WidgetsBindingObserver {
  CameraController? controller;
  final List<CameraDescription> _cameras = [];
  CameraDescription? cameraDescription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      WakelockPlus.toggle(enable: true);
    });
    initCamera();

  }


  void initCamera() async {


    _cameras.clear();
    List<CameraDescription> cams = await availableCameras();
    _cameras.addAll(cams.toSet().toList());


    if (_cameras.isNotEmpty) {
      cameraDescription = _cameras[0];
      await _initializeCameraController(cameraDescription!);
      //initPlugin();

    }



  }



  Future<void> _initializeCameraController(
      CameraDescription cameraDescription) async {
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.max,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    controller = cameraController;

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (cameraController.value.hasError) {
        print('CameraError->>>${cameraController.value.errorDescription}');
      }
    });

    await cameraController.initialize();
  }

  void initPlugin() async {
   /* Future.wait([_player.initialize(),_recorder.initialize()]);
    _audioStream = _recorder.audioStream.listen((data) {
      if(!isRecording){
        isRecording = true;
      }
      _player.writeChunk(data); // Write the mic data to the player
    });
    Future.wait([_player.start(), _recorder.start()]);

    if (_micChunks.isNotEmpty) {
      for (var chunk in _micChunks) {
        await _player.writeChunk(chunk);
      }
      _micChunks.clear();
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _cameras.length,
      child: Scaffold(
        backgroundColor: Colors.black,
        body:  Stack(children: [
          controller != null && controller!.value.isInitialized ? Positioned.fill(child:
          FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: controller!.value.previewSize!.height,
              height: controller!.value.previewSize!.width,
              child: Transform(transform: Matrix4.rotationY(
                controller!.description.lensDirection == CameraLensDirection.front ? math.pi : 0,
              ),alignment: Alignment.center,child: CameraPreview(controller!),),
            ),
          )


          ):
          const SizedBox(),
          const CustomAppBar(
                  showToolBar: true,
                  showBackArrow: true,
                  elevation: 0,
                  isMainBack: true,
                  fontColor: Colors.white,
                  bgColor: Colors.transparent,
                ),
          controller != null && controller!.value.isInitialized ? Positioned(
                    left: 0,
                    right: 0,
                    bottom: 16,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                          ),
                          child: CustomButton(
                              title: 'Start live session2'.tr(),
                              height: 48,
                              fontSize: 15,
                              fontColor: Colors.white,
                              onTap: () async {

                                LiveSessionProvider provider= getIt();
                                provider.startLiveSession(widget.liveSessionId,cameraDescription!=null?cameraDescription!.lensDirection.name:CameraType.front.name);
                              }),
                        ),
                        TabBar(
                            dividerHeight: 0,
                            indicatorColor: Colors.transparent,
                            isScrollable: true,
                            indicatorWeight: 0.01,
                            tabAlignment: TabAlignment.center,
                            padding: EdgeInsets.zero,
                            labelColor: Colors.white,
                            labelStyle: AppTextStyles().normalText(),
                            unselectedLabelColor: Colors.white.withOpacity(.7),
                            unselectedLabelStyle: AppTextStyles().normalText(),
                            onTap: (index) {
                              onNewCameraSelected(_cameras[index]);
                            },
                            tabs: _cameras
                                .map((e) => Tab(
                                      text: e.lensDirection ==
                                              CameraLensDirection.front
                                          ? 'Front camera'.tr()
                                          : e.lensDirection ==
                                                  CameraLensDirection.back
                                              ? 'Back camera'.tr()
                                              : '',
                                    ))
                                .toList())
                      ],
                    )):
          const SizedBox(),
        ])

      ),
    );
  }



  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    if(this.cameraDescription?.name == cameraDescription.name){
      return;
    }
    this.cameraDescription = cameraDescription;

    if (controller != null) {

      return controller!.setDescription(cameraDescription);
    } else {
      return _initializeCameraController(cameraDescription);
    }
  }




  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      initCamera();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller?.dispose();
    WakelockPlus.toggle(enable: false);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


}
