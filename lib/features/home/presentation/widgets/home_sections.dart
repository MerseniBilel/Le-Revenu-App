import 'package:flutter/material.dart';

import '../../../../core/shared/widgets/section_header.dart';
import '../../domain/entities/home_entities_export.dart';
import 'featured_section.dart';
import 'rubrique_chips.dart';
import 'rubriques_header.dart';
import 'videos_section.dart';

/// Everything shown above the news feed: à la une, the videos rail, then
/// the rubrique filters.
class HomeSections extends StatelessWidget {
  const HomeSections({
    required this.featured,
    required this.videos,
    required this.rubriques,
    required this.selectedRubrique,
    required this.onRubriqueSelected,
    super.key,
  });

  final Article featured;
  final List<VideoShort> videos;
  final List<NewsCategory> rubriques;
  final NewsCategory? selectedRubrique;
  final ValueChanged<NewsCategory?> onRubriqueSelected;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      FeaturedSection(article: featured),
      VideosSection(videos: videos),
      const RubriquesHeader(),
      RubriqueChips(
        rubriques: rubriques,
        selected: selectedRubrique,
        onSelected: onRubriqueSelected,
      ),
      const Padding(
        padding: EdgeInsets.fromLTRB(20, 18, 20, 6),
        child: SectionHeader(title: 'Dernières actualités'),
      ),
    ],
  );
}
