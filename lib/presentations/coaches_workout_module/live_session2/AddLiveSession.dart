import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/dimens/dimens.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/live_session2/Provider/LiveSessionProvider2.dart';
import 'package:gymatvendor/presentations/widgets/custom_button/custom_button.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../../injection.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';
import '../../widgets/custom_text/custom_text.dart';
import '../../widgets/custom_text_form/custom_text_form.dart';

class AddLiveSessionScreen extends StatefulWidget {
  int courseId;

  AddLiveSessionScreen({super.key, required this.courseId});
  @override
  State<StatefulWidget> createState() {
    return AddLiveSessionState();
  }
}

class AddLiveSessionState extends State<AddLiveSessionScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showToolBar: true,
        showBackArrow: true,
        title: "Create Live Session",
        elevation: 1,
        isMainBack: true,
        bgColor: AppTheme.isDarkMode() ? dark : Colors.white,
      ),

      body: Consumer<LiveSessionProvider2>(
        builder: (context, provider, _) {
          return Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     CustomText(
                      title: "Session Title".tr(),
                      fontSize: 18,
                      fontColor: AppTheme.isDarkMode()?greyColor:Colors.black,
                    ),

                    CustomTextFormField(
                      controller: provider.sessionTitleController,
                    ),

                     CustomText(
                      title: "Session Description".tr(),
                      fontSize: 18,
                      fontColor:AppTheme.isDarkMode()?greyColor:Colors.black,
                    ),

                    CustomTextFormField(
                      controller: provider.sessionDescriptionController,
                    ),

                     CustomText(
                      title: "Date".tr(),
                      fontSize: 18,
                      fontColor: AppTheme.isDarkMode()?greyColor:Colors.black,
                    ),
                    InkWell(
                      onTap: () async {
                        _showDialog(context, provider);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        width: Dimens.width,
                        height: 54,
                        decoration: BoxDecoration(
                          color: AppTheme.isDarkMode()?inputBgDark:inputBg,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomText(
                              title: provider.selectedDate,
                              fontColor: AppTheme.isDarkMode()?greyColor:Colors.black,
                            ),
                            const Icon(
                              Icons.calendar_month,
                              size: 24,
                              color: mainColor,
                            ),
                          ],
                        ),
                      ),
                    ),

                    Row(
                      spacing: 10,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               CustomText(
                                title: "From".tr(),
                                fontSize: 18,
                                fontColor: AppTheme.isDarkMode()?greyColor:Colors.black,
                              ),
                              InkWell(
                                onTap: () async {
                                  _showTimPicker(context,"from",provider);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  width: Dimens.width,
                                  height: 54,
                                  decoration: BoxDecoration(
                                    color: AppTheme.isDarkMode()?inputBgDark:inputBg,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      CustomText(
                                        title: provider.fromTime,
                                        fontColor: AppTheme.isDarkMode()?greyColor:Colors.black,
                                      ),
                                      const Icon(
                                        Icons.timelapse,
                                        size: 24,
                                        color: mainColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               CustomText(
                                title: "To".tr(),
                                fontSize: 18,
                                fontColor: AppTheme.isDarkMode()?greyColor:Colors.black,
                              ),
                              InkWell(
                                onTap: () async {
                                  _showTimPicker(context,"to",provider);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  width: Dimens.width,
                                  height: 54,
                                  decoration: BoxDecoration(
                                    color: AppTheme.isDarkMode()?inputBgDark:inputBg,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      CustomText(
                                        title: provider.toTime,
                                        fontColor: AppTheme.isDarkMode()?greyColor:Colors.black,
                                      ),
                                      const Icon(
                                        Icons.timelapse,
                                        size: 24,
                                        color: mainColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),

                    Row(
                      spacing: 20,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                         CustomText(title: "isFree".tr(),fontSize: 20,fontColor: AppTheme.isDarkMode()?greyColor:Colors.black,),
                        Switch(value: provider.isFree,activeColor: mainColor
                            , onChanged: (value){
                              provider.updateIsFree(value);
                            })
                      ],
                    ),

                    const SizedBox(height: 50,),
                    CustomButton(title:"Create Session".tr(),fontSize: 20,fontWeight: FontWeight.bold, onTap: (){
                      provider.createLiveSession(widget.courseId,"schedule");
                    })
                  ],
                ),
              )
            ),
          );

        },
      ),
    );
  }

  Future<void> _showPicker(
    BuildContext context,
    LiveSessionProvider2 provider,
  ) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      locale: const Locale('en','US'),
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: mainColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: mainColor),
            ),
            dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
          ),
          child: child!,
        );
      },
    );
    if (selectedDate != null) {
      final formattedDate = DateFormat('yyyy-MM-dd', 'en_US').format(selectedDate);
      provider.updatedSelectedDate(formattedDate);
    }
  }

  void _showDialog(BuildContext context, LiveSessionProvider2 provider) {
    showDialog(
      context: context,
      builder: (widgetContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            width: Dimens.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color:  AppTheme.isDarkMode()?dark:Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   CustomText(
                    title: "Choose Session Date".tr(),
                    fontSize: 15,
                    fontColor: AppTheme.isDarkMode()?greyColor:Colors.black,
                    fontWeight: FontWeight.w700,
                  ),

                  const SizedBox(height: 20),
                     InkWell(
                    child:  Row(
                      spacing: 5,
                      children: [
                        const Icon(Icons.add, size: 30, color: mainColor),
                        CustomText(
                          title: "Start instant".tr(),
                          fontSize: 15,
                          fontColor: AppTheme.isDarkMode()?greyColor:Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                    onTap: ()async{
                      Navigator.pop(context);
                     await _showAcceptanceDialog(context,provider);

                    },
                  ),
                  const SizedBox(height: 20,),

                  InkWell(
                    child:  Row(
                      spacing: 5,
                      children: [
                        const Icon(Icons.calendar_month, size: 30, color: mainColor),
                        CustomText(
                          title: "Schedule Meeting".tr(),
                          fontSize: 15,
                          fontColor: AppTheme.isDarkMode()?greyColor:Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                    onTap: () async{
                      await _showPicker(context, provider).then((_){
                        Navigator.pop(context);
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showTimPicker(BuildContext context,String type, LiveSessionProvider2 provider)async{
    TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        initialEntryMode: TimePickerEntryMode.input);
    if (selectedTime != null) {
      final formattedTime = "${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}";
      if(type=="from"){
        provider.updatedFromTime(formattedTime);
      }else{
        provider.updatedToTime(formattedTime);
      }
    }
  }

  Future<void> _showAcceptanceDialog(
      BuildContext context,
      LiveSessionProvider2 provider,
      ) async {
    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          content: CustomText(
            title: "do you want it free".tr(),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();

                await Future.delayed(
                  const Duration(milliseconds: 200),
                );

                provider.updateIsFree(true);

                await provider.createLiveSession(
                  widget.courseId,
                  "instant",
                );
              },
              child: CustomText(
                title: "yes".tr(),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();

                await Future.delayed(
                  const Duration(milliseconds: 200),
                );

                provider.updateIsFree(false);

                await provider.createLiveSession(
                  widget.courseId,
                  "instant",
                );
              },
              child: CustomText(
                title: "no".tr(),
              ),
            ),
          ],
        );
      },
    );
  }}
