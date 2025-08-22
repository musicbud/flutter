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
  Future<String> getServiceAuthUrl();
  Future<void> connectSpotify(String code);
  Future<void> connectYTMusic(String code);
  Future<void> connectLastFM(String code);
  Future<void> connectMAL(String code);
  Future<void> refreshSpotifyToken();
  Future<void> refreshYTMusicToken();
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
      await _dioClient.get(ApiConfig.logout);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to logout');
    }
  }

  // Service connections
  @override
  Future<String> getServiceAuthUrl() async {
    try {
      final response = await _dioClient.get(ApiConfig.serviceLogin);
      return response.data['url'];
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get service auth URL');
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
  Future<void> refreshSpotifyToken() async {
    try {
      await _dioClient.post(ApiConfig.spotifyRefreshToken);
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to refresh Spotify token');
    }
  }

  @override
  Future<void> refreshYTMusicToken() async {
    try {
      await _dioClient.post(ApiConfig.ytmusicRefreshToken);
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to refresh YouTube Music token');
    }
  }
}
