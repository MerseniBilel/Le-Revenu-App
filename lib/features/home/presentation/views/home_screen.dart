import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/context.dart';
import '../../../../core/gen/injection.dart';
import '../../../../core/router/router.dart';
import '../../../../core/shared/theme_manager_cubit.dart';
import '../../../../core/shared/widgets/eyebrow_text.dart';
import '../../../../core/shared/widgets/section_header.dart';
import '../../domain/entities/home_entities_export.dart';
import '../cubit/home_cubit.dart';
import '../models/video_playlist.dart';
import '../widgets/article_tile.dart';
import '../widgets/featured_article_card.dart';
import '../widgets/home_header.dart';
import '../widgets/rubrique_chips.dart';
import '../widgets/video_shorts_rail.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<HomeCubit>()..load(),
    child: const _HomeView(),
  );
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Column(
        children: [
          HomeHeader(
            onSearchTap: () => _showComingSoon(context, 'La recherche'),
            onThemeToggle: context.read<ThemeCubit>().toggleTheme,
          ),
          Expanded(
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) => switch (state) {
                HomeLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
                HomeError(:final message) => _ErrorView(message: message),
                HomeLoaded() => _HomeContent(state: state),
              },
            ),
          ),
        ],
      ),
    ),
  );
}

/// Scrollable body of the page: one lazy [ListView.builder] where the first
/// indices are the page sections and the rest is the (filtered) news feed.
class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.state});

  final HomeLoaded state;

  static const _featuredIndex = 0;
  static const _rubriquesHeaderIndex = 1;
  static const _chipsIndex = 2;
  static const _videosIndex = 3;
  static const _latestHeaderIndex = 4;
  static const _sectionCount = 5;

  @override
  Widget build(BuildContext context) {
    final articles = state.visibleArticles;
    // Articles + a closing hairline (or a single "empty" message).
    final articleItemCount = articles.isEmpty ? 1 : articles.length + 1;

    return RefreshIndicator(
      onRefresh: context.read<HomeCubit>().refresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.only(bottom: 24),
        itemCount: _sectionCount + articleItemCount,
        itemBuilder: (context, index) => switch (index) {
          _featuredIndex => _FeaturedSection(article: state.content.featured),
          _rubriquesHeaderIndex => const _RubriquesHeader(),
          _chipsIndex => _RubriqueFilters(
            rubriques: state.rubriques,
            selected: state.selectedRubrique,
          ),
          _videosIndex => _VideosSection(videos: state.content.videoShorts),
          _latestHeaderIndex => const Padding(
            padding: EdgeInsets.fromLTRB(20, 18, 20, 6),
            child: SectionHeader(title: 'Dernières actualités'),
          ),
          _ => _ArticleListItem(
            articles: articles,
            index: index - _sectionCount,
          ),
        },
      ),
    );
  }
}

/// "À la une": eyebrow + hero card.
class _FeaturedSection extends StatelessWidget {
  const _FeaturedSection({required this.article});

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
          onTap: () => _showComingSoon(context, "L'article"),
        ),
      ],
    ),
  );
}

class _RubriquesHeader extends StatelessWidget {
  const _RubriquesHeader();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
    child: SectionHeader(
      title: 'Rubriques',
      actionLabel: 'Tout voir',
      onActionTap: () => _showComingSoon(context, 'Cette section'),
    ),
  );
}

class _RubriqueFilters extends StatelessWidget {
  const _RubriqueFilters({required this.rubriques, required this.selected});

  final List<NewsCategory> rubriques;
  final NewsCategory? selected;

  @override
  Widget build(BuildContext context) => RubriqueChips(
    rubriques: rubriques,
    selected: selected,
    onSelected: context.read<HomeCubit>().selectRubrique,
  );
}

class _VideosSection extends StatelessWidget {
  const _VideosSection({required this.videos});

  final List<VideoShort> videos;

  @override
  Widget build(BuildContext context) {
    if (videos.isEmpty) return const SizedBox.shrink();
    return VideoShortsRail(
      videos: videos,
      onVideoTap: (video) => VideoShortRoute(
        VideoPlaylist(videos: videos, initialIndex: videos.indexOf(video)),
      ).push<void>(context),
    );
  }
}

/// One position of the news feed: an article row, the closing hairline
/// after the last row, or the "empty rubrique" message.
class _ArticleListItem extends StatelessWidget {
  const _ArticleListItem({required this.articles, required this.index});

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
        child: _Hairline(),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const _Hairline(),
          ArticleTile(
            article: articles[index],
            onTap: () => _showComingSoon(context, "L'article"),
          ),
        ],
      ),
    );
  }
}

class _Hairline extends StatelessWidget {
  const _Hairline();

  @override
  Widget build(BuildContext context) =>
      Divider(height: .5, thickness: .5, color: context.fieldStroke);
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wifi_off_rounded, size: 32, color: context.paragraph),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: context.h6.copyWith(color: context.paragraph),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: context.read<HomeCubit>().load,
            child: const Text('Réessayer'),
          ),
        ],
      ),
    ),
  );
}

void _showComingSoon(BuildContext context, String subject) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text('$subject arrive bientôt.'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1400),
      ),
    );
}
