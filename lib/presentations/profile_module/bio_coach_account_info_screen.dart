import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/navigator/navigator.dart';
import 'package:gymatvendor/data/models/certificate_file_model.dart';
import 'package:gymatvendor/data/models/user_model.dart';
import 'package:gymatvendor/injection.dart';
import 'package:gymatvendor/presentations/auth_module/provider/auth_provider.dart';
import 'package:gymatvendor/presentations/auth_module/registration_info_screen/registration_info_screen.dart';
import 'package:gymatvendor/presentations/auth_module/registration_step2_screen/registration_step2_screen.dart';
import 'package:gymatvendor/presentations/auth_module/registration_step2_screen/widgets/image_certificate_widget.dart';
import 'package:gymatvendor/presentations/auth_module/registration_step2_screen/widgets/upload_file_widget.dart';
import 'package:gymatvendor/presentations/auth_module/work_with_screen/work_with_screen.dart';
import 'package:gymatvendor/presentations/profile_module/provider/profile_provider.dart';
import 'package:gymatvendor/presentations/profile_module/widgets/list_tile_complete_account_widget.dart';
import 'package:gymatvendor/presentations/widgets/custom_button/custom_button.dart';
import 'package:gymatvendor/presentations/widgets/custom_svg/CustomSvgIcon.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';
import 'package:gymatvendor/presentations/widgets/custom_text_form_area/custom_text_form_area.dart';
import 'package:gymatvendor/presentations/widgets/dialogs/scaffold_messanger.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors/app_colors.dart';
import '../../core/app_theme/theme.dart';
import '../widgets/custom_app_bar/custom_app_bar.dart';
import '../widgets/custom_text_form/custom_text_form.dart';

class BioCoachAccountInfoScreen extends StatefulWidget {
  const BioCoachAccountInfoScreen({super.key});

  @override
  State<BioCoachAccountInfoScreen> createState() =>
      _BioCoachAccountInfoScreenState();
}

class _BioCoachAccountInfoScreenState extends State<BioCoachAccountInfoScreen> {
  AuthProvider authProvider = getIt();

  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _certificateController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    authProvider.initCoachBio();
    ProfileProvider profileProvider = getIt();
    UserModel? userModel = profileProvider.getUserModel();
    if (userModel != null &&
        userModel.providerModel != null &&
        userModel.providerModel!.mainAccount != null) {
      _bioController.text = userModel.providerModel!.mainAccount!.desc ?? '';
      _experienceController.text = userModel.providerModel!.mainAccount!.experience??'';
      _educationController.text = userModel.providerModel!.mainAccount!.education??'';
      authProvider.coachBioCertificates = userModel.providerModel!.mainAccount!.certifications!=null&&userModel.providerModel!.mainAccount!.certifications!.isNotEmpty?userModel.providerModel!.mainAccount!.certifications!.split(','):[];

      for(IdentificationData data in userModel.providerModel!.mainAccount!.certificates){
        if(data.image!=null){
          String ext = data.image!.substring(data.image!.lastIndexOf('.')+1);
          authProvider.certificatesFile.add(CertificateFileModel(data.image??'', ext,data.id));
          print('exten=>>>$ext');
        }

      }


    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showToolBar: true,
        showBackArrow: true,
        elevation: 1,
        title: 'Account info'.tr(),
        isMainBack: true,
        bgColor: AppTheme.isDarkMode() ? dark : Colors.white,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 24,
                ),
                CustomText(
                  title: 'Bio'.tr(),
                  fontSize: 14,
                  fontColor:
                      AppTheme.isDarkMode() ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomTextFormFieldArea(
                  controller: _bioController,
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomText(
                  title: 'Education'.tr(),
                  fontSize: 14,
                  fontColor:
                      AppTheme.isDarkMode() ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomTextFormField(
                  controller: _educationController,
                  textInputType: TextInputType.text,
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomText(
                  title: 'Experience'.tr(),
                  fontSize: 14,
                  fontColor:
                      AppTheme.isDarkMode() ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomTextFormField(
                  controller: _experienceController,
                  textInputType: TextInputType.text,
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomText(
                  title: 'Certificates'.tr(),
                  fontSize: 14,
                  fontColor:
                      AppTheme.isDarkMode() ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomTextFormField(
                  controller: _certificateController,
                  textInputType: TextInputType.text,
                  suffix: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        String cert = _certificateController.text.trim();
                        if (cert.isNotEmpty) {

                          provider.addCertificate(cert);
                          _certificateController.clear();

                        }
                      },
                      icon: const Icon(
                        Icons.add,
                        color: mainColor,
                      )),
                ),
                const SizedBox(
                  height: 12,
                ),
                ListView.builder(
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                              color: mainColor,
                              borderRadius: BorderRadius.circular(2)),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                            child: CustomText(
                          title: provider.coachBioCertificates[index],
                          maxLines: 2,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontColor: AppTheme.isDarkMode()
                              ? Colors.white
                              : Colors.black,
                        )),
                        const SizedBox(width: 16,),

                        IconButton(onPressed: (){
                          provider.removeCertificate(index);
                        },padding: EdgeInsets.zero, icon:Icon(Icons.close,color: AppTheme.isDarkMode()?Colors.white:Colors.black,))
                      ],
                    );
                  },
                  itemCount: provider.coachBioCertificates.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                ),

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
                const SizedBox(height: 24,),



                CustomButton(title: 'Save'.tr(), onTap: (){
                  String bio = _bioController.text.trim();
                  String education = _educationController.text.trim();
                  String experience = _experienceController.text.trim();
                  if(bio.isNotEmpty&&education.isNotEmpty&&experience.isNotEmpty&&provider.coachBioCertificates.isNotEmpty){
                    provider.updateCoachBioData(bio,education,experience);
                  }else if(bio.isEmpty){
                    CustomScaffoldMessanger.showToast(title: 'Bio is required'.tr());

                  }else if(education.isEmpty){
                    CustomScaffoldMessanger.showToast(title: 'Education is required'.tr());

                  }else if(experience.isEmpty){
                    CustomScaffoldMessanger.showToast(title: 'Experience is required'.tr());

                  }else if(provider.coachBioCertificates.isEmpty){
                    CustomScaffoldMessanger.showToast(title: 'Certificates is required'.tr());

                  }
                },bg: mainColor,fontColor: Colors.white,fontSize: 15,),

                const SizedBox(height: 36,),

              ],
            ),
          );
        },
      ),
    );
  }


  void showPhotoSheet(String type) {
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _certificateController.dispose();
    _bioController.dispose();
    _educationController.dispose();
    _experienceController.dispose();
  }
}
