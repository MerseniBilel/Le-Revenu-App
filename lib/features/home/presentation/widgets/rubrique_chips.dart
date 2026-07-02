import 'package:flutter/material.dart';

import '../../../../core/shared/widgets/app_chip.dart';
import '../../domain/entities/news_category.dart';

/// Horizontal list of rubrique chips.
///
/// The selected chip is kept visible automatically: when the scroll-spy
/// changes the selection, the list scrolls to reveal it.
class RubriqueChips extends StatefulWidget {
  const RubriqueChips({
    required this.rubriques,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final List<NewsCategory> rubriques;
  final NewsCategory? selected;
  final ValueChanged<NewsCategory> onSelected;

  @override
  State<RubriqueChips> createState() => _RubriqueChipsState();
}

class _RubriqueChipsState extends State<RubriqueChips> {
  late final Map<NewsCategory, GlobalKey> _chipKeys = {
    for (final rubrique in widget.rubriques) rubrique: GlobalKey(),
  };

  @override
  void didUpdateWidget(RubriqueChips oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selected != oldWidget.selected) _revealSelected();
  }

  void _revealSelected() {
    final context = _chipKeys[widget.selected]?.currentContext;
    if (context == null) return;
    Scrollable.ensureVisible(
      context,
      alignment: .5,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      children: [
        for (final rubrique in widget.rubriques) ...[
          AppChip(
            key: _chipKeys[rubrique],
            label: rubrique.label,
            selected: rubrique == widget.selected,
            onTap: () => widget.onSelected(rubrique),
          ),
          if (rubrique != widget.rubriques.last) const SizedBox(width: 8),
        ],
      ],
    ),
  );
}
