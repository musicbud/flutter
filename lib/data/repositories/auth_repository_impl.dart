import '../../domain/repositories/auth_repository.dart';
import '../data_sources/remote/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl() : _remoteDataSource = AuthRemoteDataSourceImpl();

  @override
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    return await _remoteDataSource.login(
        username: username, password: password);
  }

  @override
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    return await _remoteDataSource.register(
      username: username,
      email: email,
      password: password,
    );
  }

  @override
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    return await _remoteDataSource.refreshToken(refreshToken);
  }

  @override
  Future<void> logout() async {
    await _remoteDataSource.logout();
  }

  // Service connections
  @override
  Future<String> getSpotifyAuthUrl() async {
    return await _remoteDataSource.getSpotifyAuthUrl();
  }

  @override
  Future<void> connectSpotify(String code) async {
    await _remoteDataSource.connectSpotify(code);
  }

  @override
  Future<void> disconnectSpotify() async {
    await _remoteDataSource.disconnectSpotify();
  }

  @override
  Future<String> getYTMusicAuthUrl() async {
    return await _remoteDataSource.getYTMusicAuthUrl();
  }

  @override
  Future<void> connectYTMusic(String code) async {
    await _remoteDataSource.connectYTMusic(code);
  }

  @override
  Future<void> disconnectYTMusic() async {
    await _remoteDataSource.disconnectYTMusic();
  }

  @override
  Future<String> getMALAuthUrl() async {
    return await _remoteDataSource.getMALAuthUrl();
  }

  @override
  Future<void> connectMAL(String code) async {
    await _remoteDataSource.connectMAL(code);
  }

  @override
  Future<void> disconnectMAL() async {
    await _remoteDataSource.disconnectMAL();
  }

  @override
  Future<String> getLastFMAuthUrl() async {
    return await _remoteDataSource.getLastFMAuthUrl();
  }

  @override
  Future<void> connectLastFM(String code) async {
    await _remoteDataSource.connectLastFM(code);
  }

  @override
  Future<void> disconnectLastFM() async {
    await _remoteDataSource.disconnectLastFM();
  }
}
