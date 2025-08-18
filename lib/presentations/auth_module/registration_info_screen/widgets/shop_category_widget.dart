import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/data/models/department_model.dart';
import 'package:gymatvendor/data/models/shop_category.dart';
import 'package:gymatvendor/injection.dart';
import 'package:gymatvendor/presentations/auth_module/provider/auth_provider.dart';
import 'package:gymatvendor/presentations/widgets/loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';

import '../../../../core/app_theme/theme.dart';
import '../../../widgets/custom_text/custom_text.dart';

//1 activewatr-2supplement equipment-3
enum SHOPCATEGORY { activewear, supplement, equipment }

class ShopCategoryWidget extends StatefulWidget {
  const ShopCategoryWidget({super.key});

  @override
  State<ShopCategoryWidget> createState() => _ShopCategoryWidgetState();
}

class _ShopCategoryWidgetState extends State<ShopCategoryWidget> {
  late List<String> selectedShopCategory;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedShopCategory = [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 12,
        ),
        CustomText(
          title: 'Shop categoris'.tr(),
          fontColor: AppTheme.isDarkMode() ? Colors.white : Colors.black,
        ),
        const SizedBox(
          height: 12,
        ),
        Consumer<AuthProvider>(builder: (context, provider, _) {
          return provider.isLoadingShopCategory
              ? const LoadingIndicator()
              : GridView.builder(
                  itemCount: provider.shopCategoryList.length,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      childAspectRatio: 2),
                  itemBuilder: (context, index) {
                    DepartmentModel model = provider.shopCategoryList[index];

                    return InkWell(
                      splashColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      onTap: () {
                        if (selectedShopCategory
                            .contains(model.id.toString())) {
                          selectedShopCategory.remove(model.id.toString());
                        } else {
                          selectedShopCategory.add(model.id.toString());
                        }
                        provider.updateShopCategories(selectedShopCategory);

                        setState(() {});
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: selectedShopCategory
                                    .contains(model.id.toString())
                                ? mainColor
                                : AppTheme.isDarkMode()
                                    ? inputBgDark
                                    : inputBg,
                            borderRadius: BorderRadius.circular(4)),
                        child: CustomText(
                            title: model.title,
                            fontColor: selectedShopCategory
                                    .contains(model.id.toString())
                                ? Colors.white
                                : AppTheme.isDarkMode()
                                    ? Colors.white
                                    : Colors.black,
                            fontSize: 12),
                      ),
                    );
                  });
        })
      ],
    );
  }
}
