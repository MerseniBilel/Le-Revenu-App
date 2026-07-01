part of '../../../../core/router/router.dart';

@TypedGoRoute<HomeRoute>(path: '/home', routes: [])
class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => HomeScreen();
}
