import 'package:dio/dio.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../config/api_config.dart';
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
      await _authRemoteDataSource.getConnectedServices();
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
  Future<String> getSpotifyAuthUrl() async {
    return await _authRemoteDataSource.getSpotifyAuthUrl();
  }

  @override
  Future<void> connectSpotify(String code) async {
    await _authRemoteDataSource.connectSpotify(code);
  }

  @override
  Future<String> getYTMusicAuthUrl() async {
    return await _authRemoteDataSource.getYTMusicAuthUrl();
  }

  @override
  Future<void> connectYTMusic(String code) async {
    await _authRemoteDataSource.connectYTMusic(code);
  }

  @override
  Future<String> getLastFMAuthUrl() async {
    return await _authRemoteDataSource.getLastFMAuthUrl();
  }

  @override
  Future<void> connectLastFM(String code) async {
    await _authRemoteDataSource.connectLastFM(code);
  }

  @override
  Future<String> getMALAuthUrl() async {
    return await _authRemoteDataSource.getMALAuthUrl();
  }

  @override
  Future<void> connectMAL(String code) async {
    await _authRemoteDataSource.connectMAL(code);
  }

  @override
  Future<List<Map<String, dynamic>>> getConnectedServices() async {
    return await _authRemoteDataSource.getConnectedServices();
  }

  @override
  Future<void> disconnectSpotify() async {
    await _authRemoteDataSource.disconnectSpotify();
  }

  @override
  Future<void> disconnectYTMusic() async {
    await _authRemoteDataSource.disconnectYTMusic();
  }

  @override
  Future<void> disconnectLastFM() async {
    await _authRemoteDataSource.disconnectLastFM();
  }

  @override
  Future<void> disconnectMAL() async {
    await _authRemoteDataSource.disconnectMAL();
  }
}
