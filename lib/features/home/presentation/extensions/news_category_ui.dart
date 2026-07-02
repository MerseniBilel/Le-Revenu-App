import 'package:flutter/material.dart';

import '../../../../core/gen/colors.gen.dart';
import '../../domain/entities/news_category.dart';

/// UI attributes of a [NewsCategory] (colors, icon).
///
/// Kept in the presentation layer so the domain stays free of Flutter.
extension NewsCategoryUi on NewsCategory {
  /// Illustration icon, used as a placeholder for article images.
  IconData get icon => switch (this) {
    NewsCategory.bourse => Icons.candlestick_chart_outlined,
    NewsCategory.immobilier => Icons.apartment_outlined,
    NewsCategory.placements => Icons.savings_outlined,
    NewsCategory.fiscalite => Icons.receipt_long_outlined,
    NewsCategory.assurance => Icons.health_and_safety_outlined,
    NewsCategory.retraite => Icons.beach_access_outlined,
  };

  /// Dark tinted panel behind a video thumbnail (same in both themes,
  /// like the hero card — editorial style).
  Color get videoPanelColor => switch (this) {
    NewsCategory.bourse => const Color(0xFF1E2A3A),
    NewsCategory.immobilier => const Color(0xFF3A2E28),
    NewsCategory.placements => const Color(0xFF2A2440),
    NewsCategory.fiscalite => const Color(0xFF24303A),
    NewsCategory.assurance => const Color(0xFF3A2430),
    NewsCategory.retraite => const Color(0xFF2A2634),
  };

  /// Identity color of the rubrique, adapted to the current brightness.
  Color colorOf(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return switch (this) {
      NewsCategory.bourse => isDark ? AppColors.darkbourse : AppColors.bourse,
      NewsCategory.immobilier =>
        isDark ? AppColors.darkimmobilier : AppColors.immobilier,
      NewsCategory.placements =>
        isDark ? AppColors.darkplacements : AppColors.placements,
      NewsCategory.fiscalite =>
        isDark ? AppColors.darkfiscalite : AppColors.fiscalite,
      NewsCategory.assurance =>
        isDark ? AppColors.darkassurance : AppColors.assurance,
      NewsCategory.retraite =>
        isDark ? AppColors.darkretraite : AppColors.retraite,
    };
  }
}
