import 'package:flutter/material.dart';

import '../../extensions/context.dart';

/// Description of one destination of [AppBottomNav].
class AppBottomNavItem {
  const AppBottomNavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

/// Minimal bottom navigation bar matching the Le Revenu design language
/// (hairline top border, tinted active destination).
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    required this.items,
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final List<AppBottomNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: context.card,
      border: Border(top: BorderSide(color: context.fieldStroke, width: .5)),
    ),
    child: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 8, left: 8, right: 8),
        child: Row(
          children: [
            for (var i = 0; i < items.length; i++)
              Expanded(
                child: _NavDestination(
                  item: items[i],
                  selected: i == currentIndex,
                  onTap: () => onTap(i),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

class _NavDestination extends StatelessWidget {
  const _NavDestination({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final AppBottomNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? context.primary : context.fieldPlaceholder;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(item.icon, size: 22, color: color),
          const SizedBox(height: 3),
          Text(
            item.label,
            style: context.h7.copyWith(
              fontSize: 11,
              color: color,
              fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
