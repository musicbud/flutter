import 'package:dio/dio.dart';
import '../../../core/error/exceptions.dart';
import '../../../config/api_config.dart';
import '../../network/dio_client.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String username, String password);
  Future<Map<String, dynamic>> register(
      String username, String email, String password);
  Future<Map<String, dynamic>> refreshToken(String refreshToken);
  Future<void> logout();
  Future<String> getSpotifyAuthUrl();
  Future<void> connectSpotify(String code);
  Future<String> getYTMusicAuthUrl();
  Future<void> connectYTMusic(String code);
  Future<String> getLastFMAuthUrl();
  Future<void> connectLastFM(String code);
  Future<String> getMALAuthUrl();
  Future<void> connectMAL(String code);
  Future<List<Map<String, dynamic>>> getConnectedServices();
  Future<void> disconnectSpotify();
  Future<void> disconnectYTMusic();
  Future<void> disconnectLastFM();
  Future<void> disconnectMAL();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;

  AuthRemoteDataSourceImpl({required DioClient dioClient})
      : _dioClient = dioClient;

  @override
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await _dioClient.post(ApiConfig.login, data: {
        'username': username,
        'password': password,
      });
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to login');
    }
  }

  @override
  Future<Map<String, dynamic>> register(
      String username, String email, String password) async {
    try {
      final response = await _dioClient.post(ApiConfig.register, data: {
        'username': username,
        'email': email,
        'password': password,
      });
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to register');
    }
  }

  @override
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    try {
      final response = await _dioClient.post(ApiConfig.refreshToken, data: {
        'refresh': refreshToken,
      });
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to refresh token');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dioClient.post(ApiConfig.logout);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to logout');
    }
  }

  // Service connections
  @override
  Future<String> getSpotifyAuthUrl() async {
    try {
      final response = await _dioClient.get(ApiConfig.spotifyAuth);
      return response.data['url'];
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get Spotify auth URL');
    }
  }

  @override
  Future<void> connectSpotify(String code) async {
    try {
      await _dioClient.post(ApiConfig.spotifyConnect, data: {
        'code': code,
      });
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to connect Spotify');
    }
  }

  @override
  Future<String> getYTMusicAuthUrl() async {
    try {
      final response = await _dioClient.get(ApiConfig.ytmusicAuth);
      return response.data['auth_url'];
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get YouTube Music auth URL');
    }
  }

  @override
  Future<void> connectYTMusic(String code) async {
    try {
      await _dioClient.post(ApiConfig.ytmusicConnect, data: {
        'code': code,
      });
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to connect YouTube Music');
    }
  }

  @override
  Future<String> getLastFMAuthUrl() async {
    try {
      final response = await _dioClient.get(ApiConfig.lastfmAuth);
      return response.data['auth_url'];
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get Last.fm auth URL');
    }
  }

  @override
  Future<void> connectLastFM(String code) async {
    try {
      await _dioClient.post(ApiConfig.lastfmConnect, data: {
        'code': code,
      });
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to connect Last.fm');
    }
  }

  @override
  Future<String> getMALAuthUrl() async {
    try {
      final response = await _dioClient.get(ApiConfig.malAuth);
      return response.data['auth_url'];
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get MyAnimeList auth URL');
    }
  }

  @override
  Future<void> connectMAL(String code) async {
    try {
      await _dioClient.post(ApiConfig.malConnect, data: {
        'code': code,
      });
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to connect MyAnimeList');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getConnectedServices() async {
    try {
      final response = await _dioClient.get(ApiConfig.profileServices);
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get connected services');
    }
  }

  @override
  Future<void> disconnectSpotify() async {
    try {
      await _dioClient.post(ApiConfig.spotifyDisconnect);
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to disconnect Spotify');
    }
  }

  @override
  Future<void> disconnectYTMusic() async {
    try {
      await _dioClient.post(ApiConfig.ytmusicDisconnect);
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to disconnect YouTube Music');
    }
  }

  @override
  Future<void> disconnectLastFM() async {
    try {
      await _dioClient.post(ApiConfig.lastfmDisconnect);
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to disconnect Last.fm');
    }
  }

  @override
  Future<void> disconnectMAL() async {
    try {
      await _dioClient.post(ApiConfig.malDisconnect);
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to disconnect MyAnimeList');
    }
  }
}
