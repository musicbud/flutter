import 'package:dio/dio.dart';
import '../../../core/error/exceptions.dart';
import '../../../config/api_config.dart';
import '../../../utils/http_utils.dart';
import '../../network/dio_client.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String username, String password);
  Future<Map<String, dynamic>> register(
      String username, String email, String password);
  Future<Map<String, dynamic>> refreshToken(String refreshToken);
  Future<void> logout();
  Future<String> getServiceAuthUrl();
  Future<String> getServiceLoginUrl(String service);
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
      if (HttpUtils.isAuthenticationError(e)) {
        throw AuthenticationException(
          message: 'Invalid username or password. Please check your credentials and try again.'
        );
      } else if (HttpUtils.isNetworkError(e)) {
        throw NetworkException(
          message: 'Network error during login. Please check your internet connection.'
        );
      } else if (HttpUtils.isServerError(e)) {
        throw ServerException(
          message: 'Server error during login. Please try again in a few moments.'
        );
      } else {
        throw ServerException(message: HttpUtils.handleDioException(e));
      }
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
      if (HttpUtils.isNetworkError(e)) {
        throw NetworkException(
          message: 'Network error during registration. Please check your internet connection.'
        );
      } else if (HttpUtils.isServerError(e)) {
        throw ServerException(
          message: 'Server error during registration. Please try again in a few moments.'
        );
      } else {
        // For validation errors (422) and conflicts (409), provide specific messages
        final statusCode = e.response?.statusCode;
        if (statusCode == 422) {
          throw ServerException(
            message: 'Registration validation failed. Please check your input data.'
          );
        } else if (statusCode == 409) {
          throw ServerException(
            message: 'Username or email already exists. Please choose different credentials.'
          );
        } else {
          throw ServerException(message: HttpUtils.handleDioException(e));
        }
      }
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
  Future<String> getServiceLoginUrl(String service) async {
    try {
      final response = await _dioClient.get('${ApiConfig.serviceLogin}?service=$service');
      return response.data['data']['authorization_link'];
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get service login URL for $service');
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
