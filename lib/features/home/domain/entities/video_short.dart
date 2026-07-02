import 'news_category.dart';

/// A short vertical video ("L'actualité en vidéos courtes").
class VideoShort {
  const VideoShort({
    required this.id,
    required this.title,
    required this.category,
    required this.duration,
  });

  final String id;
  final String title;
  final NewsCategory category;
  final Duration duration;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is VideoShort && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
