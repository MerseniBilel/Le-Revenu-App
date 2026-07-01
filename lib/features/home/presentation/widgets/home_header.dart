import 'package:flutter/material.dart';

import '../../../../core/extensions/context.dart';
import '../../../../core/extensions/date_time.dart';

/// Masthead of the home page: current date, brand title and quick actions.
///
/// A long press on the brand title toggles light/dark theme.
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    this.onSearchTap,
    this.onNotificationsTap,
    this.onBrandLongPress,
  });

  final VoidCallback? onSearchTap;
  final VoidCallback? onNotificationsTap;
  final VoidCallback? onBrandLongPress;

  @override
  Widget build(BuildContext context) => DecoratedBox(
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
          GestureDetector(
            onLongPress: onBrandLongPress,
            child: Column(
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
                  icon: Icons.notifications_none_rounded,
                  tooltip: 'Notifications',
                  onTap: onNotificationsTap,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
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
