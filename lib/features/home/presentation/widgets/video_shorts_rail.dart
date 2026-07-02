import 'package:flutter/material.dart';

import '../../../../core/extensions/context.dart';
import '../../domain/entities/home_entities_export.dart';
import 'video_short_card.dart';

/// "L'actualité en vidéos courtes": brand-colored section title and
/// horizontal, snapping rail of video thumbnails.
class VideoShortsRail extends StatelessWidget {
  const VideoShortsRail({
    required this.videos,
    required this.onVideoTap,
    super.key,
  });

  final List<VideoShort> videos;
  final ValueChanged<VideoShort> onVideoTap;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        child: Row(
          children: [
            Container(width: 8, height: 8, color: context.primary),
            const SizedBox(width: 8),
            Text(
              "L'actualité en vidéos courtes",
              style: context.display.copyWith(
                fontSize: 17,
                color: context.primary,
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        height: VideoShortCard.height,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: videos.length,
          separatorBuilder: (_, _) => const SizedBox(width: 11),
          itemBuilder: (_, index) {
            final video = videos[index];
            return VideoShortCard(
              video: video,
              onTap: () => onVideoTap(video),
            );
          },
        ),
      ),
    ],
  );
}
