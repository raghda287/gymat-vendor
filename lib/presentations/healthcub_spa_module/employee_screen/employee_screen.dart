import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/dimens/dimens.dart';
import 'package:gymatvendor/core/navigator/navigator.dart';
import 'package:gymatvendor/data/models/specialist_model.dart';
import 'package:gymatvendor/injection.dart';
import 'package:gymatvendor/presentations/healthcub_spa_module/add_employee_screen/add_employee_screen.dart';
import 'package:gymatvendor/presentations/healthcub_spa_module/employee_screen/widgets/specialist_item_widget.dart';
import 'package:gymatvendor/presentations/profile_module/provider/profile_provider.dart';
import 'package:gymatvendor/presentations/widgets/custom_button/custom_button.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';
import 'package:gymatvendor/presentations/widgets/dialogs/scaffold_messanger.dart';
import 'package:gymatvendor/presentations/widgets/loading_indicator/loading_indicator_gym.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../../core/text_styles/text_styles.dart';
import '../../../data/models/department_model.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';
import '../../widgets/custom_svg/CustomSvgIcon.dart';
import '../provider/specialist_provider.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();

}

class _EmployeeScreenState extends State<EmployeeScreen> {
  SpecialistProvider specialistProvider = getIt();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      specialistProvider.specialistInit();

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showToolBar: true,
        showBackArrow: true,
        title: 'Specialists'.tr(),
        elevation: 1,
        isMainBack: true,
        bgColor: AppTheme.isDarkMode() ? dark : Colors.white,
      ),
      body: Consumer<SpecialistProvider>(
        builder: (context, provider, _) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 24,
                ),
                CustomText(
                  title: 'Specialists'.tr(),
                  fontSize: 15,
                  fontColor: AppTheme.isDarkMode() ? Colors.white : mainColor,
                ),
                const SizedBox(
                  height: 12,
                ),
                Expanded(
                    child: provider.isLoading?const LoadingIndicatorGym():provider.specialists.isEmpty?Center(child: CustomText(title: 'Sorry! no specialists to show...'.tr(),fontSize: 17,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,fontWeight: FontWeight.bold,),):GridView.builder(
                        shrinkWrap: true,
                        itemCount: provider.specialists.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 1 / 1.25,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8),
                        itemBuilder: (context, index) {
                          return InkWell(
                              splashColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              onTap: (){
                                NavigatorHandler.push(AddEmployeeScreen(specialist: provider.specialists[index],));

                              },
                              onLongPress: (){
                                showSpecialistActionSheet(provider.specialists[index],index);
                              },
                              child: SpecialistItem(specialist: provider.specialists[index],));
                        })),
                const SizedBox(
                  height: 12,
                ),
                Center(child: CustomButton(title: '+ Add specialist'.tr(), onTap: (){
                  ProfileProvider profileProvider = getIt();
                  if(!profileProvider.isAccountProviderCompleted()){

                    CustomScaffoldMessanger.showScaffoledMessanger(title: 'Complete your information to verify the account'.tr());

                  }else if(!profileProvider.isSelectedWorkWith()){
                    CustomScaffoldMessanger.showScaffoledMessanger(title: 'To give you a better experience we need to know which gender you want to work with'.tr());

                  }else{
                    NavigatorHandler.push(const AddEmployeeScreen());

                  }
                },height: 48,radius: 24,width: Dimens.width*.6,)),
                const SizedBox(
                  height: 12,
                ),

              ],
            ),
          );
        },
      ),
    );
  }

  void showSpecialistActionSheet(Specialist model, int index) {
    showModalBottomSheet(
        isDismissible: true,
        backgroundColor: AppTheme.isDarkMode() ? dark : Colors.white,
        context: context,
        builder: (context) {
          return SizedBox(
            width: Dimens.width,
            child: Padding(
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
                    height: 8,
                  ),
                  Center(
                    child: Container(
                      width: 54,
                      height: 4,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: AppTheme.isDarkMode()
                              ? greyColor.withOpacity(.2)
                              : greyColor.withOpacity(.5)),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  ListTile(
                    leading: CustomSvgIcon(
                      assetName: 'delete',
                      color:
                      AppTheme.isDarkMode() ? Colors.white : Colors.black,
                    ),
                    title: CustomText(
                      title: 'Delete'.tr(),
                      fontColor:
                      AppTheme.isDarkMode() ? Colors.white : Colors.black,
                      fontSize: 16,
                    ),
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      NavigatorHandler.pop();
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
                                    text: model.name??'',
                                    style: AppTextStyles()
                                        .normalText(fontSize: 17)
                                        .textColorBold(AppTheme.isDarkMode()
                                        ? greyColor
                                        : Colors.black))
                              ])), () {
                        NavigatorHandler.pop();
                        specialistProvider.deleteSpecialist(model);
                      }, () {
                        NavigatorHandler.pop();
                      });
                    },
                  ),
                  ListTile(
                    leading: CustomSvgIcon(
                      assetName: 'edit2',
                      width: 18,
                      height: 18,
                      color:
                      AppTheme.isDarkMode() ? Colors.white : Colors.black,
                    ),
                    title: CustomText(
                      title: 'Edit'.tr(),
                      fontColor:
                      AppTheme.isDarkMode() ? Colors.white : Colors.black,
                      fontSize: 16,
                    ),
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () async{
                      NavigatorHandler.pop();
                      await Future.delayed(const Duration(milliseconds: 200));
                      NavigatorHandler.push(AddEmployeeScreen(specialist: model,));

                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
          );
        });
  }

  void createDeleteAlertDialog(Widget titleWidget, VoidCallback onDelete, VoidCallback onCancel) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
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

}
