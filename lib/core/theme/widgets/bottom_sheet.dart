import '../../gen/colors.gen.dart';
import '../../router/routes_export.dart';

class LerevenuBottomSheetTheme {
  LerevenuBottomSheetTheme._();

  static final lightBottomSheetTheme = BottomSheetThemeData(
    backgroundColor: Colors.white,
    modalBackgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
    ),
  );

  static final darkBottomSheetTheme = BottomSheetThemeData(
    backgroundColor: AppColors.darkscaffoldBackgroundColor,
    modalBackgroundColor: AppColors.darkscaffoldBackgroundColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
    ),
  );
}
