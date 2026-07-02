import 'package:flutter/material.dart';

import '../../extensions/context.dart';

/// Hairline divider matching the design language (0.5 px stroke).
class Hairline extends StatelessWidget {
  const Hairline({super.key});

  @override
  Widget build(BuildContext context) =>
      Divider(height: .5, thickness: .5, color: context.fieldStroke);
}
