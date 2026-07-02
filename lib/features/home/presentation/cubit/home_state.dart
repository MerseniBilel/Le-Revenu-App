part of 'home_cubit.dart';

sealed class HomeState {
  const HomeState();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeError extends HomeState {
  const HomeError(this.message);

  final String message;
}

class HomeLoaded extends HomeState {
  const HomeLoaded({required this.content});

  final HomeContent content;

  /// "Dernières actualités" grouped by rubrique, in the rubrique order.
  ///
  /// Drives both the chip list and the scroll-spy sections: only rubriques
  /// that actually have articles are present.
  List<ArticleGroup> get articleGroups => [
    for (final category in NewsCategory.values)
      if (content.latestArticles.any((a) => a.category == category))
        (
          category: category,
          articles: content.latestArticles
              .where((a) => a.category == category)
              .toList(),
        ),
  ];
}

typedef ArticleGroup = ({NewsCategory category, List<Article> articles});
