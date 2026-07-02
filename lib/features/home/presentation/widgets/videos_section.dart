import 'package:flutter/material.dart';

import '../../../../core/router/router.dart';
import '../../domain/entities/home_entities_export.dart';
import '../models/video_playlist.dart';
import 'video_shorts_rail.dart';

/// Videos rail wired to the player navigation; hidden when there is no
/// video to show.
class VideosSection extends StatelessWidget {
  const VideosSection({required this.videos, super.key});

  final List<VideoShort> videos;

  @override
  Widget build(BuildContext context) {
    if (videos.isEmpty) return const SizedBox.shrink();
    return VideoShortsRail(
      videos: videos,
      onVideoTap: (video) => VideoShortRoute(
        VideoPlaylist(videos: videos, initialIndex: videos.indexOf(video)),
      ).push<void>(context),
    );
  }
}
