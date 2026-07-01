import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

@injectable
class ConnectivityModule {
  @factoryMethod
  Future<List<ConnectivityResult>> get connectivity async =>
      await Connectivity().checkConnectivity();
}

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

@LazySingleton(as: NetworkInfo)
class NetworkInfoImpl implements NetworkInfo {
  final ConnectivityModule connectivityResult;
  NetworkInfoImpl({required this.connectivityResult});

  @override
  Future<bool> get isConnected async => !(await connectivityResult.connectivity)
      .contains(ConnectivityResult.none);
}
