import 'package:flutter/material.dart';

import '../../../../core/extensions/context.dart';
import '../../../../core/extensions/duration.dart';
import '../../domain/entities/home_entities_export.dart';
import '../extensions/news_category_ui.dart';

/// Static thumbnail of a short video: nothing plays here, the playback
/// (simulated) only starts on the dedicated screen, after a tap.
class VideoShortCard extends StatelessWidget {
  const VideoShortCard({required this.video, super.key, this.onTap});

  final VideoShort video;
  final VoidCallback? onTap;

  static const width = 138.0;
  static const height = 244.0;

  /// Shared with the player screen so the thumbnail flies between the two.
  static String heroTag(VideoShort video) => 'video-short-${video.id}';

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Hero(
      tag: heroTag(video),
      child: Material(
        type: MaterialType.transparency,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: SizedBox(
            width: width,
            height: height,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ColoredBox(color: video.category.videoPanelColor),
                Center(
                  child: Icon(
                    video.category.icon,
                    size: 30,
                    color: Color.lerp(
                      video.category.videoPanelColor,
                      Colors.white,
                      .22,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: _DurationPill(duration: video.duration),
                ),
                const Positioned(top: 8, right: 8, child: _BrandWatermark()),
                const Center(child: _PlayButton()),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _Caption(title: video.title),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _DurationPill extends StatelessWidget {
  const _DurationPill({required this.duration});

  final Duration duration;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      color: Colors.black.withValues(alpha: .55),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      duration.mmss,
      style: context.h7.copyWith(
        fontSize: 9.5,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
    ),
  );
}

/// Small "LE REVENU" tag identifying the brand on every video.
class _BrandWatermark extends StatelessWidget {
  const _BrandWatermark();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
    decoration: BoxDecoration(
      color: const Color(0xFF111111),
      borderRadius: BorderRadius.circular(3),
      border: Border(left: BorderSide(color: context.primary, width: 2)),
    ),
    child: Text(
      'LE REVENU',
      style: context.h7.copyWith(
        fontSize: 8,
        letterSpacing: .5,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
    ),
  );
}

class _PlayButton extends StatelessWidget {
  const _PlayButton();

  @override
  Widget build(BuildContext context) => Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: .9),
      shape: BoxShape.circle,
    ),
    child: const Icon(Icons.play_arrow_rounded, size: 24, color: Colors.black87),
  );
}

class _Caption extends StatelessWidget {
  const _Caption({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(10, 22, 10, 11),
    color: const Color(0xA8080A10),
    child: Text(
      title,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: context.h7.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.26,
        color: Colors.white,
      ),
    ),
  );
}
