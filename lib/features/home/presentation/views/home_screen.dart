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

/// Scrollable body of the page.
///
/// The rubrique chips are pinned below the masthead while scrolling, and act
/// as a scroll-spy over the grouped "Dernières actualités":
/// - scrolling updates the highlighted chip based on the group under the
///   pinned header;
/// - tapping a chip scrolls to its group.
class _HomeContent extends StatefulWidget {
  const _HomeContent({required this.state});

  final HomeLoaded state;

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  final _scrollController = ScrollController();
  final _pinnedChipsKey = GlobalKey();
  late Map<NewsCategory, GlobalKey> _groupKeys;

  NewsCategory? _activeRubrique;

  /// Suspends the scroll-spy while a chip-triggered animation is running,
  /// so intermediate groups don't steal the selection.
  bool _autoScrolling = false;

  List<ArticleGroup> get _groups => widget.state.articleGroups;

  @override
  void initState() {
    super.initState();
    _buildGroupKeys();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(_HomeContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state != oldWidget.state) _buildGroupKeys();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _buildGroupKeys() {
    _groupKeys = {for (final group in _groups) group.category: GlobalKey()};
    _activeRubrique = _groups.isEmpty ? null : _groups.first.category;
  }

  /// Screen-space Y of the bottom edge of the pinned chips bar.
  double? get _pinnedHeaderBottom {
    final box =
        _pinnedChipsKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return null;
    return box.localToGlobal(Offset(0, box.size.height)).dy;
  }

  /// Screen-space Y of the top edge of a rubrique group.
  double? _groupTop(NewsCategory rubrique) {
    final box =
        _groupKeys[rubrique]?.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return null;
    return box.localToGlobal(Offset.zero).dy;
  }

  void _onScroll() {
    if (_autoScrolling || _groups.isEmpty) return;
    final threshold = _pinnedHeaderBottom;
    if (threshold == null) return;

    // Active group = the last one whose top passed under the pinned bar.
    NewsCategory? active;
    for (final group in _groups) {
      final top = _groupTop(group.category);
      if (top == null || top > threshold + 12) break;
      active = group.category;
    }
    active ??= _groups.first.category;
    if (active != _activeRubrique) {
      setState(() => _activeRubrique = active);
    }
  }

  Future<void> _scrollToRubrique(NewsCategory rubrique) async {
    final top = _groupTop(rubrique);
    final threshold = _pinnedHeaderBottom;
    if (top == null || threshold == null) return;

    setState(() {
      _activeRubrique = rubrique;
      _autoScrolling = true;
    });
    final target = (_scrollController.offset + top - threshold).clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );
    await _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeInOutCubic,
    );
    if (mounted) setState(() => _autoScrolling = false);
  }

  @override
  Widget build(BuildContext context) {
    final content = widget.state.content;
    return RefreshIndicator(
      onRefresh: context.read<HomeCubit>().refresh,
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const EyebrowText('À la une'),
                  const SizedBox(height: 8),
                  FeaturedArticleCard(
                    article: content.featured,
                    onTap: () => _showComingSoon(context, "L'article"),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 2),
              child: SectionHeader(
                title: 'Rubriques',
                actionLabel: 'Tout voir',
                onActionTap: () => _showComingSoon(context, 'Cette section'),
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _PinnedChipsDelegate(
              child: Container(
                key: _pinnedChipsKey,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: context.theme.scaffoldBackgroundColor,
                  border: Border(
                    bottom: BorderSide(color: context.fieldStroke, width: .5),
                  ),
                ),
                child: RubriqueChips(
                  rubriques: [for (final g in _groups) g.category],
                  selected: _activeRubrique,
                  onSelected: _scrollToRubrique,
                ),
              ),
            ),
          ),
          if (content.videoShorts.isNotEmpty)
            SliverToBoxAdapter(
              child: VideoShortsRail(
                videos: content.videoShorts,
                onVideoTap: (video) => VideoShortRoute(video).push<void>(
                  context,
                ),
              ),
            ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
              child: const SectionHeader(title: 'Dernières actualités'),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  for (final group in _groups)
                    Column(
                      key: _groupKeys[group.category],
                      children: [
                        for (final article in group.articles) ...[
                          _hairline(context),
                          ArticleTile(
                            article: article,
                            onTap: () => _showComingSoon(context, "L'article"),
                          ),
                        ],
                      ],
                    ),
                  _hairline(context),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  Widget _hairline(BuildContext context) =>
      Divider(height: .5, thickness: .5, color: context.fieldStroke);
}

class _PinnedChipsDelegate extends SliverPersistentHeaderDelegate {
  const _PinnedChipsDelegate({required this.child});

  final Widget child;

  static const _height = 54.0;

  @override
  double get minExtent => _height;

  @override
  double get maxExtent => _height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => child;

  @override
  bool shouldRebuild(covariant _PinnedChipsDelegate oldDelegate) =>
      oldDelegate.child != child;
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
