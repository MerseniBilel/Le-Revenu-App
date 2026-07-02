import 'package:flutter/material.dart';

import '../../../../core/extensions/snackbar.dart';
import '../../../../core/shared/widgets/hairline.dart';
import '../../domain/entities/home_entities_export.dart';
import 'article_tile.dart';

/// One row of the news feed: hairline + article tile.
///
/// The height is fixed (title clamped to two lines) so the scroll offset of
/// any article can be computed exactly, even when the row is not built yet
/// — which is what makes the chip → auto-scroll precise on a lazy list.
class ArticleListItem extends StatelessWidget {
  const ArticleListItem({required this.article, super.key});

  static const height = 107.0;

  final Article article;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: height,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const Hairline(),
          ArticleTile(
            article: article,
            onTap: () => context.showComingSoon("L'article"),
          ),
        ],
      ),
    ),
  );
}
