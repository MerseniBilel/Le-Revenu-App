import '../router/routes_export.dart';

extension ThemeContext on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get text => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;

  Color get primary => colorScheme.primary;
  Color get paragraph => colorScheme.secondary;
  Color get heading => colorScheme.tertiary;

  /// fontSize 30px
  TextStyle get h1 => text.displayLarge!; // 30
  /// fontSize 24px
  TextStyle get h2 => text.displayMedium!; // 24
  /// fontSize 20px
  TextStyle get h3 => text.displaySmall!; // 20
  /// fontSize 16px
  TextStyle get h4 => text.headlineLarge!; // 16
  /// fontSize 14px
  TextStyle get h5 => text.headlineMedium!; // 14
  /// fontSize isMobile ? 12px : 14px
  TextStyle get h6 => text.headlineSmall!; // isMobile ? 12 : 14
  /// fontSize 12px
  TextStyle get h7 => text.titleLarge!; // 12

  // colors

  Color get fieldStroke => colorScheme.tertiaryFixed;
  Color get fieldPlaceholder => colorScheme.tertiaryFixedDim;
  Color get field => colorScheme.tertiaryContainer;
  Color get card => colorScheme.secondaryContainer;
  Color get error => colorScheme.error;
}
