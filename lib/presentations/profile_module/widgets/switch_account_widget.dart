import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/core/dimens/dimens.dart';
import 'package:gymatvendor/presentations/profile_module/widgets/choose_main_account_widget.dart';
import 'package:provider/provider.dart';

import '../../../theme_provider.dart';

class SwitchAccountWidget extends StatelessWidget {
  const SwitchAccountWidget({super.key});

  @override
  Widget build(BuildContext context) {
     return Consumer<ThemeProvider>(builder: (context, provider, _) {
      return InkWell(
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        onTap: (){
          showAccountsSheet(context);
        },
        child: Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),border: Border.all(color: AppTheme.isDarkMode()?Colors.white.withOpacity(.5):greyColor.withOpacity(.4))),
          child:  Icon(Icons.keyboard_arrow_down_rounded,size: 16,color: AppTheme.isDarkMode()?Colors.white:greyColor.withOpacity(.8),),
        ),
      );
    });
  }

  void showAccountsSheet(BuildContext context) {
    showModalBottomSheet(
        isDismissible: false,
        backgroundColor: AppTheme.isDarkMode()?dark:Colors.white,
        context: context, builder: (context){
          return SizedBox(
              width: Dimens.width,
              child: const ChooseMainAccountWidget());

    });
  }
}
