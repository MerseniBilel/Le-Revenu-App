import 'package:flutter/material.dart';

import '../../extensions/context.dart';

/// Small uppercase overline used to label a section or an article category.
class EyebrowText extends StatelessWidget {
  const EyebrowText(this.text, {super.key, this.color});

  final String text;

  /// Defaults to the brand color.
  final Color? color;

  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: context.h7.copyWith(
      fontSize: 11,
      letterSpacing: 1,
      fontWeight: FontWeight.w500,
      color: color ?? context.primary,
    ),
  );
}
