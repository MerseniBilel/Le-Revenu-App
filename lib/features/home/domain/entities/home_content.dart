import 'article.dart';

/// Everything needed to render the home page.
class HomeContent {
  const HomeContent({required this.featured, required this.latestArticles});

  /// The main story, highlighted at the top of the page ("À la une").
  final Article featured;

  /// Most recent articles, newest first.
  final List<Article> latestArticles;
}
