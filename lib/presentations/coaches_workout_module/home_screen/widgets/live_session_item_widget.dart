import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/core/number_format/numberFormat.dart';
import 'package:gymatvendor/data/models/liveSessionModel.dart';
import 'package:gymatvendor/presentations/widgets/custom_bordered_container/custom_bordered_container.dart';
import 'package:gymatvendor/presentations/widgets/custom_button/custom_button.dart';
import 'package:gymatvendor/presentations/widgets/custom_rounded_image/custom_rounded_image.dart';
import 'package:gymatvendor/presentations/widgets/custom_svg/CustomSvgIcon.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';
import 'package:gymatvendor/presentations/widgets/dialogs/scaffold_messanger.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/navigator/navigator.dart';
import '../../../../injection.dart';
import '../../../widgets/dialogs/dialogMicorphonePermission.dart';
import '../../livesession_screen/camera_preview_livesession.dart';
import '../../provider/livesession_provider.dart';

class LiveSessionItemWidget extends StatelessWidget {
  final LiveSessionModel model;
  const LiveSessionItemWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1 / .82,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        surfaceTintColor: Colors.transparent,
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        color: Theme.of(context).cardColor,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                   AspectRatio(
                    aspectRatio: 16 / 7.5,
                    child: CustomRoundedImage(
                      width: 300,
                      height: 140,
                      url: model.photo,
                      radius: 16,
                    ),
                  ),
                  model.status == LiveSessionStatus.NEW.name.toLowerCase() || model.status == LiveSessionStatus.LIVE.name.toLowerCase()? Positioned(
                      bottom: 8,
                      left: 24,
                      right: 24,
                      child: CustomButton(
                        title: 'Start now'.tr(),
                        onTap: () {
                          if(canStartNow()){

                            _checkPermissionsStatus();
                          }

                        },
                        radius: 12,
                        height: 34,
                      )):const SizedBox()
                ],
              ),
              const SizedBox(height: 4,),

              CustomText(
                title: model.getTitle(),
                fontSize: 15,
                fontColor: AppTheme.isDarkMode() ? Colors.white : Colors.black,
                maxLines: 1,
              ),
              const SizedBox(height: 4,),

              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: AppTheme.isDarkMode() ? inputBgDark : inputBg,
                        borderRadius: BorderRadius.circular(12)),
                    child: const CustomSvgIcon(
                      assetName: 'on_air',
                      width: 18,
                      height: 18,
                    ),
                  ),
                  const SizedBox(width: 6,),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    CustomText(title: 'Aired on'.tr(),fontColor: greyColor,),
                      const SizedBox(height: 4,),
                      CustomText(title: '${model.date??''} ${model.from_time??''}',fontColor:AppTheme.isDarkMode()?Colors.white:Colors.black,fontSize: 11,)

                    ],)),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomText(
                        title: 'Regesters'.tr(),
                        fontColor:
                            AppTheme.isDarkMode() ? Colors.white : Colors.black,
                        fontSize: 9,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Container(
                        width: 48,
                        height: 36,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: mainColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child:  CustomText(
                          title: CustomNumberFormat.getPeopleCountFormat(model.people_registered??0),
                          fontColor: Colors.white,
                          fontSize: 12,
                          maxLines: 1,
                        ),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }


  bool canStartNow(){
    try {
      if (model.date != null && model.from_time != null && model.to_time != null) {
        DateTime dateNow = DateTime.now();
        DateTime now = DateTime(dateNow.year,dateNow.month,dateNow.day,dateNow.hour,dateNow.minute,0,0,0);

        DateTime fromDateTime = DateFormat('yyyy-MM-dd hh:mm a', 'en').parse('${model.date!} ${model.from_time!}');
        DateTime toDateTime = DateFormat('yyyy-MM-dd hh:mm a', 'en').parse('${model.date!} ${model.to_time!}');

        int diff = now.millisecondsSinceEpoch-fromDateTime.millisecondsSinceEpoch;


        if(diff<0){
          int min = (diff*-1) ~/ 60000;
          if(min<11){
            return true;
          }else{
            CustomScaffoldMessanger.showToast(title: 'Sorry!,You cannot start live session now. please check live session date'.tr());
            return false;
          }


        }else if(diff>0){
          int diff2 = now.millisecondsSinceEpoch-toDateTime.millisecondsSinceEpoch;
          if(diff2<0){
            return true;
          }else{
            CustomScaffoldMessanger.showToast(title: 'Sorry!,You cannot start live session now. please check live session date'.tr());
            return false;
          }
        }else if (diff ==0){
          return true;
        }
      }
    }catch (e){

    }
    return false;

  }

  Future<void> _checkPermissionsStatus() async {

    var cameraStatus = await Permission.camera.status;
    var microphoneStatus = await Permission.microphone.status;

    if(cameraStatus.isGranted&&microphoneStatus.isGranted){
      NavigatorHandler.push(CameraPreviewLiveSession(liveSessionId: model.id!,));

    }
    else if(cameraStatus.isDenied||microphoneStatus.isDenied){
      Map<Permission, PermissionStatus> permissions = await [Permission.camera, Permission.microphone].request();

      if (permissions[Permission.camera] == PermissionStatus.granted&& permissions[Permission.microphone] == PermissionStatus.granted) {
        NavigatorHandler.push(CameraPreviewLiveSession(liveSessionId: model.id!,));

      }else if(permissions[Permission.camera]== PermissionStatus.denied||permissions[Permission.microphone] == PermissionStatus.denied){
        _checkPermissionsStatus();
      }else if(permissions[Permission.camera]== PermissionStatus.permanentlyDenied||permissions[Permission.microphone] == PermissionStatus.permanentlyDenied){
        openDialogPermission();
      }
    }

    else if(cameraStatus.isPermanentlyDenied || microphoneStatus.isPermanentlyDenied){
      openDialogPermission();
    }




  }

  void openDialogPermission() {
    MicroPhoneDialog.showMicrophoneDialogPermission(() async{

      var cameraStatus = await Permission.camera.status;
      var microphoneStatus = await Permission.microphone.status;
      bool status = cameraStatus.isGranted&&microphoneStatus.isGranted;
      if(status){
        await NavigatorHandler.pop();
        await Future.delayed(const Duration(milliseconds: 200));
        NavigatorHandler.push(CameraPreviewLiveSession(liveSessionId: model.id!,));

      }else{
        await openAppSettings();
      }

    }, () async{
      await NavigatorHandler.pop();

    });
  }

}
