import 'package:flutter/material.dart';

import '../../../../core/extensions/snackbar.dart';
import '../../../../core/shared/widgets/eyebrow_text.dart';
import '../../domain/entities/home_entities_export.dart';
import 'featured_article_card.dart';

/// "À la une": eyebrow + hero card.
class FeaturedSection extends StatelessWidget {
  const FeaturedSection({required this.article, super.key});

  final Article article;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const EyebrowText('À la une'),
        const SizedBox(height: 8),
        FeaturedArticleCard(
          article: article,
          onTap: () => context.showComingSoon("L'article"),
        ),
      ],
    ),
  );
}
