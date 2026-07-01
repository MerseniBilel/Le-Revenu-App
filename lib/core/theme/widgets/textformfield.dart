import 'package:flutter/material.dart';

import '../../gen/colors.gen.dart';

class LerevenuTextFieldTheme {
  LerevenuTextFieldTheme._();

  static InputDecorationTheme lighInputDecorationTheme = InputDecorationTheme(
    fillColor: AppColors.field,
    filled: true,
    errorStyle: TextStyle(
      fontWeight: FontWeight.w600,
      color: AppColors.red,
      fontSize: 14,
    ),
    hintStyle: TextStyle(
      color: AppColors.fieldPlaceholder,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.fieldStroke, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.fieldStroke, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.fieldStroke, width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.fieldStroke, width: 1),
    ),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    fillColor: AppColors.darkfield,
    filled: true,
    errorStyle: TextStyle(
      fontWeight: FontWeight.w600,
      color: AppColors.red,
      fontSize: 14,
    ),
    hintStyle: TextStyle(
      color: AppColors.darkfieldPlaceholder,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.darkfieldStroke, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.darkfieldStroke, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.darkfieldStroke, width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.darkfieldStroke, width: 1),
    ),
  );
}
