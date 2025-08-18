import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/core/dimens/dimens.dart';
import 'package:gymatvendor/core/navigator/navigator.dart';
import 'package:gymatvendor/data/models/main_category_model.dart';
import 'package:gymatvendor/injection.dart';
import 'package:gymatvendor/presentations/auth_module/gender_screen/gender_screen.dart';
import 'package:gymatvendor/presentations/auth_module/provider/auth_provider.dart';
import 'package:gymatvendor/presentations/auth_module/user_type_screen/widgets/user_type_button_widget.dart';
import 'package:gymatvendor/presentations/widgets/custom_asset_image/custom_asset_image.dart';
import 'package:gymatvendor/presentations/widgets/custom_button/custom_button.dart';
import 'package:gymatvendor/presentations/widgets/custom_svg/CustomSvgIcon.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';
import 'package:gymatvendor/presentations/widgets/dialogs/scaffold_messanger.dart';
import 'package:provider/provider.dart';

import '../../widgets/custom_app_bar/custom_app_bar.dart';
import '../../widgets/loading_indicator/loading_indicator.dart';

class UserTypeScreen extends StatefulWidget {
  const UserTypeScreen({super.key});

  @override
  State<UserTypeScreen> createState() => _UserTypeScreenState();
}

class _UserTypeScreenState extends State<UserTypeScreen> {
  AuthProvider authProvider = getIt();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authProvider.initUserType();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      authProvider.getMainCategories();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const CustomAppBar(
        showToolBar: true,
        showBackArrow: true,
        isMainBack: true,
      ),
      body: Stack(
        children: [
          CustomAssetImage(
            assetName: AppTheme.isDarkMode()
                ? 'user_type_bg_dark'
                : 'user_type_bg_white',
            width: Dimens.width,
            height: Dimens.height,
          ),
          Consumer<AuthProvider>(builder: (context,provider,_){
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 36,
                  ),
                  Center(
                      child: CustomSvgIcon(
                        assetName: 'logo_fav',
                        width: 95,
                        height: 54,
                        color: AppTheme.isDarkMode() ? Colors.white : mainColor,
                      )),
                  SizedBox(
                    height: Dimens.height * .05,
                  ),
                  !provider.isLoadingCategory?Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: CustomText(
                      title: 'GET STARTED AS'.tr(),
                      fontSize: 22,
                      fontColor: AppTheme.isDarkMode() ? Colors.white : Colors.black,
                      textAlign: TextAlign.center,
                    ),
                  ):const SizedBox(),
                  const SizedBox(height: 16,),

                  ListView.builder(
                    shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: provider.categories.length,
                      itemBuilder: (context,index){
                      MainCategoryModel model = provider.categories[index];

                    return UserTypeButtonWidget(title:model.title??'', onTap: () {
                      provider.addRemoveUserType(model);
                    }, selected: provider.userType.contains(model),);
                  }),

                  SizedBox(height: !provider.isLoadingCategory?16:0,),
                  !provider.isLoadingCategory&&provider.categories.isNotEmpty?Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: CustomButton(title: 'Next'.tr(), onTap: (){
                      if(provider.userType.isNotEmpty){
                        NavigatorHandler.push(const GenderScreen());
                      }else{
                        CustomScaffoldMessanger.showToast(title: 'Select at least 1 user type'.tr());
                      }
                    }),
                  ):const SizedBox(),
                  const SizedBox(height: 16,),

                ],
              ),
            );
          }),
          Consumer<AuthProvider>(builder: (context,provider,_){
            return provider.isLoadingCategory?const LoadingIndicator():const SizedBox();
          }),

        ],
      ),
    );
  }
}
