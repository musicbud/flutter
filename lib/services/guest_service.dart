import 'package:dio/dio.dart';
import 'dart:developer' as developer;

/// Service for guest/public API endpoints (no authentication required)
class GuestService {
  final Dio _dio;
  String baseUrl;

  // Singleton pattern
  static final GuestService _instance = GuestService._internal();
  factory GuestService({String? baseUrl}) {
    if (baseUrl != null) {
      _instance.baseUrl = baseUrl;
      // Update dio baseUrl as well
      _instance._dio.options.baseUrl = baseUrl;
    }
    return _instance;
  }

  GuestService._internal({this.baseUrl = 'http://localhost:8000'}) 
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        )) {
    _configureDio();
  }

  void _configureDio() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          _log('Guest API Request: ${options.method} ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          _log('Guest API Response: ${response.statusCode} ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          _log('Guest API Error: ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }

  void _log(String message) {
    developer.log(message, name: 'GuestService');
  }

  /// Get public discover content
  /// Returns trending tracks, popular artists, movies, manga, anime, and genres
  Future<Map<String, dynamic>> getPublicDiscover() async {
    try {
      final response = await _dio.get('/v1/discover/public/');
      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['data'] as Map<String, dynamic>;
      } else {
        throw Exception('Failed to fetch public discover content');
      }
    } on DioException catch (e) {
      _log('Error fetching public discover: ${e.message}');
      throw Exception('Network error: ${e.message}');
    }
  }

  /// Get trending content by type
  /// [type] can be 'all', 'tracks', 'artists', 'movies', 'manga'
  Future<Map<String, dynamic>> getTrendingContent({String type = 'all'}) async {
    try {
      final response = await _dio.get(
        '/v1/discover/public/trending/',
        queryParameters: {'type': type},
      );
      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['data'] as Map<String, dynamic>;
      } else {
        throw Exception('Failed to fetch trending content');
      }
    } on DioException catch (e) {
      _log('Error fetching trending content: ${e.message}');
      throw Exception('Network error: ${e.message}');
    }
  }

  /// Get public recommendations (popularity-based, not personalized)
  /// [type] can be 'all', 'movies', 'manga'
  Future<Map<String, dynamic>> getPublicRecommendations({String type = 'all'}) async {
    try {
      final response = await _dio.get(
        '/v1/recommendations/public/',
        queryParameters: {'type': type},
      );
      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data;
      } else {
        throw Exception('Failed to fetch public recommendations');
      }
    } on DioException catch (e) {
      _log('Error fetching public recommendations: ${e.message}');
      throw Exception('Network error: ${e.message}');
    }
  }

  /// Get available genres for music, movies, and anime
  Future<Map<String, List<Map<String, dynamic>>>> getGenres() async {
    try {
      final response = await _dio.get('/v1/discover/public/genres/');
      if (response.statusCode == 200 && response.data['success'] == true) {
        final data = response.data['data'] as Map<String, dynamic>;
        return {
          'music': List<Map<String, dynamic>>.from(data['music'] ?? []),
          'movies': List<Map<String, dynamic>>.from(data['movies'] ?? []),
          'anime': List<Map<String, dynamic>>.from(data['anime'] ?? []),
        };
      } else {
        throw Exception('Failed to fetch genres');
      }
    } on DioException catch (e) {
      _log('Error fetching genres: ${e.message}');
      throw Exception('Network error: ${e.message}');
    }
  }

  /// Get trending tracks
  Future<List<Map<String, dynamic>>> getTrendingTracks() async {
    final data = await getTrendingContent(type: 'tracks');
    return List<Map<String, dynamic>>.from(data['tracks'] ?? []);
  }

  /// Get trending artists
  Future<List<Map<String, dynamic>>> getTrendingArtists() async {
    final data = await getTrendingContent(type: 'artists');
    return List<Map<String, dynamic>>.from(data['artists'] ?? []);
  }

  /// Get trending movies
  Future<List<Map<String, dynamic>>> getTrendingMovies() async {
    final data = await getTrendingContent(type: 'movies');
    return List<Map<String, dynamic>>.from(data['movies'] ?? []);
  }

  /// Get trending manga
  Future<List<Map<String, dynamic>>> getTrendingManga() async {
    final data = await getTrendingContent(type: 'manga');
    return List<Map<String, dynamic>>.from(data['manga'] ?? []);
  }

  /// Get popular movies (from recommendations endpoint)
  Future<List<Map<String, dynamic>>> getPopularMovies() async {
    final data = await getPublicRecommendations(type: 'movies');
    return List<Map<String, dynamic>>.from(data['data']?['movies'] ?? []);
  }

  /// Get popular manga (from recommendations endpoint)
  Future<List<Map<String, dynamic>>> getPopularManga() async {
    final data = await getPublicRecommendations(type: 'manga');
    return List<Map<String, dynamic>>.from(data['data']?['manga'] ?? []);
  }

  /// Get content details by type and ID
  /// [contentType] can be 'movie', 'manga', 'anime', 'track', 'artist', or 'album'
  /// [contentId] is the unique identifier for the content
  Future<Map<String, dynamic>> getContentDetails(String contentType, String contentId) async {
    try {
      final response = await _dio.get('/v1/content/public/$contentType/$contentId/');
      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['data'] as Map<String, dynamic>;
      } else {
        throw Exception(response.data['message'] ?? 'Failed to fetch content details');
      }
    } on DioException catch (e) {
      _log('Error fetching content details: ${e.message}');
      if (e.response?.statusCode == 404) {
        throw Exception('Content not found');
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  /// Get movie details
  Future<Map<String, dynamic>> getMovieDetails(String movieId) async {
    return getContentDetails('movie', movieId);
  }

  /// Get manga details
  Future<Map<String, dynamic>> getMangaDetails(String mangaId) async {
    return getContentDetails('manga', mangaId);
  }

  /// Get anime details
  Future<Map<String, dynamic>> getAnimeDetails(String animeId) async {
    return getContentDetails('anime', animeId);
  }

  /// Get track details
  Future<Map<String, dynamic>> getTrackDetails(String trackId) async {
    return getContentDetails('track', trackId);
  }

  /// Get artist details
  Future<Map<String, dynamic>> getArtistDetails(String artistId) async {
    return getContentDetails('artist', artistId);
  }

  /// Get album details
  Future<Map<String, dynamic>> getAlbumDetails(String albumId) async {
    return getContentDetails('album', albumId);
  }
}
