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
/// The rubrique chips scroll with the content; once they pass the top of the
/// body, a floating copy of the bar is overlaid ("pinned" effect) and acts
/// as a scroll-spy over the grouped "Dernières actualités":
/// - scrolling updates the highlighted chip based on the group under the bar;
/// - tapping a chip scrolls to its group.
class _HomeContent extends StatefulWidget {
  const _HomeContent({required this.state});

  final HomeLoaded state;

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  static const _chipsBarHeight = 54.0;

  final _scrollController = ScrollController();
  final _bodyKey = GlobalKey();
  final _inlineChipsKey = GlobalKey();
  late Map<NewsCategory, GlobalKey> _groupKeys;

  NewsCategory? _activeRubrique;
  bool _showFloatingBar = false;

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

  /// Screen-space Y of the top edge of the widget owning [key].
  double? _topOf(GlobalKey key) {
    final box = key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return null;
    return box.localToGlobal(Offset.zero).dy;
  }

  void _onScroll() {
    if (_groups.isEmpty) return;
    final bodyTop = _topOf(_bodyKey);
    final chipsTop = _topOf(_inlineChipsKey);
    if (bodyTop == null || chipsTop == null) return;

    final showFloatingBar = chipsTop <= bodyTop;

    // Active group = the last one whose top passed under the chips bar.
    var active = _activeRubrique;
    if (!_autoScrolling) {
      final threshold = bodyTop + _chipsBarHeight + 12;
      active = null;
      for (final group in _groups) {
        final top = _topOf(_groupKeys[group.category]!);
        if (top == null || top > threshold) break;
        active = group.category;
      }
      active ??= _groups.first.category;
    }

    if (showFloatingBar != _showFloatingBar || active != _activeRubrique) {
      setState(() {
        _showFloatingBar = showFloatingBar;
        _activeRubrique = active;
      });
    }
  }

  Future<void> _scrollToRubrique(NewsCategory rubrique) async {
    final top = _topOf(_groupKeys[rubrique]!);
    final bodyTop = _topOf(_bodyKey);
    if (top == null || bodyTop == null) return;

    setState(() {
      _activeRubrique = rubrique;
      _autoScrolling = true;
    });
    final target = (_scrollController.offset + top - bodyTop - _chipsBarHeight)
        .clamp(0.0, _scrollController.position.maxScrollExtent);
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
    return Stack(
      key: _bodyKey,
      children: [
        RefreshIndicator(
          onRefresh: context.read<HomeCubit>().refresh,
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 2),
                  child: SectionHeader(
                    title: 'Rubriques',
                    actionLabel: 'Tout voir',
                    onActionTap: () =>
                        _showComingSoon(context, 'Cette section'),
                  ),
                ),
                _chipsBar(key: _inlineChipsKey),
                if (content.videoShorts.isNotEmpty)
                  VideoShortsRail(
                    videos: content.videoShorts,
                    onVideoTap: (video) =>
                        VideoShortRoute(video).push<void>(context),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
                  child: const SectionHeader(title: 'Dernières actualités'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
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
                                onTap: () =>
                                    _showComingSoon(context, "L'article"),
                              ),
                            ],
                          ],
                        ),
                      _hairline(context),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        if (_showFloatingBar)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _chipsBar(floating: true),
          ),
      ],
    );
  }

  /// The chips bar is a single widget used twice: inline in the scroll flow,
  /// and as the floating "pinned" copy (with background and hairline).
  Widget _chipsBar({Key? key, bool floating = false}) => Container(
    key: key,
    height: _chipsBarHeight,
    alignment: Alignment.center,
    decoration: floating
        ? BoxDecoration(
            color: context.theme.scaffoldBackgroundColor,
            border: Border(
              bottom: BorderSide(color: context.fieldStroke, width: .5),
            ),
          )
        : null,
    child: RubriqueChips(
      rubriques: [for (final group in _groups) group.category],
      selected: _activeRubrique,
      onSelected: _scrollToRubrique,
    ),
  );

  Widget _hairline(BuildContext context) =>
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
