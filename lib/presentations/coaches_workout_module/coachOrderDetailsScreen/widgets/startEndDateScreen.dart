import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/main.dart';
import 'package:gymatvendor/presentations/widgets/custom_bordered_container/custom_bordered_container.dart';

import '../../../../core/app_colors/app_colors.dart';
import '../../../../core/app_theme/theme.dart';
import '../../../../core/navigator/navigator.dart';
import '../../../gym_module/gymOrderDetailsScreen/widgets/calender.dart';
import '../../../widgets/custom_app_bar/custom_app_bar.dart';
import '../../../widgets/custom_button/custom_button.dart';
import '../../../widgets/custom_svg/CustomSvgIcon.dart';
import '../../../widgets/custom_text/custom_text.dart';
import '../../../widgets/custom_text_form/custom_text_form.dart';
import '../../../widgets/dialogs/scaffold_messanger.dart';

class StartEndDateScreen extends StatefulWidget {
  const StartEndDateScreen({super.key});

  @override
  State<StartEndDateScreen> createState() => _StartEndDateScreenState();
}

class _StartEndDateScreenState extends State<StartEndDateScreen> {
  String? startDate;
  String? endDate;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showToolBar: true,
        showBackArrow: true,
        elevation: 1,
        isMainBack: true,
        bgColor: AppTheme.isDarkMode() ? dark : Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 12,
                ),
                CustomText(
                  title: 'Start date'.tr(),
                  fontSize: 14,
                  fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,
                ),
                const SizedBox(
                  height: 16,
                ),

                InkWell(
                  onTap: (){
                    showCalenderSheet('start date');
                  },
                  child: CustomBorderedContainer(
                      borderRadius: 8,
                      borderColor: Colors.transparent,
                      bg: AppTheme.isDarkMode()?inputBgDark:inputBg,
                      child: CustomText(title: startDate??'',fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,)),
                ),
                const SizedBox(
                  height: 16,
                ),

                CustomText(
                  title: 'End date'.tr(),
                  fontSize: 14,
                  fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,
                ),
                const SizedBox(
                  height: 16,
                ),

                InkWell(
                  onTap: (){
                    showCalenderSheet('end date');
                  },
                  child: CustomBorderedContainer(
                      borderRadius: 8,
                      borderColor: Colors.transparent,
                      bg: AppTheme.isDarkMode()?inputBgDark:inputBg,
                      child: CustomText(title: endDate??'',fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,)),
                ),

                const SizedBox(
                  height: 8,
                ),
            ],),

            CustomButton(title: 'Save'.tr(), onTap: () async{
              if(startDate!=null&&endDate!=null){
                var map = {
                  'sDate':startDate,
                  'eDate':endDate
                };

                await NavigatorHandler.pop(map);

              }else if(startDate==null){
                CustomScaffoldMessanger.showToast(title: 'Choose start date'.tr());
              }else if(endDate==null){
                CustomScaffoldMessanger.showToast(title: 'Choose end date'.tr());

              }
            }),


          ],
        ),
      )
    );

  }


  void showCalenderSheet(String type) {
    String date = DateFormat('yyyy-MM-dd','en').format(DateTime.now());
    showModalBottomSheet(
        context: navigatorKey.currentState!.context,
        backgroundColor: AppTheme.isDarkMode()?dark:Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(24), topLeft: Radius.circular(24))),
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding:  EdgeInsets.only(top: 16,left: 12,right: 12,bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(title: type=='start date'?'Choose start date'.tr():'Choose end date'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,fontWeight: FontWeight.bold,fontSize: 14,),
                    InkWell(
                        onTap: (){NavigatorHandler.pop();},
                        child: CustomSvgIcon(assetName: 'close',color: AppTheme.isDarkMode()?Colors.white:Colors.black,))
                  ],),
                const SizedBox(height: 24,),
                AppCalender(workTimeList:const [],onDateSelected: (dateTime){
                  date = DateFormat('yyyy-MM-dd').format(dateTime);

                }),
                const SizedBox(height: 24,),

                CustomButton(title: 'Confirm'.tr(), onTap: () async{
                  if(date.isNotEmpty){



                    await NavigatorHandler.pop();
                    await Future.delayed(const Duration(milliseconds: 150));
                    if(type =='start date'){
                      startDate = date;
                      if(mounted){
                        setState(() {

                        });
                      }
                    }else{
                      endDate = date;
                      if(mounted){
                        setState(() {

                        });
                      }
                    }
                  }else{
                    CustomScaffoldMessanger.showToast(title: 'Choose date'.tr());
                  }
                },bg: mainColor,fontColor: Colors.white,),
                const SizedBox(height: 16,)

              ],
            ),
          );
        });
  }

}
