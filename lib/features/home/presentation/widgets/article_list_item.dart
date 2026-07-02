import 'package:flutter/material.dart';

import '../../../../core/extensions/context.dart';
import '../../../../core/extensions/snackbar.dart';
import '../../../../core/shared/widgets/hairline.dart';
import '../../domain/entities/home_entities_export.dart';
import 'article_tile.dart';

/// One position of the news feed: an article row, the closing hairline
/// after the last row, or the "empty rubrique" message.
class ArticleListItem extends StatelessWidget {
  const ArticleListItem({
    required this.articles,
    required this.index,
    super.key,
  });

  final List<Article> articles;
  final int index;

  @override
  Widget build(BuildContext context) {
    if (articles.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
        child: Center(
          child: Text(
            'Aucun article dans cette rubrique pour le moment.',
            style: context.h6.copyWith(color: context.paragraph),
          ),
        ),
      );
    }
    if (index == articles.length) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Hairline(),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const Hairline(),
          ArticleTile(
            article: articles[index],
            onTap: () => context.showComingSoon("L'article"),
          ),
        ],
      ),
    );
  }
}
