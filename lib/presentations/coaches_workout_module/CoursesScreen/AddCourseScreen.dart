import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/injection.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/provider/coach_services_provider.dart';
import 'package:gymatvendor/presentations/widgets/custom_button/custom_button.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';
import 'package:gymatvendor/presentations/widgets/custom_text_form/custom_text_form.dart';
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
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Center(child: Form(
              key: formKey,
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   CustomText(
                    title: "Course Title".tr(),
                    fontSize: 18,
                    fontColor: greyColor,
                  ),
                  CustomTextFormField(
                    controller: provider.courseTitleController,
                  ),
                   CustomText(
                    title: "Description".tr(),
                    fontSize: 18,
                    fontColor: greyColor,
                  ),
                  CustomTextFormField(
                    controller: provider.descriptionController,
                  ),
                   CustomText(
                    title: "Price".tr(),
                    fontSize: 18,
                    fontColor: greyColor,
                  ),
                  CustomTextFormField(
                    controller: provider.priceController,
                  ),
                  const SizedBox(height: 20,),
                  CustomButton(title: "Submit".tr(),fontSize: 18, onTap: (){
                    provider.addCourse();
                  })
                ],
              ),
            ),)
          );
        },
      ),
    );
  }
}
