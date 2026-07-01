import 'package:flutter/material.dart';

import '../../extensions/context.dart';

/// Section title with an optional trailing action ("Tout voir").
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,
    super.key,
    this.actionLabel,
    this.onActionTap,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: context.h5.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: context.heading,
        ),
      ),
      if (actionLabel != null)
        GestureDetector(
          onTap: onActionTap,
          child: Text(
            actionLabel!,
            style: context.h7.copyWith(color: context.primary),
          ),
        ),
    ],
  );
}
