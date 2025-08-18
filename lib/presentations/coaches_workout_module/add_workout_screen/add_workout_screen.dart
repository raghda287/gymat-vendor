import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/dimens/dimens.dart';
import 'package:gymatvendor/data/models/workout_model.dart';
import 'package:gymatvendor/injection.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/add_workout_screen/add_workout_video_screen.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/add_workout_screen/widgets/add_workout_videoPlayer.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/add_workout_screen/widgets/workout_video_item.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';
import 'package:gymatvendor/presentations/widgets/custom_text_form/custom_text_form.dart';
import 'package:gymatvendor/presentations/widgets/custom_text_form_area/custom_text_form_area.dart';
import 'package:gymatvendor/presentations/widgets/dialogs/scaffold_messanger.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../../core/navigator/navigator.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';
import '../../widgets/custom_button/custom_button.dart';
import '../../widgets/custom_svg/CustomSvgIcon.dart';
import '../provider/workout_provider.dart';
import 'video_trimmer_screen.dart';
import 'widgets/upload_workout_image.dart';

class AddWorkoutScreen extends StatefulWidget {
  final WorkoutModel? workoutModel;
  final String fromPage;
  const AddWorkoutScreen({super.key, this.workoutModel, required this.fromPage});

  @override
  State<AddWorkoutScreen> createState() => _AddWorkoutScreenState();
}

class _AddWorkoutScreenState extends State<AddWorkoutScreen> {
  WorkoutProvider workoutProvider = getIt();

  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _minuteController = TextEditingController();
  final TextEditingController _burnController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    workoutProvider.initAddWorkout(widget.workoutModel);
    if(widget.workoutModel!=null){
      _topicController.text = widget.workoutModel!.title??'';
      _minuteController.text = widget.workoutModel!.duration.toString()??'';
      _burnController.text = widget.workoutModel!.calories.toString()??'';
      _descriptionController.text = widget.workoutModel!.text??'';

    }
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
      body: Consumer<WorkoutProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 12,
                ),
                CustomText(
                  title: 'Workout topic'.tr(),
                  fontSize: 14,
                  fontColor: mainColor,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(
                  height: 8,
                ),
                CustomTextFormField(controller: _topicController),
                const SizedBox(
                  height: 12,
                ),
                CustomText(
                  title: 'Add workout picture cover'.tr(),
                  fontSize: 14,
                  fontColor: greyColor,
                ),
                const SizedBox(
                  height: 12,
                ),
                Consumer<WorkoutProvider>(builder: (context, provider, _) {
                  return UploadWorkoutImage(

                    url: provider.workoutCoverPicture,
                    onDeleteTap: () {
                      provider.removeWorkoutCoverPicture();
                    },
                    onTap: () {
                      showPhotoSheet();
                    },
                  );
                }),
                const SizedBox(
                  height: 12,
                ),
                CustomText(
                  title: 'Workout duration'.tr(),
                  fontSize: 14,
                  fontColor: greyColor,
                ),
                const SizedBox(
                  height: 8,
                ),
                CustomTextFormField(
                  controller: _minuteController,
                  textInputType: const TextInputType.numberWithOptions(
                      signed: false, decimal: false),
                  maxLength: 3,
                  suffix: CustomText(
                    title: 'Minute'.tr(),
                    fontWeight: FontWeight.bold,
                    fontColor:
                        AppTheme.isDarkMode() ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomText(
                  title: 'Burn'.tr(),
                  fontSize: 14,
                  fontColor: greyColor,
                ),
                const SizedBox(
                  height: 8,
                ),
                CustomTextFormField(
                  controller: _burnController,
                  textInputType: const TextInputType.numberWithOptions(
                      signed: false, decimal: true),
                  maxLength: 5,
                  suffix: CustomText(
                      title: 'Calories'.tr(),
                      fontWeight: FontWeight.bold,
                      fontColor:
                          AppTheme.isDarkMode() ? Colors.white : Colors.black),
                  minPrefixSuffixWidth: 80,
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomText(
                  title: 'Description'.tr(),
                  fontSize: 14,
                  fontColor: greyColor,
                ),
                const SizedBox(
                  height: 8,
                ),
                CustomTextFormFieldArea(
                  controller: _descriptionController,
                  height: 168,
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomText(
                  title: 'Workouts'.tr(),
                  fontSize: 14,
                  fontColor: greyColor,
                ),

                const SizedBox(
                  height: 8,
                ),

                Consumer<WorkoutProvider>(builder: (context,provider,_){
                  return ListView.builder(
                    shrinkWrap: true,
                      itemCount:provider.workoutVideosPaths.length ,
                      itemBuilder: (context,index){
                        return WorkoutVideoItem(model: provider.workoutVideosPaths[index], index: index, onDismissed: (index) async{
                          await Future.delayed(const Duration(milliseconds: 300));
                          provider.removeWorkoutVideoItem(index);
                        }, onDelete: (index){
                          provider.removeWorkoutVideoItem(index);
                        }, onTap: () async{
                          dynamic videoModel = await NavigatorHandler.push(AddWorkoutVideoScreen(localWorkoutVideoModel:provider.workoutVideosPaths[index] ,));
                          if(videoModel!=null){
                            workoutProvider.saveWorkoutVideoPath(videoModel);
                          }
                        },);
                      });

                }),

                if(provider.workoutVideosPaths.isNotEmpty)const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                        highlightColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () async{
                          dynamic videoModel = await NavigatorHandler.push(const AddWorkoutVideoScreen());
                          if(videoModel!=null){
                            workoutProvider.saveWorkoutVideoPath(videoModel);
                          }

                        },
                        child: CustomText(
                          title: 'Add more exercise'.tr(),
                          fontSize: 14,
                          fontColor: mainColor,
                        )),
                  ],
                ),
                const SizedBox(height: 24,),
                CustomButton(title: 'Save'.tr(), onTap: (){
                  String topic = _topicController.text.trim();
                  String duration = _minuteController.text.trim();
                  String burn = _burnController.text.trim();
                  String description = _descriptionController.text.trim();

                  if(topic.isNotEmpty&&workoutProvider.workoutCoverPicture!=null&&duration.isNotEmpty&&burn.isNotEmpty&&description.isNotEmpty&&workoutProvider.workoutVideosPaths.isNotEmpty){
                    if(widget.workoutModel==null){
                      workoutProvider.addWorkout(topic, duration, description, burn);
                    }else{
                      workoutProvider.updateWorkout(widget.workoutModel!.id!,topic, duration, description, burn,widget.fromPage);

                    }
                  }else if(topic.isEmpty){
                    CustomScaffoldMessanger.showToast(title: 'Workout topic is required'.tr());

                  }else if(workoutProvider.workoutCoverPicture==null){
                    CustomScaffoldMessanger.showToast(title: 'Workout cover picture is required'.tr());

                  }else if(duration.isEmpty){
                    CustomScaffoldMessanger.showToast(title: 'Workout duration is required'.tr());

                  }else if(burn.isEmpty){
                    CustomScaffoldMessanger.showToast(title: 'Calories is required'.tr());

                  }else if(description.isEmpty){
                    CustomScaffoldMessanger.showToast(title: 'Description is required'.tr());

                  }else if(workoutProvider.workoutVideosPaths.isEmpty){
                    CustomScaffoldMessanger.showToast(title: 'Add at least 1 workout video'.tr());

                  }
                }),
                const SizedBox(height: 24,)


              ],
            ),
          );
        },
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
                    onTap: () async {
                      PermissionStatus status = await Permission.camera.status;
                      if(status.isDenied){
                        PermissionStatus st = await _requestCameraPermission();
                        if(st.isDenied){
                          CustomScaffoldMessanger.showToast(title: 'Access camera denied'.tr());
                          return;
                        }else if(st.isPermanentlyDenied){
                          openAppSettings();
                          return;
                        }
                      }else if(status.isPermanentlyDenied){
                        openAppSettings();
                        return;
                      }

                      NavigatorHandler.pop();
                      workoutProvider.pickImage(ImageSource.camera,'workout');
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
                      workoutProvider.pickImage(ImageSource.gallery,'workout');
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
                  )
                ],
              ),
              const SizedBox(
                height: 36,
              ),
            ],
          );
        });
  }

  Future<PermissionStatus> _requestCameraPermission() async {
    return Permission.camera.request();
  }

}
