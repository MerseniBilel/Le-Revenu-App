import '../../domain/entities/home_entities_export.dart';

/// Data-layer representation of a [VideoShort].
class VideoShortModel extends VideoShort {
  const VideoShortModel({
    required super.id,
    required super.title,
    required super.category,
    required super.duration,
  });

  factory VideoShortModel.fromJson(Map<String, dynamic> json) =>
      VideoShortModel(
        id: json['id'] as String,
        title: json['title'] as String,
        category: NewsCategory.values.byName(json['category'] as String),
        duration: Duration(seconds: json['duration_seconds'] as int),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category.name,
    'duration_seconds': duration.inSeconds,
  };
}
