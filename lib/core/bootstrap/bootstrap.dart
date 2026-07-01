import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import '../environment/environment.dart';
import '../extensions/bloc_base.dart';
import '../gen/injection.dart';

class AppBlocObserver extends BlocObserver {
  final Set<BlocBase> _aliveBlocs = {};

  @override
  void onCreate(BlocBase bloc) {
    _aliveBlocs.add(bloc);
    debugPrint('${bloc.arrangedString} was created');
    debugPrint('Current Alive Bloc : ${_aliveBlocs.arrangedString}');
    super.onCreate(bloc);
  }

  @override
  void onClose(BlocBase bloc) {
    _aliveBlocs.remove(bloc);
    debugPrint('${bloc.arrangedString} was removed');
    debugPrint('Current Alive Bloc : ${_aliveBlocs.arrangedString}');
    super.onClose(bloc);
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    debugPrint('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    debugPrint('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: Env.fileName);

  configureDependencies();

  Bloc.observer = AppBlocObserver();

  // initialize hydrated bloc
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getApplicationDocumentsDirectory()).path,
    ),
  );

  runApp(await builder());
}
