import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/constants/constants.dart';
import 'package:gymatvendor/data/models/day_unit_type.dart';
import 'package:gymatvendor/data/models/department_model.dart';
import 'package:gymatvendor/data/models/service_model.dart';
import 'package:gymatvendor/presentations/gym_module/gym_add_membership_service/gym_add_membership_service.dart';
import 'package:gymatvendor/presentations/sport_field_module/provider/sports_field_services_provider.dart';
import 'package:gymatvendor/presentations/widgets/custom_avatar/custom_avatar.dart';
import 'package:gymatvendor/presentations/widgets/custom_bordered_container/custom_bordered_container.dart';
import 'package:gymatvendor/presentations/widgets/custom_button/custom_button.dart';
import 'package:gymatvendor/presentations/widgets/custom_rounded_image/custom_rounded_image.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';
import 'package:gymatvendor/presentations/widgets/custom_text_form/custom_text_form.dart';
import 'package:gymatvendor/presentations/widgets/custom_text_form_area/custom_text_form_area.dart';
import 'package:gymatvendor/presentations/widgets/dialogs/scaffold_messanger.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../../core/navigator/navigator.dart';
import '../../../injection.dart';
import '../../widgets/add_discount_widget/addDiscountWidget.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';
import '../../widgets/custom_svg/CustomSvgIcon.dart';
import '../../widgets/drop_down_days/drop_down_days.dart';
import '../../widgets/drop_down_widget/drop_down_widget.dart';

class SportsFieldAddService extends StatefulWidget {
  final ServiceModel? serviceModel;
  const SportsFieldAddService({super.key, this.serviceModel});

  @override
  State<SportsFieldAddService> createState() => _SportsFieldAddServiceState();
}

class _SportsFieldAddServiceState extends State<SportsFieldAddService> {
  SportsFieldServicesProvider sportsFieldServicesProvider =getIt();
  DepartmentModel? departmentModel;
  String? durationUnitType;
  final TextEditingController _serviceNameController = TextEditingController();
  final TextEditingController _servicePriceController = TextEditingController();
  final TextEditingController _serviceTimeController = TextEditingController();
  final TextEditingController _serviceDescriptionController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  bool isDiscountActive = false;
  String discountType = 'value';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    durationUnitType = minuteUnitType.first.value;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) { sportsFieldServicesProvider.initAddService();
    if(widget.serviceModel!=null){
      sportsFieldServicesProvider.servicePhotoPath = widget.serviceModel!.photo;
      departmentModel = widget.serviceModel!.category;
      durationUnitType = widget.serviceModel!.service_time_name;
      _serviceNameController.text = widget.serviceModel!.title??'';
      _servicePriceController.text = widget.serviceModel!.basic_price!=null?widget.serviceModel!.basic_price!.toString()??'':'';
      _serviceDescriptionController.text =widget.serviceModel!.text??'';
      _serviceTimeController.text = widget.serviceModel!.service_time!=null?widget.serviceModel!.service_time!.toString()??'':'';

      _discountController.text = widget.serviceModel!.offer_value !=null&&widget.serviceModel!.offer_value !=0?widget.serviceModel!.offer_value!.toString():'';
      isDiscountActive = widget.serviceModel!.has_offer??false;
      discountType = widget.serviceModel!.offer_type??'value';

      if(mounted){
        setState(() {

        });
      }
    }
    });



  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showToolBar: true,
        showBackArrow: true,
        title: widget.serviceModel==null?'Add service'.tr():'Update service'.tr(),
        elevation: 1,
        isMainBack: true,
        bgColor: AppTheme.isDarkMode() ? dark : Colors.white,
      ),
      body: Consumer<SportsFieldServicesProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               Visibility(
                 visible: widget.serviceModel==null,
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     CustomText(title: 'Department'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,),
                     const SizedBox(height: 12,),
                     DropDownDepartmentWidget(departments: provider.departments,defaultValue: widget.serviceModel?.category, onValueSelected: (value) {
                       departmentModel = value;
                     }, isLoading: provider.isLoadingDepartment,),
                     const SizedBox(height: 12,),
                   ],
                 ),
               ),
                CustomText(title: 'Service name'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,),
                const SizedBox(height: 12,),
                CustomTextFormField(controller: _serviceNameController),
                const SizedBox(height: 12,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(title: 'Service picture'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,),
                    InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: (){
                          showPhotoSheet();
                        },
                        child: CustomRoundedImage(width: 64,height: 64,radius: 4,elevation: 0,url: provider.servicePhotoPath,boxFit: BoxFit.cover,))
                  ],
                ),
                const SizedBox(height: 12,),
                CustomText(title: 'Price'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,),
                const SizedBox(height: 12,),
                CustomTextFormField(controller: _servicePriceController,textInputType: const TextInputType.numberWithOptions(signed: false,decimal: true),maxLength: 6,minPrefixSuffixWidth: 32,suffix:
                CustomSvgIcon(assetName: 'sar',width: 14,height: 14,color: AppTheme.isDarkMode()?Colors.white:Colors.black,),),
                const SizedBox(height: 4,),
                CustomText(title: 'Note: All prices include VAT'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white.withOpacity(0.5):Colors.grey,),
                const SizedBox(height: 12,),

                AddDiscountWidget(controller: _discountController, onDiscountTypeChanged: (value){
                  discountType = value;
                }, isDiscountActiveChanged:(value){
                  isDiscountActive = value;
                }, isDiscountActive: isDiscountActive, discountType: discountType,),
                const SizedBox(height: 12,),

                CustomText(title: 'Service time'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,),
                const SizedBox(height: 12,),
                Row(
                  children: [
                    Expanded(child: CustomTextFormField(controller: _serviceTimeController,textInputType: const TextInputType.numberWithOptions(signed: false,decimal: false),maxLength: 2,suffix: CustomText(title: 'Mins'.tr(),fontSize: 17,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,),minPrefixSuffixWidth: 48,)),
/*
                    const SizedBox(width: 16,),
*/
/*
                    Visibility(
                      visible: false,
                      child: DropDownDays(list: minuteUnitType,defalutValue: widget.serviceModel!=null?getMinuteUnitType(widget.serviceModel!.service_time_name!):null, onValueSelected: (value) {
                        durationUnitType = value;

                      },),
                    )
*/

                  ],
                ),
                const SizedBox(height: 12,),
                CustomText(title: 'Description'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,),
                const SizedBox(height: 12,),
                CustomTextFormFieldArea(controller: _serviceDescriptionController,height: 140,),
                const SizedBox(height: 24,),
                CustomButton(title: 'Confirm'.tr(), onTap: (){
                  RegExp regExp = RegExp(r'^\d*\.?\d{1,2}$');
                  String name = _serviceNameController.text.trim();
                  String price = _servicePriceController.text.trim();
                  String time = _serviceTimeController.text.trim();
                  String description = _serviceDescriptionController.text.trim();
                  String discount = _discountController.text.trim();


                  if(departmentModel!=null&&provider.servicePhotoPath!=null&&name.isNotEmpty&&regExp.hasMatch(price)&&time.isNotEmpty&&!time.startsWith('0')&&description.isNotEmpty){

                    if(isDiscountActive){

                      if(!regExp.hasMatch(discount)){
                        CustomScaffoldMessanger.showToast(title: 'Invalid discount value'.tr());
                        return;
                      }else if(num.parse(discount)==0){

                        CustomScaffoldMessanger.showToast(title: 'Invalid discount value'.tr());
                        return;
                      }else if((discountType=='value'&&num.parse(discount)>=num.parse(price))||((discountType=='per'&&num.parse(discount)>=100))){

                        CustomScaffoldMessanger.showToast(title: 'Invalid discount value'.tr());
                        return;
                      }

                    }



                    if(widget.serviceModel==null){
                      provider.addService(departmentModel!.id!, name, price, time, description,discount,isDiscountActive,discountType);

                    }else{
                      provider.updateService(widget.serviceModel!.id!,departmentModel!.id!, name, price, time, description,discount,isDiscountActive,discountType);

                    }
                  }else if(departmentModel==null){
                    CustomScaffoldMessanger.showToast(title: 'Choose department2'.tr());
                  }else if(name.isEmpty){
                    CustomScaffoldMessanger.showToast(title: 'Service name field is required'.tr());
                  }else if(provider.servicePhotoPath==null){
                    CustomScaffoldMessanger.showToast(title: 'Service picture is required'.tr());
                  }else if(!regExp.hasMatch(price)){
                    CustomScaffoldMessanger.showToast(title: 'Invalid price'.tr());

                  }else if(time.isEmpty||time.startsWith('0')){
                    CustomScaffoldMessanger.showToast(title: 'Service time field is required'.tr());

                  }else if(description.isEmpty){
                    CustomScaffoldMessanger.showToast(title: 'Service descreiption field is required'.tr());

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
                      sportsFieldServicesProvider.pickImage(ImageSource.camera,);
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
                      sportsFieldServicesProvider.pickImage(ImageSource.gallery,);
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


  Future<PermissionStatus> _requestCameraPermission() async {
    return Permission.camera.request();
  }

}
