import 'package:dio/dio.dart';
import '../../../core/error/exceptions.dart';
import '../../network/dio_client.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String username, String password);
  Future<Map<String, dynamic>> register(
      String username, String email, String password);
  Future<Map<String, dynamic>> refreshToken(String refreshToken);
  Future<void> logout();

  // Service connections
  Future<String> getSpotifyAuthUrl();
  Future<void> connectSpotify(String code);
  Future<void> disconnectSpotify();

  Future<String> getYTMusicAuthUrl();
  Future<void> connectYTMusic(String code);
  Future<void> disconnectYTMusic();

  Future<String> getMALAuthUrl();
  Future<void> connectMAL(String code);
  Future<void> disconnectMAL();

  Future<String> getLastFMAuthUrl();
  Future<void> connectLastFM(String code);
  Future<void> disconnectLastFM();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl({required String baseUrl})
      : _dio = DioClient(baseUrl: baseUrl).dio;

  @override
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
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
      final response = await _dio.post('/auth/register', data: {
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
      final response = await _dio.post('/auth/refresh', data: {
        'refresh_token': refreshToken,
      });
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to refresh token');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to logout');
    }
  }

  // Service connections
  @override
  Future<String> getSpotifyAuthUrl() async {
    try {
      final response = await _dio.get('/auth/spotify/url');
      return response.data['auth_url'];
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get Spotify auth URL');
    }
  }

  @override
  Future<void> connectSpotify(String code) async {
    try {
      await _dio.post('/auth/spotify/connect', data: {'code': code});
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to connect Spotify');
    }
  }

  @override
  Future<void> disconnectSpotify() async {
    try {
      await _dio.post('/auth/spotify/disconnect');
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to disconnect Spotify');
    }
  }

  @override
  Future<String> getYTMusicAuthUrl() async {
    try {
      final response = await _dio.get('/auth/ytmusic/url');
      return response.data['auth_url'];
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get YouTube Music auth URL');
    }
  }

  @override
  Future<void> connectYTMusic(String code) async {
    try {
      await _dio.post('/auth/ytmusic/connect', data: {'code': code});
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to connect YouTube Music');
    }
  }

  @override
  Future<void> disconnectYTMusic() async {
    try {
      await _dio.post('/auth/ytmusic/disconnect');
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to disconnect YouTube Music');
    }
  }

  @override
  Future<String> getMALAuthUrl() async {
    try {
      final response = await _dio.get('/auth/mal/url');
      return response.data['auth_url'];
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get MAL auth URL');
    }
  }

  @override
  Future<void> connectMAL(String code) async {
    try {
      await _dio.post('/auth/mal/connect', data: {'code': code});
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to connect MAL');
    }
  }

  @override
  Future<void> disconnectMAL() async {
    try {
      await _dio.post('/auth/mal/disconnect');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to disconnect MAL');
    }
  }

  @override
  Future<String> getLastFMAuthUrl() async {
    try {
      final response = await _dio.get('/auth/lastfm/url');
      return response.data['auth_url'];
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get LastFM auth URL');
    }
  }

  @override
  Future<void> connectLastFM(String code) async {
    try {
      await _dio.post('/auth/lastfm/connect', data: {'code': code});
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to connect LastFM');
    }
  }

  @override
  Future<void> disconnectLastFM() async {
    try {
      await _dio.post('/auth/lastfm/disconnect');
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to disconnect LastFM');
    }
  }
}
