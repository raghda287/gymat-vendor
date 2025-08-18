import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/utils/preferences.dart';

class AppTheme {
  static bool isDarkMode() {
    Preferences preferences = Preferences();
    return preferences.isDarkMode();
  }

  static ThemeData theme(BuildContext context) {
    return ThemeData(
        brightness: isDarkMode() ? Brightness.dark : Brightness.light,
        primaryColor: isDarkMode() ? bodyBg : mainColor,
        scaffoldBackgroundColor: isDarkMode() ? Colors.black : Colors.white,
        primaryColorDark: mainColor,
        checkboxTheme: CheckboxThemeData(side: BorderSide(color: AppTheme.isDarkMode()?Colors.white:greyColor,)),
        bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: AppTheme.isDarkMode()?Colors.black:Colors.white,surfaceTintColor: Colors.transparent),
        textSelectionTheme: const TextSelectionThemeData(cursorColor: mainColor,selectionColor: mainColor,selectionHandleColor: mainColor),
        cardColor: isDarkMode() ? cardDark : Colors.white,

        toggleButtonsTheme: const ToggleButtonsThemeData(
            color: mainColor,
            selectedColor: mainColor,
            disabledColor: greyColor));
  }
}
