import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/text_styles/text_styles.dart';
import 'package:gymatvendor/presentations/ads_module/ad_provider/ad_provider.dart';
import 'package:gymatvendor/presentations/ads_module/add_ad_screen/widgets/show_ad_where.dart';
import 'package:gymatvendor/presentations/ads_module/add_ad_screen/widgets/upload_ad_photo.dart';
import 'package:gymatvendor/presentations/widgets/custom_bordered_container/custom_bordered_container.dart';
import 'package:gymatvendor/presentations/widgets/custom_button/custom_button.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';
import 'package:gymatvendor/presentations/widgets/dialogs/scaffold_messanger.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../core/app_theme/theme.dart';
import '../../../core/navigator/navigator.dart';
import '../../../data/models/location.dart';
import '../../../injection.dart';
import '../../map_search_screen/map_search_screen.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';
import '../../widgets/custom_svg/CustomSvgIcon.dart';
import '../../widgets/payment_details_widget/payment_details_widget.dart';

class AddAdScreen extends StatefulWidget {
  const AddAdScreen({super.key});

  @override
  State<AddAdScreen> createState() => _AddAdScreenState();
}

class _AddAdScreenState extends State<AddAdScreen> {
  AdProvider adProvider = getIt();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    adProvider.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showToolBar: true,
        showBackArrow: true,
        isMainBack: true,
        title: 'Advertising'.tr(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Consumer<AdProvider>(
          builder: (context, provider, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title: 'Upload your ads'.tr(),
                  fontSize: 14,
                  fontColor: greyColor,
                ),
                const SizedBox(
                  height: 16,
                ),
                UploadAdPhoto(
                  url: provider.adPhoto,
                  onTap: () {
                    showPhotoSheet();
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                ShowAdWhereWidget(
                  onValueChanged: (int value) {
                    provider.updateShowAdWhere(value);
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                Card(
                  surfaceTintColor: Colors.transparent,
                  elevation: 1,
                  color: Theme.of(context).cardColor,
                  child: SfDateRangePicker(
                    backgroundColor: Colors.transparent,
                    selectionMode: DateRangePickerSelectionMode.range,
                    todayHighlightColor: mainColor,
                    initialDisplayDate: DateTime.now(),
                    initialSelectedDate: DateTime.now(),
                    minDate: DateTime.now(),
                    rangeSelectionColor: AppTheme.isDarkMode()
                        ? Colors.black
                        : mainColor.withOpacity(.2),
                    selectionColor: mainColor,
                    enablePastDates: false,
                    startRangeSelectionColor: mainColor,
                    endRangeSelectionColor: mainColor,
                    monthCellStyle: DateRangePickerMonthCellStyle(
                        textStyle: AppTextStyles()
                            .normalText(fontSize: 13)
                            .textColorNormal(AppTheme.isDarkMode()
                                ? Colors.white
                                : Colors.black),
                        todayTextStyle: AppTextStyles()
                            .normalText(fontSize: 13)
                            .textColorNormal(AppTheme.isDarkMode()
                                ? Colors.white
                                : Colors.black)),
                    rangeTextStyle: AppTextStyles()
                        .normalText(fontSize: 13)
                        .textColorNormal(AppTheme.isDarkMode()
                            ? Colors.white
                            : Colors.black),
                    selectionTextStyle: AppTextStyles()
                        .normalText(fontSize: 13)
                        .textColorNormal(AppTheme.isDarkMode()
                            ? Colors.white
                            : Colors.white),
                    onSelectionChanged: (arg) {
                      if (arg.value.endDate != null) {
                        DateTime format =
                            DateFormat('yyyy-MM-dd hh:mm:ss.SSS', 'en')
                                .parse(arg.value.startDate.toString());
                        String startDate =
                            DateFormat('yyyy-MM-dd', 'en').format(format);
                        DateTime format2 =
                            DateFormat('yyyy-MM-dd hh:mm:ss.SSS', 'en')
                                .parse(arg.value.endDate.toString());
                        String endDate =
                            DateFormat('yyyy-MM-dd', 'en').format(format2);
                        provider.updateSelectedRangeDate(startDate, endDate);
                      }else{
                        provider.updateSelectedRangeDate(provider.startDate, null);

                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
               /* CustomText(
                  title: 'Time :'.tr(),
                  fontColor:
                      AppTheme.isDarkMode() ? Colors.white : Colors.black,
                  fontSize: 14,
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    CustomText(
                      title: 'From :'.tr(),
                      fontColor:
                          AppTheme.isDarkMode() ? Colors.white : Colors.black,
                      fontSize: 14,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(child: FromTomTimeWidget(
                      title: provider.fromTime!=null?DateFormat('hh:mm a','en').format(provider.fromTime!):null,
                      onTap: () {
                        showTimePickerDialog('from');
                      },
                    ))
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    CustomText(
                      title: 'To :'.tr(),
                      fontColor:
                          AppTheme.isDarkMode() ? Colors.white : Colors.black,
                      fontSize: 14,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                        child: FromTomTimeWidget(
                          title: provider.toTime!=null?DateFormat('hh:mm a','en').format(provider.toTime!):null,

                          onTap: () {
                        showTimePickerDialog('to');

                      },
                    ))
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomText(
                  title: 'Duration :'.tr(),
                  fontColor:
                  AppTheme.isDarkMode() ? Colors.white : Colors.black,
                  fontSize: 14,
                ),
                const SizedBox(
                  height: 12,
                ),
                DurationWidget(controller:provider.secondsController),*/

                CustomText(
                  title: 'Location'.tr(),
                  fontSize: 14,
                  fontColor: greyColor,
                ),
                const SizedBox(
                  height: 12,
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async{
                    LocationModel? model = await NavigatorHandler.push(const MapSearchScreen());
                    if (model != null) {
                      provider.updateAdLocation(model);
                    }
                  },
                  child: CustomBorderedContainer(
                    height: 56,
                    borderRadius:8,
                      bg: AppTheme.isDarkMode()?inputBgDark:inputBg,
                      borderColor: Colors.transparent,
                      child: Row(
                    children: [
                      Expanded(child: CustomText(title: provider.adLocation?.address??'',fontColor: AppTheme.isDarkMode()?Colors.white.withOpacity(.7):Colors.black,fontSize: 13,)),
                      const SizedBox(width: 12,),
                      Icon(Icons.arrow_forward_ios_rounded,color: AppTheme.isDarkMode()?Colors.white:Colors.black,size: 18,)
                    ],
                  )),
                ),
                const SizedBox(
                  height: 24,
                ),
                CustomButton(title: 'Next'.tr(),fontSize: 16, onTap: (){
                  if(adProvider.checkAddAdData()){
                    adProvider.calculateAdPrice();
                    //adProvider.addAd();
                    //showChoosePaymentTypeSheet();

                  }
                }),

                const SizedBox(
                  height: 24,
                ),
              ],
            );
          },
        ),
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
                      adProvider.pickImage(ImageSource.camera);
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
                      adProvider.pickImage(ImageSource.gallery);
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

  void showTimePickerDialog(String type) async {
    TimeOfDay time = TimeOfDay.now();

    if(adProvider.fromTime!=null){
      if(type=='to'){
        time = TimeOfDay(hour: adProvider.fromTime!.hour, minute: adProvider.fromTime!.minute+5);
      }
    }
    TimeOfDay? timeOfDay = await showTimePicker(
        context: context,
        initialTime: time,

        builder: (context, child) {
         return Theme(data:Theme.of(context).copyWith(
           colorScheme: ColorScheme.light(
               primary: mainColor,
               onPrimary: AppTheme.isDarkMode()?Colors.white:Colors.black,
               secondary: mainColor,
               onSecondary: Colors.white,
               primaryContainer: Colors.transparent,
               surfaceTint: Colors.transparent,
               onBackground: AppTheme.isDarkMode()?Colors.black:inputBg,
               surface:AppTheme.isDarkMode()?inputBgDark:Colors.white ,
               onSurface: AppTheme.isDarkMode()?Colors.white:Colors.black),
           textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: AppTheme.isDarkMode()?Colors.white:mainColor))
           

         ) , child: child!);
        });

    if(timeOfDay!=null){
      DateTime now = DateTime.now();

      if(type=='from'){
        DateTime from = DateTime(now.year,now.month,now.day,timeOfDay.hour,timeOfDay.minute);
        bool isOld = from.isBefore(now);
        if(!isOld){
          adProvider.updateFromTime(from);
          adProvider.updateToTime(null);
        }else{
          CustomScaffoldMessanger.showToast(title: 'Invalid time you choosed an old time'.tr(),bg: Colors.red);
        }



      }else{
        DateTime to = DateTime(now.year,now.month,now.day,timeOfDay.hour,timeOfDay.minute);
        bool isOld = to.isBefore(now);
        if(isOld){
          adProvider.updateToTime(null);

          CustomScaffoldMessanger.showToast(title: 'Invalid time you choosed an old time'.tr(),bg: Colors.red);
        }else if(to.isBefore(adProvider.fromTime!)){
          adProvider.updateToTime(null);
          CustomScaffoldMessanger.showToast(title: 'To time must be greater than from time'.tr(),bg: Colors.red);

        }else{
          adProvider.updateToTime(to);

        }

      }
    }
  }

  Future<PermissionStatus> _requestCameraPermission() async {
    return Permission.camera.request();
  }


}
