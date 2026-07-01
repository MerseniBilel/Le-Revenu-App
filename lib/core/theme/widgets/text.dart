import 'package:flutter/material.dart';

import '../../constants/app_const.dart';

class LerevenuTextTheme {
  LerevenuTextTheme._();

  static final TextTheme lightTextTheme = TextTheme(
    displayLarge: TextStyle().copyWith(fontSize: AppConst.isMobile ? 30 : 40),
    displayMedium: TextStyle().copyWith(fontSize: AppConst.isMobile ? 24 : 32),
    displaySmall: TextStyle().copyWith(fontSize: AppConst.isMobile ? 20 : 24),
    headlineLarge: TextStyle().copyWith(fontSize: AppConst.isMobile ? 16 : 20),
    headlineMedium: TextStyle().copyWith(fontSize: AppConst.isMobile ? 14 : 16),
    headlineSmall: TextStyle().copyWith(fontSize: AppConst.isMobile ? 12 : 14),
    titleLarge: TextStyle().copyWith(fontSize: AppConst.isMobile ? 12 : 12),
  );

  static final TextTheme darkTextTheme = TextTheme(
    displayLarge: TextStyle().copyWith(fontSize: AppConst.isMobile ? 30 : 40),
    displayMedium: TextStyle().copyWith(fontSize: AppConst.isMobile ? 24 : 32),
    displaySmall: TextStyle().copyWith(fontSize: AppConst.isMobile ? 20 : 24),
    headlineLarge: TextStyle().copyWith(fontSize: AppConst.isMobile ? 16 : 20),
    headlineMedium: TextStyle().copyWith(fontSize: AppConst.isMobile ? 14 : 16),
    headlineSmall: TextStyle().copyWith(fontSize: AppConst.isMobile ? 12 : 14),
    titleLarge: TextStyle().copyWith(fontSize: AppConst.isMobile ? 12 : 12),
  );
}
