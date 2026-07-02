import 'package:flutter/material.dart';

import '../../../../core/extensions/context.dart';
import '../../../../core/extensions/date_time.dart';

/// Masthead of the home page: current date, brand title and quick actions
/// (search, light/dark theme switch).
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, this.onSearchTap, this.onThemeToggle});

  final VoidCallback? onSearchTap;
  final VoidCallback? onThemeToggle;

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: context.fieldStroke, width: .5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateTime.now().frenchHeaderDate,
                  style: context.h7.copyWith(
                    fontSize: 11,
                    letterSpacing: .5,
                    color: context.fieldPlaceholder,
                  ),
                ),
                Text(
                  'LE REVENU',
                  style: context.display.copyWith(
                    fontSize: 26,
                    letterSpacing: .6,
                    height: 1.1,
                    color: context.primary,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Row(
                children: [
                  _HeaderAction(
                    icon: Icons.search,
                    tooltip: 'Rechercher',
                    onTap: onSearchTap,
                  ),
                  const SizedBox(width: 14),
                  _HeaderAction(
                    icon: isDark
                        ? Icons.light_mode_outlined
                        : Icons.dark_mode_outlined,
                    tooltip: isDark ? 'Mode clair' : 'Mode sombre',
                    onTap: onThemeToggle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({required this.icon, required this.tooltip, this.onTap});

  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: tooltip,
    child: GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Icon(icon, size: 24, color: context.paragraph),
    ),
  );
}
