import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/data/models/liveSessionModel.dart';
import 'package:gymatvendor/injection.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/livesession_screen/widgets/isFreeCheckBox.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/provider/livesession_provider.dart';
import 'package:gymatvendor/presentations/gym_module/gymOrderDetailsScreen/widgets/calender.dart';
import 'package:gymatvendor/presentations/widgets/custom_bordered_container/custom_bordered_container.dart';
import 'package:gymatvendor/presentations/widgets/custom_button/custom_button.dart';
import 'package:gymatvendor/presentations/widgets/custom_rounded_image/custom_rounded_image.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';
import 'package:gymatvendor/presentations/widgets/custom_text_form/custom_text_form.dart';
import 'package:gymatvendor/presentations/widgets/custom_text_form_area/custom_text_form_area.dart';
import 'package:gymatvendor/presentations/widgets/dialogs/scaffold_messanger.dart';
import 'package:gymatvendor/presentations/widgets/dialogs/time_picker_dialog/timePickerDialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../../core/navigator/navigator.dart';
import '../../widgets/add_discount_widget/addDiscountWidget.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';
import '../../widgets/custom_svg/CustomSvgIcon.dart';

class AddLiveSessionScreen extends StatefulWidget {
  final LiveSessionModel? liveSessionModel;

  const AddLiveSessionScreen({super.key, this.liveSessionModel});

  @override
  State<AddLiveSessionScreen> createState() => _AddLiveSessionScreenState();
}

class _AddLiveSessionScreenState extends State<AddLiveSessionScreen> {
  LiveSessionProvider liveSessionProvider = getIt();
  final TextEditingController _topic = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  bool isDiscountActive = false;
  String discountType = 'value';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.liveSessionModel != null) {
      _topic.text = widget.liveSessionModel!.getTitle();
      _price.text = widget.liveSessionModel!.new_price != null &&
              widget.liveSessionModel!.new_price != 0
          ? '${widget.liveSessionModel!.new_price}'
          : '';
      _description.text = widget.liveSessionModel!.getText();
      isDiscountActive = widget.liveSessionModel!.has_offer ?? false;
      discountType = widget.liveSessionModel!.offer_type ?? 'value';
      _discountController.text = widget.liveSessionModel!.offer_value != null &&
              widget.liveSessionModel!.offer_value != 0
          ? '${widget.liveSessionModel!.offer_value}'
          : '';
    }
    liveSessionProvider.initAddLiveSession(widget.liveSessionModel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showToolBar: true,
        showBackArrow: true,
        title: 'Live sessions'.tr(),
        elevation: 1,
        isMainBack: true,
        bgColor: AppTheme.isDarkMode() ? dark : Colors.white,
      ),
      body: Consumer<LiveSessionProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title: 'Live session topic'.tr(),
                  fontSize: 15,
                  fontColor:
                      AppTheme.isDarkMode() ? Colors.white : Colors.black,
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomTextFormField(
                  controller: _topic,
                  fontSize: 15,
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomText(
                  title: 'Add picture cover'.tr(),
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
                    onTap: () {
                      showPhotoSheet();
                    },
                    child: CustomRoundedImage(
                      width: 200,
                      height: 200*9/16,
                      url: provider.sessionCoverUrl,
                    )),
                const SizedBox(
                  height: 16,
                ),
                IsFreeCheckBox(
                  isFree: provider.isFree,
                  onValueChanged: (bool value) {
                    if (value) {
                      _price.clear();
                      _discountController.clear();
                      discountType = 'value';
                      isDiscountActive = false;
                    }
                    provider.updateIsFree(value);
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomTextFormField(
                  controller: _price,
                  hint: 'Price'.tr(),
                  suffix: CustomSvgIcon(assetName: 'sar',width: 14,height: 14,color: AppTheme.isDarkMode()
                      ? Colors.white
                      : Colors.black,),
                  readOnly: provider.isFree,
                  textInputType: const TextInputType.numberWithOptions(
                      signed: false, decimal: true),
                ),
                if (!provider.isFree)
                  AddDiscountWidget(
                    controller: _discountController,
                    onDiscountTypeChanged: (value) {
                      discountType = value;
                    },
                    isDiscountActiveChanged: (value) {
                      isDiscountActive = value;
                    },
                    isDiscountActive: isDiscountActive,
                    discountType: discountType,
                  ),
                const SizedBox(
                  height: 12,
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomText(
                  title: 'Describtion'.tr(),
                  fontSize: 14,
                  fontColor: greyColor,
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomTextFormFieldArea(
                  controller: _description,
                  height: 180,
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomText(
                  title: 'Aired on'.tr(),
                  fontSize: 14,
                  fontColor: greyColor,
                ),
                const SizedBox(
                  height: 12,
                ),
                AppCalender(
                    initDateTime: provider.dateTime,
                    onDateSelected: (dateTime) {
                      if (dateTime != null) {
                        DateFormat dateFormat = DateFormat('yyyy-MM-dd', 'en');
                        String date = dateFormat.format(dateTime);
                        provider.updateSessionStartDate(date);
                      }
                    },
                    workTimeList: const []),
                const SizedBox(
                  height: 12,
                ),
                CustomText(
                  title: 'Start time'.tr(),
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
                  onTap: () async {
                    DateTime dateTime = DateTime(provider.dateTime!.year,provider.dateTime!.month,provider.dateTime!.day,TimeOfDay.now().hour,TimeOfDay.now().minute+15,0,0);


                    TimeOfDay? timeOfDay = await showTimePickerDialog(TimeOfDay.fromDateTime(dateTime));

                    if (timeOfDay != null) {
                      DateFormat dateFormate = DateFormat('hh:mm a', 'en');
                      String time = dateFormate.format(DateTime(0, 1, 1, timeOfDay.hour, timeOfDay.minute, 0, 0));
                      provider.updateSessionStartTime(time);
                    }
                  },
                  child: CustomBorderedContainer(
                      borderColor: Colors.transparent,
                      borderRadius: 12,
                      bg: AppTheme.isDarkMode() ? inputBgDark : inputBg,
                      child: CustomText(
                        title: provider.fromTime ?? '',
                        fontColor: mainColor,
                        fontSize: 15,
                      )),
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomText(
                  title: 'End time'.tr(),
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
                  onTap: () async {

                    DateTime dateTime = DateTime(provider.dateTime!.year,provider.dateTime!.month,provider.dateTime!.day,TimeOfDay.now().hour,TimeOfDay.now().minute+15,0,0);

                    TimeOfDay toTimeOfDay = TimeOfDay.fromDateTime(dateTime);


                    if (provider.fromTime != null) {
                      toTimeOfDay = TimeOfDay.fromDateTime(
                          DateFormat('hh:mm a', 'en')
                              .parse(provider.fromTime!)
                              .add(const Duration(minutes: 15)));
                    }

                    TimeOfDay? timeOfDay = await showTimePickerDialog(toTimeOfDay);


                    if (timeOfDay != null) {
                      DateFormat dateFormate = DateFormat('hh:mm a', 'en');
                      String time = dateFormate.format(DateTime(0, 1, 1, timeOfDay.hour, timeOfDay.minute, 0, 0));
                      provider.updateSessionEndTime(time);
                    }
                  },
                  child: CustomBorderedContainer(
                      borderColor: Colors.transparent,
                      borderRadius: 12,
                      bg: AppTheme.isDarkMode() ? inputBgDark : inputBg,
                      child: CustomText(
                        title: provider.toTime ?? '',
                        fontColor: mainColor,
                        fontSize: 15,
                      )),
                ),
                const SizedBox(
                  height: 24,
                ),
               widget.liveSessionModel ==null || (widget.liveSessionModel != null && widget.liveSessionModel!.status != 'live')
                    ? CustomButton(
                        title: 'Save'.tr(),
                        onTap: () {
                          RegExp regExp = RegExp(r'^\d*\.?\d{1,2}$');
                          String topic = _topic.text.trim();
                          String price = _price.text.trim();
                          String description = _description.text.trim();
                          String discount = _discountController.text.trim();
                          if (topic.isEmpty) {
                            CustomScaffoldMessanger.showToast(
                                title: 'Topic is invalid'.tr());
                            return;
                          } else if (provider.sessionCoverUrl == null) {
                            CustomScaffoldMessanger.showToast(
                                title: 'Choose live session cover photo'.tr());
                            return;
                          } else if (!provider.isFree && !regExp.hasMatch(price)) {
                            CustomScaffoldMessanger.showToast(title: 'Invalid price'.tr());
                          } else if (!provider.isFree && isDiscountActive && !regExp.hasMatch(discount)) {
                            CustomScaffoldMessanger.showToast(title: 'Invalid discount value'.tr());
                            return;
                          } else if (description.isEmpty) {
                            CustomScaffoldMessanger.showToast(title: 'Description is required'.tr());
                            return;
                          } else if (provider.fromTime == null) {
                            CustomScaffoldMessanger.showToast(title: 'Select start time'.tr());
                            return;
                          } else if (provider.toTime == null) {
                            CustomScaffoldMessanger.showToast(title: 'Select end time'.tr());
                            return;
                          }

                          DateTime dateTimeNow = DateTime.now();
                          DateTime now = DateTime(
                              dateTimeNow.year,
                              dateTimeNow.month,
                              dateTimeNow.day,
                              dateTimeNow.hour,
                              dateTimeNow.minute,
                              0,
                              0,
                              0);
                          DateTime from = DateFormat('yyyy-MM-dd hh:mm a', 'en').parse('${provider.date} ${provider.fromTime!}');
                          DateTime to = DateFormat('yyyy-MM-dd hh:mm a', 'en').parse('${provider.date} ${provider.toTime!}');




                          print('now=>>${now}');
                          print('from=>>${from}');
                          print('to=>>${to}');


                          int diffFromNow = from.millisecondsSinceEpoch - now.millisecondsSinceEpoch;

                          int diff = from.millisecondsSinceEpoch - to.millisecondsSinceEpoch;




                          if (widget.liveSessionModel == null) {
                            if (diffFromNow < 0) {
                              CustomScaffoldMessanger.showToast(title: 'Start time is old'.tr());
                              return;
                            } else if (diff >= 0) {
                              CustomScaffoldMessanger.showToast(title: 'End time is old'.tr());
                              return;
                            } else if (to.difference(from).inMinutes < 15) {
                              CustomScaffoldMessanger.showToast(title: 'Minimum duration of live session is 15 minutes'.tr());
                              return;
                            }

                            provider.addLiveSession(topic, description, price.isEmpty?'0':price, isDiscountActive, discountType, discount.isEmpty?'0':discount);
                          } else {
                            DateTime dateTimeNow = DateTime.now();
                            DateTime now = DateTime(dateTimeNow.year, dateTimeNow.month, dateTimeNow.day);
                            DateTime selectedDateTime = DateFormat('yyyy-MM-dd', 'en').parse(provider.date!);

                            int diff2 = selectedDateTime.millisecondsSinceEpoch - now.millisecondsSinceEpoch;

                            if (diff2 < 0) {
                              CustomScaffoldMessanger.showToast(
                                  title: 'Date is old'.tr());
                              return;
                            } else if (diffFromNow < 0) {
                              CustomScaffoldMessanger.showToast(
                                  title: 'Start time is old'.tr());
                              return;
                            } else if (diff >= 0) {
                              CustomScaffoldMessanger.showToast(
                                  title: 'End time is old'.tr());
                              return;
                            } else  if (to.difference(from).inMinutes < 6) {
                              CustomScaffoldMessanger.showToast(
                                  title:
                                      'Minimum duration of live session is 15 minutes'
                                          .tr());
                              return;
                            }

                             provider.updateLiveSession(widget.liveSessionModel!.id,topic, description, price.isEmpty?'0':price, isDiscountActive, discountType, discount.isEmpty?'0':discount);
                          }
                        },
                        bg: mainColor,
                      )
                    : const SizedBox(),
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
                      liveSessionProvider.pickImage(ImageSource.camera);
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
                      liveSessionProvider.pickImage(ImageSource.gallery);
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
