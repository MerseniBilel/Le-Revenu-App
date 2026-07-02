import 'package:flutter/material.dart';

import '../../../../core/shared/widgets/app_chip.dart';
import '../../domain/entities/news_category.dart';

/// Horizontal list of rubrique filters. `null` stands for "Tous".
class RubriqueChips extends StatelessWidget {
  const RubriqueChips({
    required this.rubriques,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final List<NewsCategory> rubriques;
  final NewsCategory? selected;
  final ValueChanged<NewsCategory?> onSelected;

  @override
  Widget build(BuildContext context) {
    final filters = [null, ...rubriques];
    return SizedBox(
      height: 34,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, index) {
          final rubrique = filters[index];
          return AppChip(
            label: rubrique?.label ?? 'Tous',
            selected: rubrique == selected,
            onTap: () => onSelected(rubrique),
          );
        },
      ),
    );
  }
}
