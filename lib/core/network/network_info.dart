import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Future<bool> get hasInternetAccess;
  Stream<ConnectivityResult> get onConnectivityChanged;
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectionChecker, {Connectivity? connectivity})
      : connectivity = connectivity ?? Connectivity();

  @override
  Future<bool> get isConnected async {
    final results = await connectivity.checkConnectivity();
    return results.isNotEmpty && results.any((r) => r != ConnectivityResult.none);
  }

  @override
  Future<bool> get hasInternetAccess => connectionChecker.hasConnection;

  @override
  Stream<ConnectivityResult> get onConnectivityChanged => connectivity.onConnectivityChanged.map((list) => list.isNotEmpty ? list.first : ConnectivityResult.none);

  /// Check if device has both network connectivity and internet access
  Future<bool> get isFullyConnected async {
    final connected = await isConnected;
    if (!connected) return false;

    final hasInternet = await hasInternetAccess;
    return hasInternet;
  }
}
