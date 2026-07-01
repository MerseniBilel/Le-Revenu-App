import 'package:flutter/material.dart';

import '../../constants/app_const.dart';
import '../../extensions/num.dart';
import '../../gen/colors.gen.dart';

class LerevenuElevatedBtnTheme {
  LerevenuElevatedBtnTheme._();

  static final lightElevatedBtnTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 0,
      textStyle: TextStyle(
        fontWeight: FontWeight.w600,
        color: Colors.white,
        fontSize: AppConst.isMobile ? 16 : 20,
      ),
      minimumSize: Size(double.infinity, AppConst.isMobile ? 56.fh : 74.th),
      disabledBackgroundColor: AppColors.primary.withValues(alpha: .5),
      disabledForegroundColor: Colors.white,
    ),
  );

  static final darkElevatedBtnTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.darkprimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 0,
      foregroundColor: Colors.white,
      textStyle: TextStyle(
        fontWeight: FontWeight.w600,
        color: Colors.white,
        fontSize: AppConst.isMobile ? 16 : 20,
      ),
      minimumSize: Size(double.infinity, AppConst.isMobile ? 56.fh : 74.th),
      disabledBackgroundColor: Colors.grey,
      disabledForegroundColor: Colors.white,
    ),
  );
}
