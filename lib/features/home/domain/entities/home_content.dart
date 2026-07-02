import 'article.dart';
import 'video_short.dart';

/// Everything needed to render the home page.
class HomeContent {
  const HomeContent({
    required this.featured,
    required this.latestArticles,
    required this.videoShorts,
  });

  /// The main story, highlighted at the top of the page ("À la une").
  final Article featured;

  /// Most recent articles, newest first.
  final List<Article> latestArticles;

  /// Short videos displayed in the horizontal rail.
  final List<VideoShort> videoShorts;
}
