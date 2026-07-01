// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../api/api_consumer.dart' as _i207;
import '../api/dio_consumer.dart' as _i82;
import '../network/network.dart' as _i855;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt init(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  final dioModule = _$DioModule();
  gh.factory<_i855.ConnectivityModule>(() => _i855.ConnectivityModule());
  gh.lazySingleton<_i361.Dio>(() => dioModule.dioClient);
  gh.lazySingleton<_i207.ApiConsumer>(
    () => _i82.DioConsumer(dio: gh<_i361.Dio>()),
  );
  gh.lazySingleton<_i855.NetworkInfo>(
    () => _i855.NetworkInfoImpl(
      connectivityResult: gh<_i855.ConnectivityModule>(),
    ),
  );
  return getIt;
}

class _$DioModule extends _i82.DioModule {}
