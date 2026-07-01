import 'package:flutter/material.dart';

import '../../gen/colors.gen.dart';

class LerevenuColorsTheme {
  LerevenuColorsTheme._();

  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    // primary
    primary: AppColors.primary,
    onPrimary: Colors.white,
    // secondary
    secondary: AppColors.secondary,
    onSecondary: Colors.white,
    //errors color
    error: AppColors.red,
    onError: Colors.white,
    //background like scaffold
    surface: AppColors.scaffoldBackgroundColor,
    onSurface: Color(0xFF241E30),
    //other colors
    tertiary: AppColors.heading,
    tertiaryFixed: AppColors.fieldStroke,
    tertiaryFixedDim: AppColors.fieldPlaceholder,
    tertiaryContainer: AppColors.field,
    secondaryContainer: AppColors.card,
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    // primary
    primary: AppColors.darkprimary,
    onPrimary: Colors.black,
    // secondary
    secondary: AppColors.darksecondary,
    onSecondary: Colors.black,
    //errors color
    error: AppColors.red,
    onError: Colors.white,
    //background like scaffold
    surface: AppColors.darkscaffoldBackgroundColor,
    onSurface: Colors.white,
    //other colors
    tertiary: AppColors.darkheading,
    tertiaryFixed: AppColors.darkfieldStroke,
    tertiaryFixedDim: AppColors.darkfieldPlaceholder,
    tertiaryContainer: AppColors.darkfield,
    secondaryContainer: AppColors.darkcard,
  );
}
