import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context.dart';
import '../../../../core/extensions/duration.dart';
import '../../domain/entities/home_entities_export.dart';
import '../extensions/news_category_ui.dart';
import '../widgets/video_short_card.dart';

/// Full-screen player for a short video, reached with a hero animation from
/// the home rail.
///
/// The playback is simulated (fake data, no real media): a controller
/// animates the progress over the real duration of the video, and can be
/// paused/resumed by tapping the screen.
class VideoShortPlayerScreen extends StatefulWidget {
  const VideoShortPlayerScreen({required this.video, super.key});

  final VideoShort video;

  @override
  State<VideoShortPlayerScreen> createState() => _VideoShortPlayerScreenState();
}

class _VideoShortPlayerScreenState extends State<VideoShortPlayerScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _playback = AnimationController(
    vsync: this,
    duration: widget.video.duration,
  );

  bool _muted = false;

  @override
  void initState() {
    super.initState();
    // The video only starts once the user opened it: playback begins here,
    // never on the home rail.
    _playback
      ..forward()
      ..addStatusListener((_) => setState(() {}));
  }

  @override
  void dispose() {
    _playback.dispose();
    super.dispose();
  }

  void _togglePlayback() {
    setState(() {
      if (_playback.isCompleted) {
        _playback.forward(from: 0);
      } else if (_playback.isAnimating) {
        _playback.stop();
      } else {
        _playback.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final video = widget.video;
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _togglePlayback,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: VideoShortCard.heroTag(video),
              child: Material(
                type: MaterialType.transparency,
                child: ColoredBox(
                  color: video.category.videoPanelColor,
                  child: Center(
                    child: Icon(
                      video.category.icon,
                      size: 72,
                      color: Color.lerp(
                        video.category.videoPanelColor,
                        Colors.white,
                        .22,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (!_playback.isAnimating) const Center(child: _PausedBadge()),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _RoundIconButton(
                          icon: Icons.close_rounded,
                          tooltip: 'Fermer',
                          onTap: context.pop,
                        ),
                        _RoundIconButton(
                          icon: _muted
                              ? Icons.volume_off_rounded
                              : Icons.volume_up_rounded,
                          tooltip: _muted ? 'Activer le son' : 'Couper le son',
                          onTap: () => setState(() => _muted = !_muted),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      video.category.label.toUpperCase(),
                      style: context.h7.copyWith(
                        fontSize: 11,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w500,
                        color: context.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      video.title,
                      style: context.display.copyWith(
                        fontSize: 21,
                        height: 1.3,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _PlaybackProgress(playback: _playback, video: video),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Progress bar + elapsed/total time, driven by the fake playback controller.
class _PlaybackProgress extends StatelessWidget {
  const _PlaybackProgress({required this.playback, required this.video});

  final AnimationController playback;
  final VideoShort video;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: playback,
    builder: (context, _) {
      final elapsed = video.duration * playback.value;
      return Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: SizedBox(
              height: 3,
              child: Stack(
                children: [
                  Container(color: Colors.white.withValues(alpha: .28)),
                  FractionallySizedBox(
                    widthFactor: playback.value,
                    child: ColoredBox(color: context.primary),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                elapsed.mmss,
                style: context.h7.copyWith(fontSize: 11, color: Colors.white),
              ),
              Text(
                video.duration.mmss,
                style: context.h7.copyWith(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: .6),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}

class _PausedBadge extends StatelessWidget {
  const _PausedBadge();

  @override
  Widget build(BuildContext context) => Container(
    width: 64,
    height: 64,
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: .9),
      shape: BoxShape.circle,
    ),
    child: const Icon(Icons.play_arrow_rounded, size: 40, color: Colors.black87),
  );
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: tooltip,
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: .35),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 21, color: Colors.white),
      ),
    ),
  );
}
