import '../../domain/repositories/auth_repository.dart';
import '../data_sources/remote/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;

  AuthRepositoryImpl({required AuthRemoteDataSource authRemoteDataSource})
      : _authRemoteDataSource = authRemoteDataSource;

  @override
  Future<Map<String, dynamic>> login(String username, String password) async {
    return await _authRemoteDataSource.login(username, password);
  }

  @override
  Future<Map<String, dynamic>> register(
      String username, String email, String password) async {
    return await _authRemoteDataSource.register(username, email, password);
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      // Try to make a request to check if the user is authenticated
      await _authRemoteDataSource.getServiceAuthUrl();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<String> refreshToken() async {
    final result = await _authRemoteDataSource.refreshToken('');
    return result['access_token'] ?? '';
  }

  @override
  Future<void> logout() async {
    await _authRemoteDataSource.logout();
  }

  @override
  Future<String> getServiceAuthUrl() async {
    return await _authRemoteDataSource.getServiceAuthUrl();
  }

  @override
  Future<String> getServiceLoginUrl(String service) async {
    return await _authRemoteDataSource.getServiceLoginUrl(service);
  }

  @override
  Future<void> connectSpotify(String code) async {
    await _authRemoteDataSource.connectSpotify(code);
  }

  @override
  Future<void> connectYTMusic(String code) async {
    await _authRemoteDataSource.connectYTMusic(code);
  }

  @override
  Future<void> connectLastFM(String code) async {
    await _authRemoteDataSource.connectLastFM(code);
  }

  @override
  Future<void> connectMAL(String code) async {
    await _authRemoteDataSource.connectMAL(code);
  }

  @override
  Future<void> refreshSpotifyToken() async {
    await _authRemoteDataSource.refreshSpotifyToken();
  }

  @override
  Future<void> refreshYTMusicToken() async {
    await _authRemoteDataSource.refreshYTMusicToken();
  }
}
