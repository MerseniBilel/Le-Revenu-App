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
  const HomeLoaded({required this.content, this.selectedRubrique});

  final HomeContent content;

  /// Rubrique used to filter the news feed. `null` means "Tous".
  final NewsCategory? selectedRubrique;

  /// Rubriques that actually have articles, in the editorial order.
  List<NewsCategory> get rubriques => [
    for (final category in NewsCategory.values)
      if (content.latestArticles.any((a) => a.category == category)) category,
  ];

  /// Articles displayed in the "Dernières actualités" section, taking the
  /// selected rubrique into account.
  List<Article> get visibleArticles => selectedRubrique == null
      ? content.latestArticles
      : content.latestArticles
            .where((article) => article.category == selectedRubrique)
            .toList();
}
