import 'news_category.dart';

/// A single editorial article.
class Article {
  const Article({
    required this.id,
    required this.title,
    required this.category,
    required this.publishedAt,
    required this.readingMinutes,
  });

  final String id;
  final String title;
  final NewsCategory category;
  final DateTime publishedAt;
  final int readingMinutes;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Article && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
