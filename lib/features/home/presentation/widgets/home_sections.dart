import 'package:flutter/material.dart';

import '../../../../core/shared/widgets/section_header.dart';
import '../../domain/entities/home_entities_export.dart';
import 'featured_section.dart';
import 'rubrique_chips.dart';
import 'rubriques_header.dart';
import 'videos_section.dart';

/// Everything shown above the news feed, as plain (non-lazy) widgets:
/// à la une, rubrique chips and the videos rail.
class HomeSections extends StatelessWidget {
  const HomeSections({
    required this.featured,
    required this.videos,
    required this.rubriques,
    required this.selectedRubrique,
    required this.onRubriqueTap,
    super.key,
  });

  final Article featured;
  final List<VideoShort> videos;
  final List<NewsCategory> rubriques;
  final NewsCategory? selectedRubrique;
  final ValueChanged<NewsCategory> onRubriqueTap;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      FeaturedSection(article: featured),
      const RubriquesHeader(),
      RubriqueChips(
        rubriques: rubriques,
        selected: selectedRubrique,
        onSelected: onRubriqueTap,
      ),
      VideosSection(videos: videos),
      const Padding(
        padding: EdgeInsets.fromLTRB(20, 18, 20, 6),
        child: SectionHeader(title: 'Dernières actualités'),
      ),
    ],
  );
}
