import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/text_styles/text_styles.dart';
import 'package:gymatvendor/data/models/department_model.dart';
import 'package:gymatvendor/presentations/shop_module/widgets/shop_categories_widgets.dart';
import 'package:gymatvendor/presentations/shop_module/widgets/shop_other_category_listview.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../../core/dimens/dimens.dart';
import '../../../core/navigator/navigator.dart';
import '../../../injection.dart';
import '../../profile_module/provider/profile_provider.dart';
import '../../widgets/category_item/category_item.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';
import '../../widgets/custom_button/custom_button.dart';
import '../../widgets/custom_svg/CustomSvgIcon.dart';
import '../../widgets/custom_text/custom_text.dart';
import '../../widgets/custom_text_form/custom_text_form.dart';
import '../../widgets/dialogs/scaffold_messanger.dart';
import '../../widgets/loading_indicator/loading_indicator_gym.dart';
import '../provider/shop_services_provider.dart';
import '../shop_add_service_screen/shop_add_service_screen.dart';
import '../widgets/shop_activewear_category_listview.dart';

class ShopServicesScreen extends StatefulWidget {
  final DepartmentModel? departmentModel;

  const ShopServicesScreen({super.key, this.departmentModel});

  @override
  State<ShopServicesScreen> createState() => _ShopServicesScreenState();
}

class _ShopServicesScreenState extends State<ShopServicesScreen> {
  ProfileProvider profileProvider = getIt();
  ShopServicesProvider shopServicesProvider = getIt();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      shopServicesProvider.init(widget.departmentModel);

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 12,
          ),
          if (profileProvider.getUserModel() != null &&
              profileProvider.getUserModel()!.providerModel != null &&
              profileProvider.getUserModel()!.providerModel!.mainAccount !=
                  null &&
              profileProvider
                      .getUserModel()!
                      .providerModel!
                      .mainAccount!
                      .shop_categories
                      .length > 1)
            Consumer<ShopServicesProvider>(
              builder: (context,provider,_) {
                return ShopCategoryWidget(
                  model: widget.departmentModel,
                  onIndexChanged: (int index) {
                    shopServicesProvider.updateSelectedShopCategory(index, widget.departmentModel);
                  }, list: provider.shopCategoryList, defaultIndex:provider.selectedShopCategoryIndex,
                );
              }
            ),
          const SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
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
                      CustomScaffoldMessanger.showScaffoledMessanger(title: 'Complete your information to verify the account'.tr());
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
          ),
          const SizedBox(
            height: 12,
          ),
          SizedBox(
            height: 42,
            child:
                Consumer<ShopServicesProvider>(builder: (context, provider, _) {
              return ScrollablePositionedList.builder(
                  itemScrollController:
                  provider.shopServiceDepartmentItemController,
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
                  });
            }),
          ),
          Expanded(
            child:
                Consumer<ShopServicesProvider>(builder: (context, provider, _) {
              return provider.isLoading
                  ? const Padding(
                      padding: EdgeInsets.only(bottom: 64.0),
                      child: LoadingIndicatorGym(),
                    )
                  :provider.services.isNotEmpty?
              provider.shopCategoryList[provider.selectedShopCategoryIndex].category_id==1?
              ShopActivewearCategoryListView(list: provider.services,):
              ShopOtherCategoryListView(list: provider.services,):
              Center(child: CustomText(title: 'Sorry! no services to show....'.tr(),fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,),)
              ;
            }),
          ),
          const SizedBox(height: 12,),
          Center(
              child: CustomButton(
                title: '+ Add a new service'.tr(),
                onTap: () {
                  ProfileProvider profileProvider = getIt();
                  if (profileProvider.isAccountProviderCompleted()) {
                    ShopServicesProvider shopServiceProvider = getIt();
                    NavigatorHandler.push( ShopAddService(shopDepartmentModel: shopServiceProvider.shopCategoryList.isEmpty?null:shopServicesProvider.shopCategoryList[shopServiceProvider.selectedShopCategoryIndex].category,));
                  } else {
                    CustomScaffoldMessanger.showScaffoledMessanger(title: 'Complete your information to verify the account'.tr());
                  }
                },
                width: Dimens.width *.6,
                height: 48,
              )),
          const SizedBox(
            height: 12,
          )
        ],
      ),
    );
  }

  void showAddDepartmentSheet(DepartmentModel? departmentModel, int? index) {
    TextEditingController controller = TextEditingController();
    if (departmentModel != null) {
      controller.text = departmentModel.title ?? '';
    }
    String deptTitle = '';
    if(shopServicesProvider.shopCategoryList.isNotEmpty  ){
      if(shopServicesProvider.shopCategoryList[shopServicesProvider.selectedShopCategoryIndex].category?.title =='supplement'){
        deptTitle = 'Supplements'.tr();
      }else if(shopServicesProvider.shopCategoryList[shopServicesProvider.selectedShopCategoryIndex].category?.title =='activewear'){
        deptTitle = 'Activewaers'.tr();
      }
      else if(shopServicesProvider.shopCategoryList[shopServicesProvider.selectedShopCategoryIndex].category?.title =='equipment'){
        deptTitle = 'Equipments'.tr();
      }
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
                    Text.rich(
                      TextSpan(
                          text: departmentModel == null
                              ? 'Add category'.tr()
                              : 'Update category'.tr(),
                          children: [
                            TextSpan(
                              text: '( $deptTitle )',
                              style: AppTextStyles()
                                  .normalText(fontSize: 13)
                                  .textColorNormal(AppTheme.isDarkMode()
                                      ? Colors.white
                                      : Colors.black),
                            )
                          ]),
                      style: AppTextStyles()
                          .normalText(fontSize: 18)
                          .textColorBold(AppTheme.isDarkMode()
                              ? Colors.white
                              : Colors.black),
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
                          shopServicesProvider.addDepartment(name);
                        } else {
                          shopServicesProvider.updateDepartment(departmentModel,name,index);

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
                        shopServicesProvider.deleteDepartment(model);
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
