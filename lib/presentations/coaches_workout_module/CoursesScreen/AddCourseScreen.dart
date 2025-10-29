import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/dimens/dimens.dart';
import 'package:gymatvendor/injection.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/provider/coach_services_provider.dart';
import 'package:gymatvendor/presentations/widgets/custom_button/custom_button.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';
import 'package:gymatvendor/presentations/widgets/custom_text_form/custom_text_form.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';

class AddCourseScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddCourseScreenState();
  }
}

class AddCourseScreenState extends State<AddCourseScreen> {
  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    super.dispose();
    CoachServicesProvider provider = getIt();
    provider.courseTitleController.text = "";
    provider.descriptionController.text = "";
    provider.priceController.text="";
    provider.uploadCourseImage = null;
    provider.isCourseFree = false;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showToolBar: true,
        showBackArrow: true,
        title: 'courses'.tr(),
        elevation: 1,
        isMainBack: true,
        bgColor: AppTheme.isDarkMode() ? dark : Colors.white,
      ),
      body: Consumer<CoachServicesProvider>(
        builder: (context, provider, _) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
            child: SingleChildScrollView(
              child: Center(child: Form(
                key: formKey,
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      title: "Course Title".tr(),
                      fontSize: 14,
                      fontColor: greyColor,
                    ),
                    CustomTextFormField(
                      controller: provider.courseTitleController,
                    ),
                    CustomText(
                      title: "Description".tr(),
                      fontSize: 14,
                      fontColor: greyColor,
                    ),
                    CustomTextFormField(
                      controller: provider.descriptionController,
                    ),
                    provider.isCourseFree
                    ?Container()
                    :CustomText(
                      title: "Price".tr(),
                      fontSize: 14,
                      fontColor: greyColor,
                    ),
                    provider.isCourseFree
                    ?Container()
                    :CustomTextFormField(
                      controller: provider.priceController,
                    ),
                    CustomText(
                      title: "+Add photo".tr(),
                      fontSize: 14,
                      fontColor: greyColor,
                    ),
                    InkWell(
                      child: Container(
                        width: Dimens.width*0.5,
                        height: Dimens.height*0.15,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: AppTheme.isDarkMode()?inputBgDark:inputBg
                        ),
                        child: provider.uploadCourseImage!=null?Image.file(provider.uploadCourseImage!,fit: BoxFit.cover,):SizedBox(),
                      ),
                      onTap: ()async{
                        File? image = await _openGallery();
                        if(image!=null){
                          provider.updateUploadeCourseImage(image);
                        }
                      },
                    ),
                    Row(
                      spacing: 20,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomText(title: "isFree".tr(),fontSize: 20,fontColor: AppTheme.isDarkMode()?greyColor:Colors.black,),
                        Switch(value: provider.isCourseFree,activeColor: mainColor
                            , onChanged: (value){
                              provider.updateIsCourseFree(value);
                            })
                      ],
                    ),

                    const SizedBox(height: 20,),
                    CustomButton(title: "Submit".tr(),fontSize: 18, onTap: (){
                      provider.addCourse();
                    })
                  ],
                ),
              ),),
            )
          );
        },
      ),
    );
  }

  Future<File?> _openGallery()async{
    final ImagePicker imagePicker = ImagePicker();
    final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
    if(image!=null){
      return File(image.path);
    }
    return null;
  }
}
