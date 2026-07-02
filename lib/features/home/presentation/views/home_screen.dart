import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/snackbar.dart';
import '../../../../core/gen/injection.dart';
import '../../../../core/shared/theme_manager_cubit.dart';
import '../../domain/entities/home_entities_export.dart';
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
/// which is the only [ListView.builder].
///
/// Tapping a rubrique chip auto-scrolls to the first article of that
/// rubrique: rows have a fixed height ([ArticleListItem.height]), so the
/// target offset is simply `sections height + first index × row height`.
class _HomeContent extends StatefulWidget {
  const _HomeContent({required this.state});

  final HomeLoaded state;

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  final _scrollController = ScrollController();
  final _sectionsKey = GlobalKey();

  NewsCategory? _selectedRubrique;

  /// Measured height of [HomeSections], kept up to date while it is built
  /// so the chip auto-scroll still works once it scrolled out of view.
  double? _sectionsHeight;

  @override
  void initState() {
    super.initState();
    _selectedRubrique = widget.state.rubriques.firstOrNull;
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureSections());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _measureSections() {
    final box = _sectionsKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null && box.hasSize) _sectionsHeight = box.size.height;
  }

  Future<void> _scrollToRubrique(NewsCategory rubrique) async {
    _measureSections();
    final sectionsHeight = _sectionsHeight;
    if (sectionsHeight == null) return;

    setState(() => _selectedRubrique = rubrique);
    final index = widget.state.firstArticleIndexOf(rubrique);
    final target = (sectionsHeight + index * ArticleListItem.height).clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );
    await _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final articles = widget.state.orderedArticles;
    return RefreshIndicator(
      onRefresh: context.read<HomeCubit>().refresh,
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeSections(
              key: _sectionsKey,
              featured: widget.state.content.featured,
              videos: widget.state.content.videoShorts,
              rubriques: widget.state.rubriques,
              selectedRubrique: _selectedRubrique,
              onRubriqueTap: _scrollToRubrique,
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
