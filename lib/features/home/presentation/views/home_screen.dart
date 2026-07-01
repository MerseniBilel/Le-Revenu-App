import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/context.dart';
import '../../../../core/gen/injection.dart';
import '../../../../core/shared/theme_manager_cubit.dart';
import '../../../../core/shared/widgets/app_bottom_nav.dart';
import '../../../../core/shared/widgets/eyebrow_text.dart';
import '../../../../core/shared/widgets/section_header.dart';
import '../cubit/home_cubit.dart';
import '../widgets/article_tile.dart';
import '../widgets/featured_article_card.dart';
import '../widgets/home_header.dart';
import '../widgets/rubrique_chips.dart';

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

  static const _destinations = [
    AppBottomNavItem(icon: Icons.newspaper_outlined, label: 'Accueil'),
    AppBottomNavItem(icon: Icons.show_chart, label: 'Marchés'),
    AppBottomNavItem(icon: Icons.work_outline, label: 'Portefeuille'),
    AppBottomNavItem(icon: Icons.grid_view_outlined, label: 'Rubriques'),
    AppBottomNavItem(icon: Icons.person_outline, label: 'Compte'),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      bottom: false,
      child: Column(
        children: [
          HomeHeader(
            onSearchTap: () => _showComingSoon(context, 'La recherche'),
            onNotificationsTap: () =>
                _showComingSoon(context, 'Les notifications'),
            onBrandLongPress: context.read<ThemeCubit>().toggleTheme,
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
    bottomNavigationBar: AppBottomNav(
      items: _destinations,
      currentIndex: 0,
      onTap: (index) {
        if (index != 0) {
          _showComingSoon(context, 'La section ${_destinations[index].label}');
        }
      },
    ),
  );
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.state});

  final HomeLoaded state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    final articles = state.visibleArticles;
    const sidePadding = EdgeInsets.symmetric(horizontal: 20);

    return RefreshIndicator(
      onRefresh: cubit.refresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            sliver: SliverToBoxAdapter(child: const EyebrowText('À la une')),
          ),
          SliverPadding(
            padding: sidePadding,
            sliver: SliverToBoxAdapter(
              child: FeaturedArticleCard(
                article: state.content.featured,
                onTap: () => _showComingSoon(context, "L'article"),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            sliver: SliverToBoxAdapter(
              child: SectionHeader(
                title: 'Rubriques',
                actionLabel: 'Tout voir',
                onActionTap: () => _showComingSoon(context, 'Cette section'),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: RubriqueChips(
              selected: state.selectedRubrique,
              onSelected: cubit.selectRubrique,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
            sliver: SliverToBoxAdapter(
              child: const SectionHeader(title: 'Dernières actualités'),
            ),
          ),
          if (articles.isEmpty)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              sliver: SliverToBoxAdapter(
                child: Center(
                  child: Text(
                    'Aucun article dans cette rubrique pour le moment.',
                    style: context.h6.copyWith(color: context.paragraph),
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: sidePadding,
              sliver: SliverList.separated(
                itemCount: articles.length,
                separatorBuilder: (context, _) =>
                    Divider(height: .5, thickness: .5, color: context.fieldStroke),
                itemBuilder: (context, index) {
                  final article = articles[index];
                  return ArticleTile(
                    article: article,
                    onTap: () => _showComingSoon(context, "L'article"),
                  );
                },
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
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
