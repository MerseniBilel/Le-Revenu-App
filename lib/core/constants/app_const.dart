import 'package:sizer/sizer.dart';

class AppConst {
  const AppConst._();

  //Release error message
  static const String serverFailureMessage = "please try again later";
  static const String offLineFailureMessage = "please check your Internet";
  static const String unexpectedErrorMessage =
      "Unexpected error please try again later";

  // check is mobile
  static bool isMobile = Device.screenType == ScreenType.mobile;
}
