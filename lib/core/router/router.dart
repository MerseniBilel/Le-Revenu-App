import 'routes_export.dart';

part 'router.g.dart';
part '../../features/home/presentation/routes/home_routes.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: HomeRoute().location,
    routes: $appRoutes,
  );
}
