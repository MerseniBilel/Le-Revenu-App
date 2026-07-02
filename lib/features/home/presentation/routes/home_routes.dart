part of '../../../../core/router/router.dart';

@TypedGoRoute<HomeRoute>(
  path: '/home',
  routes: [TypedGoRoute<VideoShortRoute>(path: 'video')],
)
class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const HomeScreen();
}

class VideoShortRoute extends GoRouteData with $VideoShortRoute {
  const VideoShortRoute(this.$extra);

  /// The video is passed as route extra: no lookup needed on the player
  /// side, and the hero animation stays seamless.
  final VideoShort $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      VideoShortPlayerScreen(video: $extra);
}
