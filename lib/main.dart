import 'package:lerevenu/core/router/router.dart';

import 'core/bootstrap/bootstrap.dart';
import 'core/router/routes_export.dart';
import 'core/shared/theme_manager_cubit.dart';

Future<void> main() async => await bootstrap(() => const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) => ThemeCubit(),
    child: BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, mode) => Sizer(
        builder: (context, _, _) => MaterialApp.router(
          debugShowCheckedModeBanner: kDebugMode || kProfileMode,
          themeMode: mode,
          theme: LerevenuTheme.lightTheme,
          darkTheme: LerevenuTheme.darkTheme,
          routerConfig: AppRouter.router,
          builder: (context, child) => DisbleScrollEffect(
            child: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: child,
            ),
          ),
        ),
      ),
    ),
  );
}
