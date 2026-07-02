import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/snackbar.dart';
import '../../../../core/gen/injection.dart';
import '../../../../core/shared/theme_manager_cubit.dart';
import '../cubit/home_cubit.dart';
import '../widgets/article_list_item.dart';
import '../widgets/home_error_view.dart';
import '../widgets/home_header.dart';
import '../widgets/home_sections.dart';

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

/// Scrollable body of the page: a [SingleChildScrollView] with the page
/// sections ([HomeSections]) followed by the "Dernières actualités" feed,
/// which is the only [ListView.builder]. The rubrique chips filter the feed.
class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.state});

  final HomeLoaded state;

  @override
  Widget build(BuildContext context) {
    final articles = state.visibleArticles;
    return RefreshIndicator(
      onRefresh: context.read<HomeCubit>().refresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeSections(
              featured: state.content.featured,
              videos: state.content.videoShorts,
              rubriques: state.rubriques,
              selectedRubrique: state.selectedRubrique,
              onRubriqueSelected: context.read<HomeCubit>().selectRubrique,
            ),
            ListView.builder(
              shrinkWrap: true,
              // The page scrolls as a whole; the feed must not scroll on
              // its own inside it.
              physics: const NeverScrollableScrollPhysics(),
              itemCount: articles.length,
              itemBuilder: (context, index) =>
                  ArticleListItem(article: articles[index]),
            ),
          ],
        ),
      ),
    );
  }
}
