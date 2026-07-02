import 'package:flutter/material.dart';

import '../../../../core/extensions/snackbar.dart';
import '../../../../core/shared/widgets/hairline.dart';
import '../../domain/entities/home_entities_export.dart';
import 'article_tile.dart';

/// One row of the news feed: hairline + article tile.
class ArticleListItem extends StatelessWidget {
  const ArticleListItem({required this.article, super.key});

  final Article article;

  @override
  Widget build(BuildContext context) => Padding(
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
  );
}
