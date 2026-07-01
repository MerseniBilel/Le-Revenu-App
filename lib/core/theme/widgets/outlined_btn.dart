import 'package:flutter/material.dart';

import '../../constants/app_const.dart';
import '../../extensions/num.dart';
import '../../gen/colors.gen.dart';

class LerevenuOutlinedBtnTheme {
  LerevenuOutlinedBtnTheme._();

  static final lightOutlinedBtnTheme = OutlinedButtonThemeData(
    style: ElevatedButton.styleFrom(
      textStyle: TextStyle(
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
        fontSize: AppConst.isMobile ? 16 : 20,
      ),
      minimumSize: Size(double.infinity, AppConst.isMobile ? 56.fh : 74.th),
      foregroundColor: AppColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: AppColors.primary, width: 1),
      ),
      side: BorderSide(color: AppColors.primary, width: 1),
    ),
  );

  static final darkOutlinedBtnTheme = OutlinedButtonThemeData(
    style: ElevatedButton.styleFrom(
      textStyle: TextStyle(
        fontWeight: FontWeight.w600,
        color: AppColors.darkprimary,
        fontSize: AppConst.isMobile ? 16 : 20,
      ),
      minimumSize: Size(double.infinity, AppConst.isMobile ? 56.fh : 74.th),
      foregroundColor: AppColors.darkprimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: AppColors.darkprimary, width: 1),
      ),
      side: BorderSide(color: AppColors.darkprimary, width: 1),
    ),
  );
}
