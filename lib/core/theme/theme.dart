import 'package:flutter/material.dart';
import 'package:lerevenu/core/theme/widgets/bottom_app_bar.dart';
import 'package:lerevenu/core/theme/widgets/drawer.dart';

import '../gen/colors.gen.dart';
import 'widgets/alertdialog.dart';
import 'widgets/bottom_sheet.dart';
import 'widgets/circle_indicator.dart';
import 'widgets/colors.dart';
import 'widgets/elevated_btn.dart';
import 'widgets/outlined_btn.dart';
import 'widgets/text.dart';
import 'widgets/textformfield.dart';

class LerevenuTheme {
  LerevenuTheme._();

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: false,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
    textTheme: LerevenuTextTheme.lightTextTheme,
    elevatedButtonTheme: LerevenuElevatedBtnTheme.lightElevatedBtnTheme,
    inputDecorationTheme: LerevenuTextFieldTheme.lighInputDecorationTheme,
    outlinedButtonTheme: LerevenuOutlinedBtnTheme.lightOutlinedBtnTheme,
    progressIndicatorTheme: LerevenuCircleIndicator.lightCircleIndicatorTheme,
    bottomSheetTheme: LerevenuBottomSheetTheme.lightBottomSheetTheme,
    dialogTheme: LerevenuAlertdialogTheme.lightAlertDialogTheme,
    colorScheme: LerevenuColorsTheme.lightColorScheme,
    bottomAppBarTheme: LerevenuBottomAppBarTheme.lightBottomNavBar,
    drawerTheme: LerevenuDrawerTheme.lightDrawerTheme,
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: false,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkscaffoldBackgroundColor,
    textTheme: LerevenuTextTheme.darkTextTheme,
    elevatedButtonTheme: LerevenuElevatedBtnTheme.darkElevatedBtnTheme,
    inputDecorationTheme: LerevenuTextFieldTheme.darkInputDecorationTheme,
    outlinedButtonTheme: LerevenuOutlinedBtnTheme.darkOutlinedBtnTheme,
    progressIndicatorTheme: LerevenuCircleIndicator.darkCircleIndicatorTheme,
    bottomSheetTheme: LerevenuBottomSheetTheme.darkBottomSheetTheme,
    dialogTheme: LerevenuAlertdialogTheme.darkAlertDialogTheme,
    colorScheme: LerevenuColorsTheme.darkColorScheme,
    bottomAppBarTheme: LerevenuBottomAppBarTheme.darkBottomNavBar,
    drawerTheme: LerevenuDrawerTheme.darkDrawerTheme,
  );
}
