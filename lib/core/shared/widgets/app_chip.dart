import 'package:flutter/material.dart';

import '../../extensions/context.dart';

/// Rounded selectable chip, used for the rubrique filters.
class AppChip extends StatelessWidget {
  const AppChip({
    required this.label,
    super.key,
    this.selected = false,
    this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: selected ? context.primary : context.card,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: selected ? context.primary : context.fieldStroke,
          width: .5,
        ),
      ),
      child: Text(
        label,
        style: context.h6.copyWith(
          fontSize: 13,
          color: selected ? context.colorScheme.onPrimary : context.paragraph,
        ),
      ),
    ),
  );
}
