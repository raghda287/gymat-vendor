import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/data/models/service_model.dart';
import 'package:gymatvendor/presentations/gym_module/gym_add_membership_service/widgets/add_subscribtion_widget.dart';
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
import '../../../core/text_styles/text_styles.dart';
import '../../../injection.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';
import '../../widgets/custom_svg/CustomSvgIcon.dart';
import '../provider/gym_services_provider.dart';
import 'widgets/subscribtion_item.dart';

class GymAddMemberShipService extends StatefulWidget {
  final ServiceModel? serviceModel;

  const GymAddMemberShipService({super.key, this.serviceModel});

  @override
  State<GymAddMemberShipService> createState() =>
      _GymAddMemberShipServiceState();
}

class _GymAddMemberShipServiceState extends State<GymAddMemberShipService> {
  GymServicesProvider gymServicesProvider = getIt();
  final TextEditingController _serviceNameController = TextEditingController();
  final TextEditingController _serviceDescriptionController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      gymServicesProvider.initAddMembershipService(widget.serviceModel);

    });
    if (widget.serviceModel != null) {
      _serviceNameController.text = widget.serviceModel!.title ?? '';

      _serviceDescriptionController.text = widget.serviceModel!.text ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showToolBar: true,
        showBackArrow: true,
        title: widget.serviceModel == null
            ? 'Add service'.tr()
            : 'Update service'.tr(),
        elevation: 1,
        isMainBack: true,
        bgColor: AppTheme.isDarkMode() ? dark : Colors.white,
      ),
      body: Consumer<GymServicesProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title: 'Service name'.tr(),
                  fontColor:
                      AppTheme.isDarkMode() ? Colors.white : Colors.black,
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomTextFormField(controller: _serviceNameController),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      title: 'Service picture'.tr(),
                      fontColor:
                          AppTheme.isDarkMode() ? Colors.white : Colors.black,
                    ),
                    InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          showPhotoSheet();
                        },
                        child: CustomRoundedImage(
                          width: 64,
                          height: 64*3/4,
                          radius: 4,
                          elevation: 0,
                          url: provider.servicePhotoPath,
                        ))
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: provider.subscribtions.length,
                  itemBuilder: (context, index) {
                    return SubscribtionItem(
                      model: provider.subscribtions[index],
                      index: index,
                      onDelete: () {
                        if (provider.subscribtions[index].id == 0) {
                          provider.deleteSubscribtionItem(index);
                        } else {
                          if (provider.subscribtions.length > 1) {
                            createDeleteAlertDialog(
                                Text.rich(TextSpan(
                                    text: '${'Delete'.tr()} ',
                                    style: AppTextStyles()
                                        .normalText(fontSize: 13)
                                        .textColorNormal(AppTheme.isDarkMode()
                                            ? greyColor
                                            : Colors.black),
                                    children: [
                                      TextSpan(
                                          text: provider
                                                  .subscribtions[index].title ??
                                              '',
                                          style: AppTextStyles()
                                              .normalText(fontSize: 17)
                                              .textColorBold(
                                                  AppTheme.isDarkMode()
                                                      ? Colors.white
                                                      : Colors.black))
                                    ])), () {
                              NavigatorHandler.pop();
                              gymServicesProvider.deleteDeleteMembershipOption(provider.subscribtions[index]);
                            }, () {
                              NavigatorHandler.pop();
                            });
                          } else {
                            CustomScaffoldMessanger.showScaffoledMessanger(
                                title: 'Cannot delete this subscribtion. should have at least 1 subscribtion'.tr());
                          }
                        }
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(
                      color: greyColor
                          .withOpacity(AppTheme.isDarkMode() ? 0.2 : 1),
                      thickness: .1,
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          showAddSubscribtionSheet();
                        },
                        child: CustomText(
                          title: '+ Add more subscribtions'.tr(),
                          fontSize: 13,
                          fontColor: mainColor,
                        )),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomText(
                  title: 'Description'.tr(),
                  fontColor:
                      AppTheme.isDarkMode() ? Colors.white : Colors.black,
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomTextFormFieldArea(
                  controller: _serviceDescriptionController,
                  height: 140,
                ),
                const SizedBox(
                  height: 24,
                ),
                CustomButton(
                    title: 'Confirm'.tr(),
                    onTap: () {
                      String name = _serviceNameController.text.trim();
                      String description = _serviceDescriptionController.text.trim();
                      if (provider.servicePhotoPath != null &&
                          name.isNotEmpty&&
                          description.isNotEmpty &&
                          provider.subscribtions.isNotEmpty) {
                        if(widget.serviceModel==null){
                          provider.addMemberShipService(name,description);

                        }else{
                          provider.updateMemberShipService(widget.serviceModel!.id!,name, description);
                        }
                      } else if (name.isEmpty) {
                        CustomScaffoldMessanger.showToast(
                            title: 'Service name field is required'.tr());
                      } else if (provider.subscribtions.isEmpty) {
                        CustomScaffoldMessanger.showToast(
                            title:
                                'You should add at least 1 subscribtion'.tr());
                      } else if (provider.servicePhotoPath == null) {
                        CustomScaffoldMessanger.showToast(
                            title: 'Service picture is required'.tr());
                      } else if (description.isEmpty) {
                        CustomScaffoldMessanger.showToast(
                            title:
                                'Service descreiption field is required'.tr());
                      }
                    }),
                const SizedBox(
                  height: 24,
                ),
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
                      gymServicesProvider.pickImage(ImageSource.camera,);
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
                      gymServicesProvider.pickImage(ImageSource.gallery);
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

  void showAddSubscribtionSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: AppTheme.isDarkMode() ? sheetBg : Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: const AddSubscriptionWidget(),
          );
        });
  }

  void createDeleteAlertDialog(Widget titleWidget, VoidCallback onDelete, VoidCallback onCancel) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            surfaceTintColor: Colors.transparent,
            backgroundColor: AppTheme.isDarkMode() ? dark : Colors.white,
            contentPadding: const EdgeInsets.all(12),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 12,
                ),
                titleWidget,
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: onCancel,
                        child: CustomText(
                          title: 'Cancel'.tr(),
                          fontSize: 14,
                          fontColor: greyColor,
                        )),
                    const SizedBox(
                      width: 12,
                    ),
                    TextButton(
                        onPressed: onDelete,
                        child: CustomText(
                          title: 'Delete'.tr(),
                          fontSize: 14,
                          fontColor: Colors.red,
                        )),
                  ],
                )
              ],
            ),
          );
        });
  }

  Future<PermissionStatus> _requestCameraPermission() async {
    return Permission.camera.request();
  }



}
