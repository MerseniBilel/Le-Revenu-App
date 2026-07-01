import '../../domain/entities/home_entities_export.dart';

/// Data-layer representation of an [Article].
///
/// Maps the raw payload (today a fake in-memory JSON, tomorrow an API
/// response) to the domain entity consumed by the rest of the app.
class ArticleModel extends Article {
  const ArticleModel({
    required super.id,
    required super.title,
    required super.category,
    required super.publishedAt,
    required super.readingMinutes,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) => ArticleModel(
    id: json['id'] as String,
    title: json['title'] as String,
    category: NewsCategory.values.byName(json['category'] as String),
    publishedAt: DateTime.parse(json['published_at'] as String),
    readingMinutes: json['reading_minutes'] as int,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category.name,
    'published_at': publishedAt.toIso8601String(),
    'reading_minutes': readingMinutes,
  };
}
