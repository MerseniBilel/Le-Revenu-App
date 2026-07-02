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

  /// Rubriques that actually have articles, in the editorial order.
  List<NewsCategory> get rubriques => [
    for (final category in NewsCategory.values)
      if (content.latestArticles.any((a) => a.category == category)) category,
  ];

  /// News feed ordered rubrique by rubrique, so a chip can scroll straight
  /// to the beginning of its rubrique.
  List<Article> get orderedArticles => [
    for (final category in rubriques)
      ...content.latestArticles.where((a) => a.category == category),
  ];

  /// Position of the first article of [rubrique] in [orderedArticles].
  int firstArticleIndexOf(NewsCategory rubrique) =>
      orderedArticles.indexWhere((a) => a.category == rubrique);
}
