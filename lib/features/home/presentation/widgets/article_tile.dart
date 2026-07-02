import 'package:flutter/material.dart';

import '../../../../core/extensions/context.dart';
import '../../../../core/extensions/date_time.dart';
import '../../../../core/shared/widgets/eyebrow_text.dart';
import '../../domain/entities/home_entities_export.dart';
import '../extensions/news_category_ui.dart';

/// Compact row for the "Dernières actualités" list: category, title, meta
/// and a colored thumbnail standing in for the article image.
class ArticleTile extends StatelessWidget {
  const ArticleTile({required this.article, super.key, this.onTap});

  final Article article;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    behavior: HitTestBehavior.opaque,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EyebrowText(article.category.label),
                const SizedBox(height: 4),
                Text(
                  article.title,
                  // Two lines max keeps every row the same height, which
                  // the chip auto-scroll relies on (ArticleListItem.height).
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.h5.copyWith(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                    height: 1.32,
                    color: context.heading,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${article.publishedAt.frenchTimeAgo} · '
                  '${article.readingMinutes} min',
                  style: context.h7.copyWith(
                    fontSize: 11,
                    color: context.fieldPlaceholder,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          _ArticleThumbnail(category: article.category),
        ],
      ),
    ),
  );
}

class _ArticleThumbnail extends StatelessWidget {
  const _ArticleThumbnail({required this.category});

  final NewsCategory category;

  @override
  Widget build(BuildContext context) {
    final background = category.colorOf(context);
    final foreground =
        ThemeData.estimateBrightnessForColor(background) == Brightness.dark
        ? Colors.white.withValues(alpha: .92)
        : Colors.black.withValues(alpha: .65);
    return Container(
      width: 78,
      height: 78,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(category.icon, size: 26, color: foreground),
    );
  }
}
