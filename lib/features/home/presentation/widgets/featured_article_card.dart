import 'package:flutter/material.dart';

import '../../../../core/extensions/context.dart';
import '../../../../core/extensions/date_time.dart';
import '../../domain/entities/home_entities_export.dart';
import '../extensions/news_category_ui.dart';

/// Large hero card highlighting the main story ("À la une").
class FeaturedArticleCard extends StatelessWidget {
  const FeaturedArticleCard({required this.article, super.key, this.onTap});

  final Article article;
  final VoidCallback? onTap;

  // The hero panel is intentionally dark in both themes (editorial style).
  static const _panelColor = Color(0xFF17202E);
  static const _illustrationColor = Color(0xFF3A4658);
  static const _scrimColor = Color(0xB80A0E16);
  static const _metaColor = Color(0xFFC9CFDA);

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        height: 200,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const ColoredBox(color: _panelColor),
            Center(
              child: Icon(
                article.category.icon,
                size: 44,
                color: _illustrationColor,
              ),
            ),
            Positioned(
              top: 12,
              left: 12,
              child: _CategoryBadge(category: article.category),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ColoredBox(
                color: _scrimColor,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 16, 14, 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        article.title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: context.display.copyWith(
                          fontSize: 19,
                          height: 1.28,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        '${article.publishedAt.frenchTimeAgo} · '
                        '${article.readingMinutes} min de lecture',
                        style: context.h7.copyWith(
                          fontSize: 11,
                          color: _metaColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.category});

  final NewsCategory category;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: category.colorOf(context),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(
      category.label.toUpperCase(),
      style: context.h7.copyWith(
        fontSize: 11,
        letterSpacing: .7,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
    ),
  );
}
