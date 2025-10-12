import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../config/dynamic_api_config.dart';
import 'enhanced_logging_interceptor.dart';

/// Real API service for communicating with MusicBud backend
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late Dio _dio;
  String? _authToken;

  ApiService._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: DynamicApiConfig.currentBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add interceptors
    _dio.interceptors.add(EnhancedLoggingInterceptor());
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add auth token to requests if available
        if (_authToken != null) {
          options.headers['Authorization'] = 'Bearer $_authToken';
        }
        return handler.next(options);
      },
      onError: (error, handler) {
        debugPrint('API Error: ${error.message}');
        debugPrint('Response: ${error.response?.data}');
        return handler.next(error);
      },
    ));
  }

  /// Set authentication token
  void setAuthToken(String? token) {
    _authToken = token;
  }

  /// Get current auth token
  String? get authToken => _authToken;

  // ============== Auth Endpoints ==============

  /// Login user
  Future<Response> login({
    required String username,
    required String password,
  }) async {
    // Use full URI to preserve trailing slash (Dio strips it otherwise)
    final uri = Uri.parse('${DynamicApiConfig.currentBaseUrl}/v1/login/');
    return await _dio.postUri(
      uri,
      data: {
        'username': username,
        'password': password,
      },
    );
  }

  /// Register new user
  Future<Response> register({
    required String email,
    required String username,
    required String password,
    required String confirmPassword,
  }) async {
    // Use full URI to preserve trailing slash (Dio strips it otherwise)
    final uri = Uri.parse('${DynamicApiConfig.currentBaseUrl}/v1/register/');
    return await _dio.postUri(
      uri,
      data: {
        'email': email,
        'username': username,
        'password': password,
        'confirm_password': confirmPassword,
      },
    );
  }

  /// Logout user
  Future<Response> logout() async {
    return await _dio.post('/v1/logout/');
  }

  /// Refresh token
  Future<Response> refreshToken(String refreshToken) async {
    return await _dio.post(
      '/v1/token/refresh',
      data: {'refresh': refreshToken},
    );
  }

  // ============== User Profile Endpoints ==============

  /// Get my profile
  Future<Response> getMyProfile() async {
    return await _dio.post(DynamicApiConfig.userEndpoints['myProfile']!);
  }

  /// Set my profile
  Future<Response> setMyProfile(Map<String, dynamic> profileData) async {
    return await _dio.post('/v1/me/profile/set', data: profileData);
  }

  /// Update my likes
  Future<Response> updateMyLikes(Map<String, dynamic> likesData) async {
    return await _dio.post('/v1/me/likes/update', data: likesData);
  }

  // ============== Bud Matching Endpoints ==============

  /// Get bud profile
  Future<Response> getBudProfile(String budId) async {
    return await _dio.post(
      DynamicApiConfig.budEndpoints['profile']!,
      data: {'bud_id': budId},
    );
  }

  /// Get buds by top artists
  Future<Response> getBudsByTopArtists() async {
    return await _dio.post(DynamicApiConfig.budEndpoints['topArtists']!);
  }

  /// Get buds by top tracks
  Future<Response> getBudsByTopTracks() async {
    return await _dio.post(DynamicApiConfig.budEndpoints['topTracks']!);
  }

  /// Get buds by top genres
  Future<Response> getBudsByTopGenres() async {
    return await _dio.post(DynamicApiConfig.budEndpoints['topGenres']!);
  }

  /// Get buds by liked artists
  Future<Response> getBudsByLikedArtists() async {
    return await _dio.post(DynamicApiConfig.budEndpoints['likedArtists']!);
  }

  /// Get buds by liked tracks
  Future<Response> getBudsByLikedTracks() async {
    return await _dio.post(DynamicApiConfig.budEndpoints['likedTracks']!);
  }

  /// Get buds by liked aio (all in one)
  Future<Response> getBudsByLikedAio() async {
    return await _dio.post(DynamicApiConfig.budEndpoints['likedAio']!);
  }

  /// Get buds by specific artist
  Future<Response> getBudsByArtist(String artistId) async {
    return await _dio.post(
      DynamicApiConfig.budEndpoints['byArtist']!,
      data: {'artist_id': artistId},
    );
  }

  /// Get buds by specific track
  Future<Response> getBudsByTrack(String trackId) async {
    return await _dio.post(
      DynamicApiConfig.budEndpoints['byTrack']!,
      data: {'track_id': trackId},
    );
  }

  /// Get buds by specific genre
  Future<Response> getBudsByGenre(String genreId) async {
    return await _dio.post(
      DynamicApiConfig.budEndpoints['byGenre']!,
      data: {'genre_id': genreId},
    );
  }

  // ============== Common Bud Endpoints ==============

  /// Get common top artists with bud
  Future<Response> getCommonTopArtists(String budId) async {
    return await _dio.post(
      DynamicApiConfig.commonBudEndpoints['commonTopArtists']!,
      data: {'bud_id': budId},
    );
  }

  /// Get common top tracks with bud
  Future<Response> getCommonTopTracks(String budId) async {
    return await _dio.post(
      DynamicApiConfig.commonBudEndpoints['commonTopTracks']!,
      data: {'bud_id': budId},
    );
  }

  /// Get common liked artists with bud
  Future<Response> getCommonLikedArtists(String budId) async {
    return await _dio.post(
      DynamicApiConfig.commonBudEndpoints['commonLikedArtists']!,
      data: {'bud_id': budId},
    );
  }

  /// Get common liked tracks with bud
  Future<Response> getCommonLikedTracks(String budId) async {
    return await _dio.post(
      DynamicApiConfig.commonBudEndpoints['commonLikedTracks']!,
      data: {'bud_id': budId},
    );
  }

  // ============== Content Endpoints ==============

  /// Get tracks
  Future<Response> getTracks({int page = 1, int pageSize = 20}) async {
    return await _dio.get(
      '/v1/content/tracks',
      queryParameters: {'page': page, 'page_size': pageSize},
    );
  }

  /// Get artists
  Future<Response> getArtists({int page = 1, int pageSize = 20}) async {
    return await _dio.get(
      '/v1/content/artists',
      queryParameters: {'page': page, 'page_size': pageSize},
    );
  }

  /// Get albums
  Future<Response> getAlbums({int page = 1, int pageSize = 20}) async {
    return await _dio.get(
      '/v1/content/albums',
      queryParameters: {'page': page, 'page_size': pageSize},
    );
  }

  /// Get playlists
  Future<Response> getPlaylists({int page = 1, int pageSize = 20}) async {
    return await _dio.get(
      '/v1/content/playlists',
      queryParameters: {'page': page, 'page_size': pageSize},
    );
  }

  /// Get genres
  Future<Response> getGenres({int page = 1, int pageSize = 20}) async {
    return await _dio.get(
      '/v1/content/genres',
      queryParameters: {'page': page, 'page_size': pageSize},
    );
  }

  // ============== Search Endpoints ==============

  /// Search
  Future<Response> search(String query, {String? type}) async {
    return await _dio.get(
      '/v1/search',
      queryParameters: {
        'q': query,
        if (type != null) 'type': type,
      },
    );
  }

  /// Search suggestions
  Future<Response> searchSuggestions(String query) async {
    return await _dio.get(
      '/v1/search/suggestions',
      queryParameters: {'q': query},
    );
  }

  /// Search recent
  Future<Response> searchRecent() async {
    return await _dio.get('/v1/search/recent');
  }

  /// Search trending
  Future<Response> searchTrending() async {
    return await _dio.get('/v1/search/trending');
  }

  /// Search users
  Future<Response> searchUsers(String query) async {
    return await _dio.post(
      '/v1/bud/search',
      data: {'query': query},
    );
  }

  // ============== Library Endpoints ==============

  /// Get library
  Future<Response> getLibrary() async {
    return await _dio.get('/v1/library');
  }

  /// Get library playlists
  Future<Response> getLibraryPlaylists() async {
    return await _dio.get('/v1/library/playlists');
  }

  /// Get library liked
  Future<Response> getLibraryLiked() async {
    return await _dio.get('/v1/library/liked');
  }

  /// Get library downloads
  Future<Response> getLibraryDownloads() async {
    return await _dio.get('/v1/library/downloads');
  }

  /// Get library recent
  Future<Response> getLibraryRecent() async {
    return await _dio.get('/v1/library/recent');
  }

  // ============== Event Endpoints ==============

  /// Get events
  Future<Response> getEvents() async {
    return await _dio.get('/v1/events');
  }

  /// Get event by ID
  Future<Response> getEventById(int eventId) async {
    return await _dio.get('/v1/events/$eventId');
  }

  // ============== Analytics Endpoints ==============

  /// Get analytics
  Future<Response> getAnalytics() async {
    return await _dio.get('/v1/analytics');
  }

  /// Get analytics stats
  Future<Response> getAnalyticsStats() async {
    return await _dio.get('/v1/analytics/stats');
  }

  // ============== My Top/Liked Endpoints ==============

  /// Get my top artists
  Future<Response> getMyTopArtists({int page = 1, int pageSize = 20}) async {
    return await _dio.get(
      '/v1/me/top/artists',
      queryParameters: {'page': page, 'page_size': pageSize},
    );
  }

  /// Get my top tracks
  Future<Response> getMyTopTracks({int page = 1, int pageSize = 20}) async {
    return await _dio.get(
      '/v1/me/top/tracks',
      queryParameters: {'page': page, 'page_size': pageSize},
    );
  }

  /// Get my liked artists
  Future<Response> getMyLikedArtists({int page = 1, int pageSize = 20}) async {
    return await _dio.get(
      '/v1/me/liked/artists',
      queryParameters: {'page': page, 'page_size': pageSize},
    );
  }

  /// Get my liked tracks
  Future<Response> getMyLikedTracks({int page = 1, int pageSize = 20}) async {
    return await _dio.get(
      '/v1/me/liked/tracks',
      queryParameters: {'page': page, 'page_size': pageSize},
    );
  }

  /// Get my liked albums
  Future<Response> getMyLikedAlbums({int page = 1, int pageSize = 20}) async {
    return await _dio.get(
      '/v1/me/liked/albums',
      queryParameters: {'page': page, 'page_size': pageSize},
    );
  }

  // ============== Service Connection Endpoints ==============

  /// Get service login URL
  Future<Response> getServiceLogin(String service) async {
    return await _dio.get(
      '/v1/service/login',
      queryParameters: {'service': service},
    );
  }

  /// Connect Spotify
  Future<Response> connectSpotify(String token, String spotifyToken) async {
    return await _dio.post(
      '/v1/spotify/connect',
      data: {
        'token': token,
        'spotify_token': spotifyToken,
      },
    );
  }

  /// Refresh Spotify token
  Future<Response> refreshSpotifyToken() async {
    return await _dio.post('/v1/spotify/token/refresh');
  }

  // ============== Recommendations Endpoints ==============

  /// Get personalized recommendations
  Future<Response> getRecommendations() async {
    return await _dio.get('/v1/recommendations/');
  }

  /// Get recommendations by type (tracks, artists, albums, genres)
  Future<Response> getRecommendationsByType(String type) async {
    return await _dio.get('/v1/recommendations/$type/');
  }

  // ============== Recent Activity Endpoints ==============

  /// Get recent activity
  Future<Response> getRecentActivity({int page = 1, int pageSize = 20}) async {
    return await _dio.get(
      '/v1/activity/recent/',
      queryParameters: {'page': page, 'page_size': pageSize},
    );
  }

  /// Get recent activity by type
  Future<Response> getRecentActivityByType(String type, {int page = 1, int pageSize = 20}) async {
    return await _dio.get(
      '/v1/activity/recent/$type/',
      queryParameters: {'page': page, 'page_size': pageSize},
    );
  }

  // ============== Track Details Endpoints ==============

  /// Get track details
  Future<Response> getTrackDetails(String trackId) async {
    return await _dio.get('/v1/track/$trackId/');
  }

  /// Get related tracks
  Future<Response> getRelatedTracks(String trackId, {int limit = 10}) async {
    return await _dio.get(
      '/v1/track/$trackId/related/',
      queryParameters: {'limit': limit},
    );
  }

  // ============== User Statistics Endpoint ==============

  /// Get user statistics
  Future<Response> getUserStatistics() async {
    return await _dio.get('/v1/user/statistics/');
  }

  // ============== Health Check ==============

  /// Health check
  Future<Response> healthCheck() async {
    return await _dio.get('/');
  }
}
