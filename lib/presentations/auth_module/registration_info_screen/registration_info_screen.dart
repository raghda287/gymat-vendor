import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/core/dateFormat/dateFormat.dart';
import 'package:gymatvendor/core/navigator/navigator.dart';
import 'package:gymatvendor/data/models/local_day_model.dart';
import 'package:gymatvendor/data/models/location.dart';
import 'package:gymatvendor/presentations/auth_module/provider/auth_provider.dart';
import 'package:gymatvendor/presentations/auth_module/registration_info_screen/widgets/is_delivery_service_widget.dart';
import 'package:gymatvendor/presentations/auth_module/registration_info_screen/widgets/shop_category_widget.dart';
import 'package:gymatvendor/presentations/auth_module/registration_step2_screen/registration_step2_screen.dart';
import 'package:gymatvendor/presentations/map_search_screen/map_search_screen.dart';
import 'package:gymatvendor/presentations/widgets/calender/am_pm_widget.dart';
import 'package:gymatvendor/presentations/widgets/custom_avatar/custom_avatar.dart';
import 'package:gymatvendor/presentations/widgets/custom_bordered_container/custom_bordered_container.dart';
import 'package:gymatvendor/presentations/widgets/custom_button/custom_button.dart';
import 'package:gymatvendor/presentations/widgets/custom_rounded_image/custom_rounded_image.dart';
import 'package:gymatvendor/presentations/widgets/custom_svg/CustomSvgIcon.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';
import 'package:gymatvendor/presentations/widgets/custom_text_form/custom_text_form.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../injection.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';
import '../../widgets/dialogs/scaffold_messanger.dart';
import '../../widgets/dialogs/time_picker_dialog/timePickerDialog.dart';
import 'widgets/price_per_day_widget.dart';
import 'widgets/work_time_item.dart';
import 'dart:ui' as ui;

class RegistrationInfoScreen extends StatefulWidget {
  const RegistrationInfoScreen({super.key});

  @override
  State<RegistrationInfoScreen> createState() => _RegistrationInfoScreenState();
}

class _RegistrationInfoScreenState extends State<RegistrationInfoScreen> {
  AuthProvider authProvider = getIt();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {authProvider.initSignUp(); });


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
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          width: 36,
                          height: 36,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: AppTheme.isDarkMode() ? inputBgDark : inputBg,
                              shape: BoxShape.circle),
                          child: CustomSvgIcon(
                            assetName: 'gallery',
                            color:
                                AppTheme.isDarkMode() ? Colors.white : Colors.black,
                          ),
                        ),
                        title: CustomText(
                          title: '+Add logo'.tr(),
                          fontSize: 16,
                          fontColor: AppTheme.isDarkMode() ? Colors.white : mainColor,
                        ),
                        trailing: provider.logoPath!=null?CustomAvatar(
                          url: provider.logoPath,
                          radius: 36,
                          placeHolderColor:
                              AppTheme.isDarkMode() ? Colors.black : Colors.white,
                        ):const SizedBox(),
                        onTap: () {
                          showPhotoSheet('logo');
                        },
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          width: 36,
                          height: 36,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: AppTheme.isDarkMode() ? inputBgDark : inputBg,
                              shape: BoxShape.circle),
                          child: CustomSvgIcon(
                            assetName: 'gallery',
                            color:
                                AppTheme.isDarkMode() ? Colors.white : Colors.black,
                          ),
                        ),
                        title: CustomText(
                          title: '+Add photo'.tr(),
                          fontSize: 16,
                          fontColor: AppTheme.isDarkMode() ? Colors.white : mainColor,
                        ),
                        trailing: provider.photoPath!=null?CustomRoundedImage(
                          url: provider.photoPath,
                          radius: 2,
                          width: 36,
                          height: 20,
                        ):const SizedBox(),
                        onTap: () {
                          showPhotoSheet('photo');
                        },
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          width: 36,
                          height: 36,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: AppTheme.isDarkMode() ? inputBgDark : inputBg,
                              shape: BoxShape.circle),
                          child: CustomSvgIcon(
                            assetName: 'ch_location',
                            color:
                                AppTheme.isDarkMode() ? Colors.white : Colors.black,
                          ),
                        ),
                        title: CustomText(
                          title: '+Add location'.tr(),
                          fontSize: 16,
                          fontColor: AppTheme.isDarkMode() ? Colors.white : mainColor,
                        ),
                        subtitle: provider.locationModel != null
                            ? CustomText(
                                title: provider.locationModel?.address ?? '',
                                fontSize: 12,
                                fontColor: AppTheme.isDarkMode()
                                    ? greyColor
                                    : greyColor.withOpacity(.7),
                                fontWeight: FontWeight.bold,
                              )
                            : null,
                        trailing: provider.isLoadingLocation
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: mainColor,
                                ),
                              )
                            : const SizedBox(),
                        onTap: () {
                          showLocationSheet();
                        },
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      CustomText(
                        title: 'Businuss name'.tr(),
                        fontSize: 14,
                        fontColor: AppTheme.isDarkMode() ? Colors.white : mainColor,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      CustomTextFormField(
                        controller: authProvider.nameController,
                        textInputType: TextInputType.text,
                      ),

                      if(authProvider.getUserType()!=null&&authProvider.getUserType()==USERTYPE.gym.name)PricePerDayWidget(controller: authProvider.gymPricePerDayController,),

                      const SizedBox(
                        height: 12,
                      ),
                      CustomText(
                        title: 'Phone number'.tr(),
                        fontSize: 14,
                        fontColor: AppTheme.isDarkMode() ? Colors.white : mainColor,
                        fontWeight: FontWeight.bold,
                      ),

                      const SizedBox(
                        height: 12,
                      ),
                      Directionality(
                        textDirection: ui.TextDirection.ltr,
                        child: CustomTextFormField(
                          prefix: CustomText(
                            title: authProvider.countryCode?.dialCode!,
                            fontColor: mainColor,
                          ),
                          controller: authProvider.phoneController,
                          textInputType: TextInputType.phone,
                        ),
                      ),

                      if(authProvider.getUserType()!=null&&authProvider.getUserType()==USERTYPE.market.name&&!authProvider.shopCategoryForEdit)const ShopCategoryWidget(),

                      const SizedBox(
                        height: 12,
                      ),

                      CustomText(
                        title: 'Email'.tr(),
                        fontSize: 14,
                        fontColor: AppTheme.isDarkMode() ? Colors.white : mainColor,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(
                        height: 12,

                      ),

                      CustomTextFormField(
                        controller: authProvider.providerEmailController,
                        textInputType: TextInputType.emailAddress,
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      CustomText(
                        title: 'Website'.tr(),
                        fontSize: 14,
                        fontColor: AppTheme.isDarkMode() ? Colors.white : mainColor,
                        fontWeight: FontWeight.bold,
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      CustomTextFormField(
                        controller: authProvider.siteController,
                        textInputType: TextInputType.url,
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      CustomText(
                        title: 'Description'.tr(),
                        fontSize: 14,
                        fontColor: AppTheme.isDarkMode() ? Colors.white : mainColor,
                        fontWeight: FontWeight.bold,
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      CustomTextFormField(
                        controller: authProvider.descriptionController,
                        textInputType: TextInputType.text,
                      ),

                     if(authProvider.getUserType()!=null&&authProvider.getUserType()==USERTYPE.healthyFood.name) Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 16,
                          ),

                          IsDeliveryServiceWidget(defaultValue: authProvider.isDelevieryService??false,onChecked: (bool value) {
                            authProvider.updateIsDelivery(value);
                          },),
                      ],),

                      const SizedBox(
                        height: 12,
                      ),

                      !provider.canShowWorkTime()?const SizedBox():Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                title: 'Work times'.tr(),
                                fontSize: 14,
                                fontColor:
                                    AppTheme.isDarkMode() ? Colors.white : mainColor,
                                fontWeight: FontWeight.bold,
                              ),
                              IconButton(
                                  onPressed: () {
                                    showTimeSheet();
                                  },
                                  icon: Icon(
                                    Icons.add,
                                    color: AppTheme.isDarkMode()
                                        ? Colors.white
                                        : Colors.black,
                                  ))
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: provider.workTimeList.length,
                              itemBuilder: (context,index){
                                return WorkTimeItem(model: provider.workTimeList[index],index: index,);

                          })
                        ],
                      ),


                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                child: CustomButton(title: 'Confirm'.tr(), onTap: (){
                  AuthProvider provider = getIt();
                  provider.checkAccountInfoData();
                }),
              )
            ],
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
                    onTap: () {
                      NavigatorHandler.pop();
                      authProvider.pickImage(ImageSource.camera, type,type=='photo'?CropAspectRatioPreset.ratio16x9:null);
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
                      authProvider.pickImage(ImageSource.gallery, type,type=='photo'?CropAspectRatioPreset.ratio16x9:null);
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

  void showLocationSheet() {
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
                      title: 'Select your location'.tr(),
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
                    ? Colors.white.withOpacity(.1)
                    : greyColor.withOpacity(.05),
                height: 1,
              ),
              const SizedBox(
                height: 16,
              ),
              ListTile(
                onTap: () {
                  NavigatorHandler.pop();
                  authProvider.getLocation(context.locale.languageCode);
                },
                leading: CustomSvgIcon(
                  assetName: 'gps',
                  color: AppTheme.isDarkMode() ? Colors.white : Colors.black,
                ),
                title: CustomText(
                  title: 'Use current location'.tr(),
                  fontColor:
                      AppTheme.isDarkMode() ? Colors.white : Colors.black,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Divider(
                  color: AppTheme.isDarkMode()
                      ? Colors.white.withOpacity(.05)
                      : greyColor.withOpacity(.1),
                  height: 1,
                ),
              ),
              ListTile(
                onTap: () async {
                  LocationModel? model =
                      await NavigatorHandler.push(const MapSearchScreen());
                  if (model != null) {
                    authProvider.updateCurrentLocation(model);
                  }
                  await NavigatorHandler.pop();
                },
                leading: CustomSvgIcon(
                  assetName: 'pin1',
                  color: AppTheme.isDarkMode() ? Colors.white : Colors.black,
                ),
                title: CustomText(
                  title: 'Select location on map'.tr(),
                  fontColor:
                      AppTheme.isDarkMode() ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          );
        });
  }

  void showTimeSheet() {
    authProvider.clearWorkTime();
    showModalBottomSheet(
        context: context,
        backgroundColor: AppTheme.isDarkMode() ? sheetBg : Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        builder: (context) {
          return Consumer<AuthProvider>(
            builder: (context, provider, _) {
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
                          title: 'Select time'.tr(),
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
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: CustomText(
                      title: 'Day2'.tr(),
                      fontColor:
                      AppTheme.isDarkMode() ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                            color: AppTheme.isDarkMode()
                                ? Colors.white.withOpacity(.2)
                                : greyColor.withOpacity(.2))),
                    child: DropdownButton<LocalDayModel>(
                        value: provider.selectedDay,
                        hint: CustomText(
                          title: 'Choose day'.tr(),
                          fontColor: AppTheme.isDarkMode()
                              ? greyColor.withOpacity(.8)
                              : greyColor.withOpacity(.5),
                        ),
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: authProvider.localDays
                            .map((e) => DropdownMenuItem<LocalDayModel>(
                            value: e,
                            child: CustomText(
                              title: e.title,
                              fontSize: 16,
                              fontColor: AppTheme.isDarkMode()
                                  ? Colors.white
                                  : Colors.black,
                            )))
                            .toList(),
                        onChanged: (day) {
                          provider.updateSelectedDay(day);
                        }),
                  ),
                  const SizedBox(
                    height: 24,
                  ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: CustomText(title: 'Time'.tr(),fontColor: AppTheme.isDarkMode() ? Colors.white : Colors.black,),
                ),
                  const SizedBox(
                    height: 12,
                  ),
                Padding(

                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(children: [
                    Expanded(child: InkWell(
                        onTap: () async{
                          TimeOfDay? fromTime = await  showTimePickerDialog();
                          if(fromTime!=null){
                            provider.updateFromTime(fromTime);

                          }

                        },
                        child: CustomBorderedContainer(bg: AppTheme.isDarkMode()?inputBgDark:inputBg,child: CustomText(title: provider.fromTime!=null?CustomDateTimeFormat().convertTimeOfDayToAmPm(provider.fromTime!):'From'.tr(),),))),
                    const SizedBox(width: 24,),
                    Expanded(child: InkWell(
                        onTap: () async{
                           TimeOfDay? toTime = await  showTimePickerDialog();
                           if(toTime!=null){
                             provider.updateToTime(toTime);


                           }


                        },
                        child: CustomBorderedContainer(bg: AppTheme.isDarkMode()?inputBgDark:inputBg,child: CustomText(title: provider.toTime!=null?CustomDateTimeFormat().convertTimeOfDayToAmPm(provider.toTime!):'To'.tr(),),))),

                  ],),
                ),

                  const SizedBox(
                    height: 24,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: CustomButton(title: 'Confirm'.tr(), onTap: (){
                      provider.addWorkTime();
                    }),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              );
            },
          );
        });
  }
}

