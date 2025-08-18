import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/data/models/ad_model.dart';
import 'package:gymatvendor/data/repositories/coach_workout_repository.dart';
import 'package:gymatvendor/injection.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import '../../../core/app_theme/theme.dart';
import '../../../core/navigator/navigator.dart';
import '../../../data/models/api_response.dart';
import '../../../data/models/local_workout_video_model.dart';
import '../../../data/models/workout_model.dart';
import '../../../main.dart';
import '../../widgets/dialogs/progress_dialog.dart';
import '../../widgets/dialogs/scaffold_messanger.dart';
import 'coach_home_provider.dart';

class WorkoutProvider with ChangeNotifier {
  CoachWorkoutRepository repository = getIt();
  String? workoutCoverPicture;
  List<LocalWorkoutVideoModel> workoutVideosPaths = [];
  String? videoPhoto;
  List<WorkoutModel> workouts = [];
  bool isLoading = false;

  int workoutPage = 1;

  void initWorkout() {
    getWorkouts();
  }

  void initAddWorkout(WorkoutModel? workoutModel) {
    workoutCoverPicture = null;
    workoutVideosPaths = [];
    if(workoutModel!=null){
      workoutCoverPicture = workoutModel.photo;
      for(WorkoutVideoModel workoutVideoModel in workoutModel.videos){
        VideoThumbnail videoThumbnail = VideoThumbnail(workoutVideoModel.video!, workoutVideoModel.image!);
        LocalWorkoutVideoModel model = LocalWorkoutVideoModel(workoutVideoModel.id,videoThumbnail, workoutVideoModel.name??'', workoutVideoModel.duration??'', workoutVideoModel.aspect_ratio);
        workoutVideosPaths.add(model);
      }
    }
  }

  void initAddVideo() {
    videoPhoto = null;
  }

  void pickImage(ImageSource source, String type) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? xFile = await imagePicker.pickImage(
        source: source, maxWidth: 512, maxHeight: 512, imageQuality: 50);
    if (xFile != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: xFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),


        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarWidgetColor: AppTheme.isDarkMode() ? Colors.white : Colors.black,
            toolbarColor: AppTheme.isDarkMode() ? Colors.black : Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
            ],
          ),
          IOSUiSettings(
            title: 'Cropper',
            aspectRatioLockEnabled: true,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
            ],
          ),
        ],
      );

      if (croppedFile != null) {
        if (type == 'workout') {
          workoutCoverPicture = 'fileimage:${croppedFile.path}';
          notifyListeners();
        } else {
          videoPhoto = 'fileimage:${croppedFile.path}';
          notifyListeners();
        }
      }
    }
  }

  void removeWorkoutCoverPicture() {
    workoutCoverPicture = null;
    notifyListeners();
  }

  void saveWorkoutVideoPath(LocalWorkoutVideoModel model) {
    print('videoPath=>>>>${model.videoThumbnail.videoImagePath}');
    int? index = getWorkoutVideoIndex(model.id);
    if(index!=null){

      workoutVideosPaths[index] = model;

    }else{
      workoutVideosPaths.add(model);

    }

    notifyListeners();
  }

  void removeWorkoutVideoItem(index) {
    LocalWorkoutVideoModel model = workoutVideosPaths[index];
    if(model.videoThumbnail.videoImagePath.startsWith('http')){
      int count = getOnlineWorkoutVideo();
      if(count>1){
        deleteWorkoutVideo(model.id!, index);
      }else{
        CustomScaffoldMessanger.showToast(title: 'Cannot delete this video. Workout should has at least 1 video'.tr());
      }
    }else{
      workoutVideosPaths.removeAt(index);
      notifyListeners();
    }

  }


  void getWorkouts() async {
    workouts.clear();
    isLoading = true;
    notifyListeners();
    try {
      ApiResponse response = await repository.getWorkouts(null,20);
      isLoading = false;

      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          response.response!.data['data'].forEach((v) => workouts.add(WorkoutModel.fromJson(v)));

          notifyListeners();

        }
      }else{
        if(response.error!=null){
          CustomScaffoldMessanger.showScaffoledMessanger(title: response.error);
        }
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      if (e is DioException) {
        if (e.response!.statusCode != 500) {
          CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
        }
      }
      print('coach workout error>>>${e.toString()}');
    }
  }

  void addWorkout(String workoutName, String duration, String description, String calories) async {
    ProgressDialog dialog = createProgressDialog(
        context: navigatorKey.currentContext!, msg: 'Adding...'.tr());
    await dialog.show();
    try {
      ApiResponse response = await repository.addWorkout(
          workoutName, workoutCoverPicture!, description, duration, calories,workoutVideosPaths);
      await dialog.hide();
      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          if (response.response!.data != null) {

            workoutCoverPicture = null;
            workoutVideosPaths.clear();
            if(response.response!.data['data']!=null){
              WorkoutModel workoutModel = WorkoutModel.fromJson(response.response!.data['data']);
              workouts.add(workoutModel);
              CoachHomeProvider coachHomeProvider = getIt();
              coachHomeProvider.addWorkout(workoutModel);
              notifyListeners();

            }
            NavigatorHandler.pop();

          }
        }
      } else {
        if (response.error != null) {
          CustomScaffoldMessanger.showScaffoledMessanger(title: response.error);
        }
      }
    } catch (e) {
      await dialog.hide();
      if (e is DioException) {
        if (e.response!.statusCode != 500) {
          CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
        }
      }
      notifyListeners();
      print('coach workout add error>>>${e.toString()}');
    }
  }

  void updateWorkout(num workoutId,String workoutName, String duration, String description, String calories,String fromPage) async {
    ProgressDialog dialog = createProgressDialog(
        context: navigatorKey.currentContext!, msg: 'Updating...'.tr());
    await dialog.show();
    try {
      ApiResponse response = await repository.updateWorkout(workoutId,
          workoutName, workoutCoverPicture!, description, duration, calories,workoutVideosPaths);
      await dialog.hide();
      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          if (response.response!.data != null) {
            workoutCoverPicture = null;
            workoutVideosPaths.clear();

            if(fromPage=='workout'){
              int? index = getWorkoutIndex(workoutId);
              if(index!=null&&response.response!.data['data'] != null){
                WorkoutModel workoutModel = WorkoutModel.fromJson(response.response!.data['data']);
                workouts[index] = workoutModel;


                CoachHomeProvider coachHomeProvider = getIt();
                coachHomeProvider.updateWorkout(workoutModel);
                notifyListeners();
              }
            }else{
              if(response.response!.data['data'] != null){
                WorkoutModel workoutModel = WorkoutModel.fromJson(response.response!.data['data']);
                CoachHomeProvider coachHomeProvider = getIt();
                coachHomeProvider.updateWorkout(workoutModel);
                notifyListeners();
              }
            }


            NavigatorHandler.pop();
          }
        }
      } else {
        if (response.error != null) {
          CustomScaffoldMessanger.showScaffoledMessanger(title: response.error);
        }
      }
    } catch (e) {
      await dialog.hide();
      if (e is DioException) {
        if (e.response!.statusCode != 500) {
          CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
        }
      }
      notifyListeners();
      print('coach workout update error>>>${e.toString()}');
    }
  }

  void deleteWorkout(WorkoutModel model) async {
    ProgressDialog dialog = createProgressDialog(
        context: navigatorKey.currentContext!, msg: 'Deleting...'.tr());
    await dialog.show();
    try {
      ApiResponse response =
      await repository.deleteWorkout(model.id.toString());
      await dialog.hide();
      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          workouts.remove(model);
          notifyListeners();
          CoachHomeProvider coachHomeProvider = getIt();
          coachHomeProvider.deleteWorkout(model);
        } else {
          notifyListeners();
          //CustomScaffoldMessanger.showScaffoledMessanger(title: response.innerMessage??'Something went wrong'.tr());
        }

      }else{
        if(response.error!=null){
          CustomScaffoldMessanger.showScaffoledMessanger(title: response.error);
        }

      }
    } catch (e) {
      await dialog.hide();
      if (e is DioException) {
        if (e.response!.statusCode != 500) {
          CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
        }
      }
      notifyListeners();
      print('coach delete workout error>>>${e.toString()}');
    }
  }

  void deleteWorkoutVideo(num videoId,int index) async {
    ProgressDialog dialog = createProgressDialog(
        context: navigatorKey.currentContext!, msg: 'Deleting...'.tr());
    await dialog.show();
    try {
      ApiResponse response = await repository.deleteWorkoutVideo(videoId);
      await dialog.hide();
      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          workoutVideosPaths.removeAt(index);
          notifyListeners();

        } else {
          notifyListeners();
          //CustomScaffoldMessanger.showScaffoledMessanger(title: response.innerMessage??'Something went wrong'.tr());
        }

      }else{
        if(response.error!=null){
          CustomScaffoldMessanger.showScaffoledMessanger(title: response.error);
        }

      }
    } catch (e) {
      await dialog.hide();
      if (e is DioException) {
        if (e.response!.statusCode != 500) {
          CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
        }
      }
      notifyListeners();
      print('coach delete workout error>>>${e.toString()}');
    }
  }

  void updateWorkoutVideo(num videoId,String videoTitle,String? videoPath,num aspectRatio,String duration ) async{
    ProgressDialog dialog = createProgressDialog(
        context: navigatorKey.currentContext!, msg: 'Updating...'.tr());
    await dialog.show();
    try {
      ApiResponse response = await repository.updateWorkoutVideo(videoId,videoTitle,duration,aspectRatio,videoPhoto,videoPath);
      await dialog.hide();
      if (response.response != null && response.response!.statusCode == 200) {
        if (response.code == 200) {
          WorkoutVideoModel workoutVideoModel = WorkoutVideoModel.fromJson(response.response!.data['data']);
          LocalWorkoutVideoModel model = LocalWorkoutVideoModel(
              workoutVideoModel.id,
              VideoThumbnail(videoPath!, workoutVideoModel.image!),
              workoutVideoModel.name!,
              workoutVideoModel.duration!,
              workoutVideoModel.aspect_ratio!);

          NavigatorHandler.pop(model);

        } else {
          notifyListeners();
          //CustomScaffoldMessanger.showScaffoledMessanger(title: response.innerMessage??'Something went wrong'.tr());
        }

      }else{
        if(response.error!=null){
          CustomScaffoldMessanger.showScaffoledMessanger(title: response.error);
        }

      }
    } catch (e) {
      await dialog.hide();
      if (e is DioException) {
        if (e.response!.statusCode != 500) {
          CustomScaffoldMessanger.showScaffoledMessanger(title: e.toString());
        }
      }
      notifyListeners();
      print('coach delete workout error>>>${e.toString()}');
    }
  }

  int? getWorkoutIndex(num workoutId){
    for(int index=0;index<workouts.length;index++){
      if(workouts[index].id==workoutId){
        return index;
      }
    }
    return null;
  }

  int getOnlineWorkoutVideo(){
    int count = 0;
    for(LocalWorkoutVideoModel model in workoutVideosPaths){
      if(model.videoThumbnail.videoImagePath.startsWith('http')){
        count++;
      }
    }
    return count;
  }

  int? getWorkoutVideoIndex(num? workoutVideoId){
    int index = 0;
    for(LocalWorkoutVideoModel model in workoutVideosPaths){
      if(model.id == workoutVideoId){

        print('videoIds=>>>>${model.id}=====$workoutVideoId');

        return index;
      }
      index++;
    }
    return null;
  }

}
