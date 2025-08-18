import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/presentations/auth_module/registration_step2_screen/widgets/image_certificate_widget.dart';
import 'package:gymatvendor/presentations/auth_module/registration_step2_screen/widgets/upload_file_widget.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';
import 'package:gymatvendor/presentations/widgets/custom_text_form/custom_text_form.dart';
import 'package:gymatvendor/presentations/widgets/dialogs/scaffold_messanger.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/navigator/navigator.dart';
import '../../../injection.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';
import '../../widgets/custom_button/custom_button.dart';
import '../../widgets/custom_svg/CustomSvgIcon.dart';
import '../provider/auth_provider.dart';

class RegistrationStep2Screen extends StatefulWidget {
  const RegistrationStep2Screen({super.key});

  @override
  State<RegistrationStep2Screen> createState() => _RegistrationStep2ScreenState();
}

class _RegistrationStep2ScreenState extends State<RegistrationStep2Screen> {
  AuthProvider authProvider = getIt();
  FocusNode node = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authProvider.initSignUpStep2();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        showToolBar: true,
        showBackArrow: true,
        isMainBack: true,
        title: 'Sign up info'.tr(),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12,),
                      CustomText(title: 'Id number'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:greyColor,),
                      const SizedBox(height: 12,),
                      CustomTextFormField(controller: provider.idNumberController,maxLength: 10,textInputType: TextInputType.number,focusNode:node,),
                      const SizedBox(height: 12,),
                      CustomText(title: 'ID'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:greyColor,),
                      const SizedBox(height: 12,),
                      UploadFileWidget(filePath: provider.idPhotoPath, onTap: () {
                        showPhotoSheet('id');
                      },),

                      const SizedBox(height: 12,),
                      CustomText(title: 'Passport'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:greyColor,),
                      const SizedBox(height: 12,),
                      UploadFileWidget(filePath: provider.passportPhotoPath, onTap: () {
                        showPhotoSheet('passport');

                      },),

                      const SizedBox(height: 12,),
                      CustomText(title: 'Commercial registration'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:greyColor,),
                      const SizedBox(height: 12,),
                      UploadFileWidget(filePath: provider.commercialRegistrationPhotoPath, onTap: () {
                        showPhotoSheet('commercialRegistration');

                      },),

                      const SizedBox(height: 12,),
                      CustomText(title: 'Certificates'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:greyColor,),
                      const SizedBox(height: 12,),

                      UploadFileWidget(filePath:null, onTap: () {
                        if(provider.certificatesFile.length<5){
                          showPhotoSheet('certificate');

                        }else{
                          CustomScaffoldMessanger.showToast(title: 'Maximum 5 files'.tr());
                        }

                      },),

                      const SizedBox(height: 24,),

                      SizedBox(
                        height: 64,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: provider.certificatesFile.length,
                            itemBuilder: (context,index){
                              return ImageCertificateWidget(model: provider.certificatesFile[index],index: index,onDelete: (index){
                                provider.deleteCertificatesFiles(index);
                              },);
                            }),
                      ),



                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                child: CustomButton(title: 'Confirm'.tr(), onTap: (){
                  provider.checkCertificatesFiles();

                }),
              )

            ],
          );
        },
      ),
    );

  }



  void showPhotoSheet(String type) {
    node.unfocus();
    showModalBottomSheet(
        context: context,
        elevation: 5,
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
                      authProvider.pickImage(ImageSource.camera, type,null);
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
                      authProvider.pickImage(ImageSource.gallery, type,null);
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
                  const SizedBox(
                    width: 48,
                  ),

                 InkWell(
                    onTap: () {
                      NavigatorHandler.pop();
                      authProvider.pickUpFile(type);
                    },
                    child: Column(
                      children: [
                        CustomSvgIcon(
                          assetName: 'pdf',
                          color: AppTheme.isDarkMode()
                              ? Colors.white
                              : Colors.black,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        CustomText(
                          title: 'pdf'.tr(),
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

  Future<PermissionStatus> _requestCameraPermission() async {
    return Permission.camera.request();
  }

}
