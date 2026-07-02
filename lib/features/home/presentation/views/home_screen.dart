import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/snackbar.dart';
import '../../../../core/gen/injection.dart';
import '../../../../core/shared/theme_manager_cubit.dart';
import '../../../../core/shared/widgets/section_header.dart';
import '../cubit/home_cubit.dart';
import '../widgets/article_list_item.dart';
import '../widgets/featured_section.dart';
import '../widgets/home_error_view.dart';
import '../widgets/home_header.dart';
import '../widgets/rubrique_filters.dart';
import '../widgets/rubriques_header.dart';
import '../widgets/videos_section.dart';

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
            onSearchTap: () => context.showComingSoon('La recherche'),
            onThemeToggle: context.read<ThemeCubit>().toggleTheme,
          ),
          Expanded(
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) => switch (state) {
                HomeLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
                HomeError(:final message) => HomeErrorView(message: message),
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
          _featuredIndex => FeaturedSection(article: state.content.featured),
          _rubriquesHeaderIndex => const RubriquesHeader(),
          _chipsIndex => RubriqueFilters(
            rubriques: state.rubriques,
            selected: state.selectedRubrique,
          ),
          _videosIndex => VideosSection(videos: state.content.videoShorts),
          _latestHeaderIndex => const Padding(
            padding: EdgeInsets.fromLTRB(20, 18, 20, 6),
            child: SectionHeader(title: 'Dernières actualités'),
          ),
          _ => ArticleListItem(
            articles: articles,
            index: index - _sectionCount,
          ),
        },
      ),
    );
  }
}
