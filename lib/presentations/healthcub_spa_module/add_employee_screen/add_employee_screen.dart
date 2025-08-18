import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/data/models/department_model.dart';
import 'package:gymatvendor/injection.dart';
import 'package:gymatvendor/presentations/widgets/custom_bordered_container/custom_bordered_container.dart';
import 'package:gymatvendor/presentations/widgets/custom_button/custom_button.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';
import 'package:gymatvendor/presentations/widgets/custom_text_form/custom_text_form.dart';
import 'package:gymatvendor/presentations/widgets/dialogs/scaffold_messanger.dart';
import 'package:gymatvendor/presentations/widgets/drop_down_widget/drop_down_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../../core/navigator/navigator.dart';
import '../../../data/models/specialist_model.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';
import '../../widgets/custom_avatar/custom_avatar.dart';
import '../../widgets/custom_svg/CustomSvgIcon.dart';
import '../provider/specialist_provider.dart';
import 'widgets/add_photo_widget.dart';
import 'widgets/drop_down_specialist.dart';

class AddEmployeeScreen extends StatefulWidget {
  final Specialist? specialist;
  const AddEmployeeScreen({super.key, this.specialist});

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  SpecialistProvider specialistProvider = getIt();
  final TextEditingController _controller = TextEditingController();
  DepartmentModel? departmentModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      specialistProvider.addSpecialistInit();

      if(widget.specialist!=null){
        specialistProvider.updateSelectedDepartments(widget.specialist!.categories);

        _controller.text = widget.specialist!.name??'';
        specialistProvider.specialistPhotoPath = widget.specialist!.image;

      }

    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showToolBar: true,
        showBackArrow: true,
        title: widget.specialist!=null?'Update specialist'.tr():'Add specialist'.tr(),
        elevation: 1,
        isMainBack: true,
        bgColor: AppTheme.isDarkMode() ? dark : Colors.white,
      ),
      body: Consumer<SpecialistProvider>(
        builder: (context, provider, _) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        const SizedBox(height: 36,),
                        InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: (){showPhotoSheet();},
                            child: AddPhotoWidget(path: provider.specialistPhotoPath,)),
                        const SizedBox(height: 48),
                        CustomText(title: 'Name'.tr(),fontColor: AppTheme.isDarkMode()?greyColor:Colors.black,fontSize: 15,),
                        const SizedBox(height: 12),
                        CustomTextFormField(controller: _controller),
                        const SizedBox(height: 12),
                        CustomText(title: 'Choose department'.tr(),fontColor: AppTheme.isDarkMode()?greyColor:Colors.black,fontSize: 15,),
                        const SizedBox(height: 12),
                        DropDownDepartmentWidget(departments: provider.departments, onValueSelected: (value){
                         provider.addEmployeeDepartment(value);

                        }, isLoading: provider.isLoadingDepartments,defaultValue: departmentModel,),
                        const SizedBox(height: 12,),
                        ListView.builder(
                          itemCount: provider.selectedDepartments.length,
                          itemBuilder: (context,index){
                            DepartmentModel model = provider.selectedDepartments[index];
                          return ListTile(
                            title:CustomText(title: model.getTitle()??'',fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,fontSize: 15,),
                            minLeadingWidth: 0,
                            horizontalTitleGap: 0,
                            contentPadding: EdgeInsets.zero,
                            minVerticalPadding: 0,
                            trailing: IconButton(onPressed: (){
                              provider.deleteEmployeeSelectedDepartment(index);
                            }, icon: const Icon(Icons.check_box_rounded,color: mainColor,)),
                          );
                        },shrinkWrap: true,physics: const NeverScrollableScrollPhysics(),),
                        const SizedBox(height: 24,),


                      ],
                    ),
                  ),
                ),
                CustomButton(title: 'Confirm'.tr(), onTap: (){
                  String name = _controller.text.trim();

                  if(provider.specialistPhotoPath!=null&&name.isNotEmpty&&provider.selectedDepartments.isNotEmpty){
                    if(widget.specialist==null){
                      provider.addSpecialist(name);

                    }else{
                      provider.updateSpecialist(widget.specialist!.id!, name);
                    }
                  }else if(provider.specialistPhotoPath==null){
                    CustomScaffoldMessanger.showToast(title: 'Photo is required'.tr());
                  }else if(name.isEmpty){
                    CustomScaffoldMessanger.showToast(title: 'Name is required'.tr());

                  }else if(provider.selectedDepartments.isEmpty){
                    CustomScaffoldMessanger.showToast(title: 'Choose department2'.tr());

                  }
                }),
                const SizedBox(height: 24,),
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
                    onTap: () async{
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
                      specialistProvider.pickImage(ImageSource.camera);
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
                      specialistProvider.pickImage(ImageSource.gallery);
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
