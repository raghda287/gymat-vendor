import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/dimens/dimens.dart';
import 'package:gymatvendor/core/navigator/navigator.dart';
import 'package:gymatvendor/core/text_styles/text_styles.dart';
import 'package:gymatvendor/data/models/department_model.dart';
import 'package:gymatvendor/data/models/service_model.dart';
import 'package:gymatvendor/presentations/gym_module/gym_add_membership_service/gym_add_membership_service.dart';
import 'package:gymatvendor/presentations/gym_module/gym_add_service/gym_add_service.dart';
import 'package:gymatvendor/presentations/sport_field_module/provider/sports_field_services_provider.dart';
import 'package:gymatvendor/presentations/sport_field_module/sports_field_add_service/sports_field_add_service.dart';
import 'package:gymatvendor/presentations/widgets/category_item/category_item.dart';
import 'package:gymatvendor/presentations/healthcub_spa_module/provider/healthyclub_spa_home_provider.dart';
import 'package:gymatvendor/presentations/widgets/custom_button/custom_button.dart';
import 'package:gymatvendor/presentations/widgets/custom_svg/CustomSvgIcon.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';
import 'package:gymatvendor/presentations/widgets/custom_text_form/custom_text_form.dart';
import 'package:gymatvendor/presentations/widgets/dialogs/scaffold_messanger.dart';
import 'package:gymatvendor/presentations/widgets/loading_indicator/loading_indicator_gym.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../../injection.dart';
import '../../profile_module/provider/profile_provider.dart';
import '../../widgets/service_item_widget/service_item_widget.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';
import '../../widgets/loading_indicator/loading_indicator.dart';

class SportsFieldServicesScreen extends StatefulWidget {
  final DepartmentModel? homeDepartmentModel;

  const SportsFieldServicesScreen({super.key, this.homeDepartmentModel});

  @override
  State<SportsFieldServicesScreen> createState() => _SportsFieldServicesScreenState();
}

class _SportsFieldServicesScreenState extends State<SportsFieldServicesScreen> {
  SportsFieldServicesProvider sportsFieldServicesProvider = getIt();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      sportsFieldServicesProvider.init();
      sportsFieldServicesProvider.getDepartments(widget.homeDepartmentModel);
    });
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
      body: Consumer<SportsFieldServicesProvider>(
        builder: (context, provider, _) {
          return SizedBox(
            width: Dimens.width,
            height: Dimens.height,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        title: 'Departments:-'.tr(),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontColor:
                            AppTheme.isDarkMode() ? Colors.white : Colors.black,
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          ProfileProvider profileProvider = getIt();
                          if (profileProvider.isAccountProviderCompleted()) {
                            showAddDepartmentSheet(null, null);
                          } else {
                            CustomScaffoldMessanger.showScaffoledMessanger(
                                title:
                                    'Complete your information to verify the account'
                                        .tr());
                          }
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.add,
                              size: 16,
                              color: mainColor,
                            ),
                            CustomText(
                              title: 'Add category'.tr(),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontColor: mainColor,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    height: 42,
                    child: ScrollablePositionedList.builder(
                        itemScrollController:
                            provider.departmentItemScrollController,
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.horizontal,
                        itemCount: provider.departments.length,
                        itemBuilder: (context, index) {
                          DepartmentModel model = provider.departments[index];
                          return CategoryItem(
                            model: model,
                            index: index,
                            onTap: (index) {
                              provider.updateSelectedCategory(index);
                            },
                            selected: provider.selectedCategoryIndex == index,
                            onLongTap: () {
                              showDepartmentActionSheet(model, index);
                            },
                          );
                        }),
                  ),
                  CustomText(
                    title: 'Services:-'.tr(),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontColor:
                        AppTheme.isDarkMode() ? Colors.white : Colors.black,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Expanded(
                      child: provider.isLoading
                          ? const Padding(
                              padding: EdgeInsets.only(bottom: 120.0),
                              child: LoadingIndicatorGym(),
                            )
                          : provider.services.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.only(bottom: 120.0),
                                  child: Center(
                                    child: CustomText(
                                      title:
                                          'Sorry! no services to show....'.tr(),
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      fontColor: AppTheme.isDarkMode()
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: provider.services.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    ServiceModel? model =
                                        provider.services[index];
                                    if (model == null) {
                                      return const LoadingIndicator(
                                        width: 32,
                                        stroke: 3,
                                      );
                                    } else {
                                      return ServiceItemWidget(
                                        serviceModel: model,
                                        index: index,
                                        onUpdate: (int index,
                                            ServiceModel model) async {
                                          await Future.delayed(const Duration(
                                              milliseconds: 300));
                                          NavigatorHandler.push(SportsFieldAddService(
                                            serviceModel: model,
                                          ));
                                        },
                                        onDelete: (index) async {
                                          await Future.delayed(const Duration(
                                              milliseconds: 300));
                                          createDeleteAlertDialog(
                                              Text.rich(TextSpan(
                                                  text: '${'Delete'.tr()} ',
                                                  style: AppTextStyles()
                                                      .normalText(fontSize: 13)
                                                      .textColorNormal(
                                                          AppTheme.isDarkMode()
                                                              ? greyColor
                                                              : Colors.black),
                                                  children: [
                                                    TextSpan(
                                                        text:
                                                            model.getTitle(),
                                                        style: AppTextStyles()
                                                            .normalText(
                                                                fontSize: 17)
                                                            .textColorBold(AppTheme
                                                                    .isDarkMode()
                                                                ? Colors.white
                                                                : Colors.black))
                                                  ])), () async{
                                            NavigatorHandler.pop();
                                            await Future.delayed(const Duration(milliseconds: 300));
                                            sportsFieldServicesProvider.deleteService(model);
                                          }, () {
                                            NavigatorHandler.pop();
                                          });
                                        },
                                        onTap: () {
                                          NavigatorHandler.push(SportsFieldAddService(
                                            serviceModel: model,
                                          ));
                                        },
                                        onLongTap: () {
                                          showServiceActionSheet(model, index);
                                        },
                                      );
                                    }
                                  })),
                  Center(
                      child: CustomButton(
                    title: '+ Add a new service'.tr(),
                    onTap: () {
                      ProfileProvider profileProvider = getIt();
                      if (profileProvider.isAccountProviderCompleted()) {
                        NavigatorHandler.push(const SportsFieldAddService());
                      } else {
                        CustomScaffoldMessanger.showScaffoledMessanger(
                            title:
                            'Complete your information to verify the account'
                                .tr());
                      }
                    },
                    width: Dimens.width * .6,
                    height: 48,
                  )),
                  const SizedBox(
                    height: 12,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void showAddDepartmentSheet(DepartmentModel? departmentModel, int? index) {
    TextEditingController controller = TextEditingController();
    if (departmentModel != null) {
      controller.text = departmentModel.title ?? '';
    }
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
                      title: departmentModel == null
                          ? 'Add category'.tr()
                          : 'Update category'.tr(),
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
                  title: 'Department name'.tr(),
                  fontSize: 14,
                  fontColor:
                      AppTheme.isDarkMode() ? Colors.white : Colors.black,
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomTextFormField(
                  controller: controller,
                  bgColor: AppTheme.isDarkMode()
                      ? Colors.black.withOpacity(.3)
                      : inputBg,
                ),
                const SizedBox(
                  height: 24,
                ),
                CustomButton(
                    title: 'Confirm'.tr(),
                    onTap: () {
                      String name = controller.text.trim();
                      if (name.isNotEmpty) {
                        NavigatorHandler.pop();
                        if (departmentModel == null) {
                          sportsFieldServicesProvider.addDepartment(name);
                        } else {
                          sportsFieldServicesProvider.updateDepartment(
                              departmentModel, name, index);
                        }
                      } else {
                        CustomScaffoldMessanger.showToast(
                            title: 'Department name field is required'.tr());
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

  void showDepartmentActionSheet(DepartmentModel model, int index) {
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
                                    text: model.getTitle(),
                                    style: AppTextStyles()
                                        .normalText(fontSize: 17)
                                        .textColorBold(AppTheme.isDarkMode()
                                            ? greyColor
                                            : Colors.black))
                              ])), () {
                        NavigatorHandler.pop();
                        sportsFieldServicesProvider.deleteDepartment(model);
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
                    onTap: () {
                      NavigatorHandler.pop();
                      showAddDepartmentSheet(model, index);
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

  void createDeleteAlertDialog(
      Widget titleWidget, VoidCallback onDelete, VoidCallback onCancel) {
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

  void showServiceActionSheet(ServiceModel model, int index) {
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
                    onTap: () async {
                      NavigatorHandler.pop();
                      await Future.delayed(const Duration(milliseconds: 300));
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
                                    text: model.getTitle(),
                                    style: AppTextStyles()
                                        .normalText(fontSize: 17)
                                        .textColorBold(AppTheme.isDarkMode()
                                            ? Colors.white
                                            : Colors.black))
                              ])), () async {
                        NavigatorHandler.pop();
                        await Future.delayed(const Duration(milliseconds: 300));
                        sportsFieldServicesProvider.deleteService(model);
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
                    onTap: () async {
                      await NavigatorHandler.pop();
                      await Future.delayed(const Duration(milliseconds: 200));
                      NavigatorHandler.push(SportsFieldAddService(
                        serviceModel: model,
                      ));
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
}
