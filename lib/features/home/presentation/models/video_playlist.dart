import '../../domain/entities/home_entities_export.dart';

/// Navigation payload for the video player: the full rail and the video the
/// user tapped, so the player can swipe through the whole list.
class VideoPlaylist {
  const VideoPlaylist({required this.videos, required this.initialIndex});

  final List<VideoShort> videos;
  final int initialIndex;
}
