import 'package:sizer/sizer.dart';

import '../router/routes_export.dart';

extension ConvertPxToPercent on num {
  SizedBox get bh => SizedBox(height: toDouble());
  SizedBox get bw => SizedBox(width: toDouble());

  // ConvertPxToPercent phone
  double get fh => ((this / 812) * 100).h;
  double get fw => ((this / 375) * 100).w;

  // ConvertPxToPercent tablet
  double get th => ((this / 1133) * 100).h;
  double get tw => ((this / 744) * 100).w;
}
