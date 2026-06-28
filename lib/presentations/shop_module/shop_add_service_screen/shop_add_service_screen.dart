import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/constants/constants.dart';
import 'package:gymatvendor/data/models/add_addition_model.dart';
import 'package:gymatvendor/data/models/department_model.dart';
import 'package:gymatvendor/data/models/shop_service_model.dart';
import 'package:gymatvendor/presentations/shop_module/provider/shop_services_provider.dart';
import 'package:gymatvendor/presentations/shop_module/widgets/addition_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../../core/navigator/navigator.dart';
import '../../../injection.dart';
import '../../widgets/add_discount_widget/addDiscountWidget.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';
import '../../widgets/custom_button/custom_button.dart';
import '../../widgets/custom_rounded_image/custom_rounded_image.dart';
import '../../widgets/custom_svg/CustomSvgIcon.dart';
import '../../widgets/custom_text/custom_text.dart';
import '../../widgets/custom_text_form/custom_text_form.dart';
import '../../widgets/custom_text_form_area/custom_text_form_area.dart';
import '../../widgets/dialogs/scaffold_messanger.dart';
import '../../widgets/drop_down_widget/drop_down_widget.dart';

class ShopAddService extends StatefulWidget {
  final DepartmentModel? shopDepartmentModel;
  final ShopServiceModel? shopServiceModel;
  const ShopAddService({super.key, this.shopDepartmentModel, this.shopServiceModel});

  @override
  State<ShopAddService> createState() => _ShopAddServiceState();
}

class _ShopAddServiceState extends State<ShopAddService> {
  ShopServicesProvider shopServicesProvider = getIt();
  final TextEditingController _serviceNameController = TextEditingController();
  final TextEditingController _serviceDescriptionController = TextEditingController();
  final TextEditingController _servicePriceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  bool isDiscountActive = false;
  String discountType = 'value';
  DepartmentModel? departmentModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shopServicesProvider.initAddService(widget.shopServiceModel);

    if(widget.shopServiceModel!=null){
      departmentModel = widget.shopServiceModel!.category;
      _serviceNameController.text = widget.shopServiceModel?.title??'';
      _serviceDescriptionController.text = widget.shopServiceModel?.text??'';
      if(widget.shopServiceModel!.details.isNotEmpty&&widget.shopServiceModel!.details.first.title!=null&&widget.shopServiceModel!.details.first.title!.isEmpty){
        _servicePriceController.text = formatNumber(widget.shopServiceModel!.details.first.price!).toString();

        _discountController.text = widget.shopServiceModel!.details.first.offer_value !=null&&widget.shopServiceModel!.details.first.offer_value !=0?widget.shopServiceModel!.details.first.offer_value!.toString():'';
        isDiscountActive = widget.shopServiceModel!.details.first.has_offer??false;
        discountType = widget.shopServiceModel!.details.first.offer_type??'value';

        if(mounted){
          setState(() {

          });
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
        title: 'Services'.tr(),
        elevation: 1,
        isMainBack: true,
        bgColor: AppTheme.isDarkMode() ? dark : Colors.white,
      ),
      body: Consumer<ShopServicesProvider>(builder: (context, provider, _) {
        if (provider.additions.isNotEmpty) {
          _servicePriceController.text = '';
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: widget.shopServiceModel==null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      title: 'Department'.tr(),
                      fontColor:
                          AppTheme.isDarkMode() ? Colors.white : Colors.black,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    DropDownDepartmentWidget(
                      departments: provider.departments,
                      defaultValue: null,
                      onValueSelected: (value) {
                        departmentModel = value;
                      },
                      isLoading: provider.isLoading,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              ),
              CustomText(
                title: 'Service name'.tr(),
                fontColor: AppTheme.isDarkMode() ? Colors.white : Colors.black,
              ),
              const SizedBox(
                height: 12,
              ),
              CustomTextFormField(controller: _serviceNameController),
              const SizedBox(
                height: 12,
              ),
              CustomText(
                title: 'Service picture'.tr(),
                fontColor: AppTheme.isDarkMode() ? Colors.white : Colors.black,
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                height: provider.photoPaths.isNotEmpty ? 96 : 0,
                child: ListView.builder(
                    itemCount: provider.photoPaths.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Stack(
                          children: [
                            CustomRoundedImage(
                              width: 96,
                              height: 96,
                              url: provider.photoPaths[index],
                            ),
                            Container(
                              width: 96,
                              height: 96,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(.2),
                                  borderRadius: BorderRadius.circular(4)),
                            ),
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    provider.removeServicePhotoPath(index);
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.white.withOpacity(.8),
                                    size: 20,
                                  )),
                            )
                          ],
                        ),
                      );
                    }),
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                      focusColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      onTap: () {
                        showPhotoSheet();
                      },
                      child: CustomText(
                        title: '+ Add more photo'.tr(),
                        fontColor:
                            AppTheme.isDarkMode() ? Colors.white : Colors.black,
                        fontSize: 12,
                      )),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              if (provider.additions.isEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      title: 'Price'.tr(),
                      fontColor:
                          AppTheme.isDarkMode() ? Colors.white : Colors.black,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomTextFormField(
                      controller: _servicePriceController,
                      textInputType: const TextInputType.numberWithOptions(
                          signed: false, decimal: true),
                      maxLength: 6,
                      minPrefixSuffixWidth: 32,
                      suffix: CustomSvgIcon(assetName: 'sar',width: 14,height: 14,color: AppTheme.isDarkMode()
                          ? Colors.white
                          : Colors.black,),
                    ),
                    const SizedBox(height: 4,),
                    CustomText(title: 'Note: All prices include VAT'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white.withOpacity(0.5):Colors.grey,),
                    const SizedBox(height: 12,),

                    AddDiscountWidget(controller: _discountController, onDiscountTypeChanged: (value){
                      discountType = value;
                    }, isDiscountActiveChanged:(value){
                      isDiscountActive = value;
                    }, isDiscountActive: isDiscountActive, discountType: discountType,),
                    const SizedBox(height: 12,),

                  ],
                ),
              CustomText(
                title: 'Additions (ex:prices,sizes etc)'.tr(),
                fontColor: AppTheme.isDarkMode() ? Colors.white : Colors.black,
              ),
              const SizedBox(
                height: 12,
              ),
              GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: provider.additions.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                      childAspectRatio: .9),
                  itemBuilder: (context, index) {
                    return AdditionWidget(
                      model: provider.additions[index],
                      onTap: () {
                        shopServicesProvider.removeAddition(index);
                      },
                    );
                  }),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                      focusColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      onTap: () {
                        showAddAdditionSheet();
                      },
                      child: CustomText(
                        title: '+ Add more'.tr(),
                        fontColor:
                            AppTheme.isDarkMode() ? Colors.white : Colors.black,
                        fontSize: 12,
                      )),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              CustomText(
                title: 'Description'.tr(),
                fontColor: AppTheme.isDarkMode() ? Colors.white : Colors.black,
              ),
              const SizedBox(
                height: 12,
              ),
              CustomTextFormFieldArea(
                controller: _serviceDescriptionController,
                height: 180,
              ),
              const SizedBox(
                height: 24,
              ),
              CustomButton(
                  title: 'Confirm'.tr(),
                  onTap: () {
                    shopServicesProvider.checkAddService(
                      widget.shopServiceModel,
                      widget.shopDepartmentModel,
                        departmentModel,
                        _serviceNameController.text.trim(),
                        _serviceDescriptionController.text.trim(),
                        _servicePriceController.text.trim(),_discountController.text,isDiscountActive,discountType);
                  }),
              const SizedBox(
                height: 24,
              ),
            ],
          ),
        );
      }),
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
                      shopServicesProvider.pickImage(ImageSource.camera, );
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
                      shopServicesProvider.pickImage(ImageSource.gallery,);
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

  void showAddAdditionSheet() {
    TextEditingController titleController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController discountController = TextEditingController();
    bool isDiscountActive = false;
    String discountType = 'value';


    showModalBottomSheet(
        isDismissible: true,
        isScrollControlled: true,
        backgroundColor: AppTheme.isDarkMode() ? dark : Colors.white,
        enableDrag: false,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                left: 12,
                top: 12,
                right: 12,
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: 48,
                    ),
                    CustomText(
                      title:
                          departmentModel == null ? 'Add'.tr() : 'Update'.tr(),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
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
                const SizedBox(
                  height: 12,
                ),
                Divider(
                  color: AppTheme.isDarkMode()
                      ? Colors.white.withOpacity(.05)
                      : inputBg,
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomText(
                  title: 'Addition name'.tr(),
                  fontSize: 14,
                  fontColor:
                      AppTheme.isDarkMode() ? Colors.white : Colors.black,
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomTextFormField(
                  controller: titleController,
                  bgColor: AppTheme.isDarkMode()
                      ? Colors.black.withOpacity(.3)
                      : inputBg,
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomText(
                  title: 'Price'.tr(),
                  fontSize: 14,
                  fontColor:
                      AppTheme.isDarkMode() ? Colors.white : Colors.black,
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomTextFormField(
                  controller: priceController,
                  textInputType: const TextInputType.numberWithOptions(
                      signed: false, decimal: true),
                  maxLength: 6,
                  minPrefixSuffixWidth: 32,
                  suffix: CustomSvgIcon(assetName: 'sar',width: 14,height: 14,color: AppTheme.isDarkMode()
                      ? Colors.white
                      : Colors.black,),
                  bgColor: AppTheme.isDarkMode()
                      ? Colors.black.withOpacity(.3)
                      : inputBg,
                ),

                const SizedBox(
                  height: 12,
                ),
                AddDiscountWidget(controller: discountController, onDiscountTypeChanged: (value){
                  discountType = value;
                }, isDiscountActiveChanged:(value){
                  isDiscountActive = value;
                }, isDiscountActive: isDiscountActive, discountType: discountType,),

                const SizedBox(
                  height: 24,
                ),
                CustomButton(
                    title: 'Confirm'.tr(),
                    onTap: () {
                      RegExp regExp = RegExp(r'^\d*\.?\d{1,2}$');

                      String title = titleController.text.trim();
                      String price = priceController.text.trim();
                      String discount = discountController.text.trim();
                      num? newPrice;
                      if (title.isNotEmpty && regExp.hasMatch(price)) {

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
                          }else{
                            if(discountType =='value'){
                              newPrice = num.parse(price)-num.parse(discount);
                            }else{
                              newPrice = num.parse(price)-(num.parse(price)*(num.parse(discount)/100));
                            }
                          }


                        }



                        AddAditionModel model = AddAditionModel(title, num.parse(price),isDiscountActive,discount.isNotEmpty?num.parse(discount):null,discountType,newPrice);
                        if (shopServicesProvider.additions.contains(model)) {
                          CustomScaffoldMessanger.showToast(title: 'Item is exist'.tr());
                        } else {
                          shopServicesProvider.addAddition(model);
                          NavigatorHandler.pop();
                        }
                      } else if (title.isEmpty) {
                        CustomScaffoldMessanger.showToast(
                            title: 'Name is required'.tr());
                      } else if (!regExp.hasMatch(price)) {
                        CustomScaffoldMessanger.showToast(
                            title: 'Invalid price'.tr());
                      }
                    }),
                const SizedBox(
                  height: 12,
                ),
              ],
            ),
          );
        });
  }
  Future<PermissionStatus> _requestCameraPermission() async {
    return Permission.camera.request();
  }

}
