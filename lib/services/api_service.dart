import 'package:dio/dio.dart';
import 'package:musicbud_flutter/models/common_track.dart';
import 'package:musicbud_flutter/models/common_artist.dart';
import 'package:musicbud_flutter/models/common_genre.dart';
import 'package:musicbud_flutter/models/common_album.dart';
import 'package:musicbud_flutter/models/user_profile.dart';
import 'package:musicbud_flutter/models/anime.dart';
import 'package:musicbud_flutter/models/manga.dart';
import 'package:musicbud_flutter/models/bud_match.dart';
import 'package:musicbud_flutter/models/common_item.dart';
import 'package:musicbud_flutter/models/categorized_common_items.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late Dio _dio;
  String? _token;
  String? _sessionId;
  final String _baseUrl = 'http://84.235.170.234';

  ApiService._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: 5000,
      receiveTimeout: 3000,
      validateStatus: (status) => status! < 500,
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
      },
    ));
    _dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }

  void setAuthToken(String token) {
    _token = token;
    _updateHeaders();
    print('Auth token set: $_token'); // Debug print
  }

  void setSessionId(String sessionId) {
    _sessionId = sessionId;
    _updateHeaders();
    print('Session ID set: $_sessionId'); // Debug print
  }

  void _updateHeaders() {
    if (_token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $_token';
    }
    if (_sessionId != null) {
      _dio.options.headers['Cookie'] = 'musicbud_sessionid=$_sessionId';
    }
    print('Updated headers: ${_dio.options.headers}'); // Debug print
  }

  Future<List<T>> _fetchItems<T>(String endpoint, T Function(Map<String, dynamic>) fromJson, {int page = 1}) async {
    try {
      print('Fetching items from $endpoint');
      print('Headers: ${_dio.options.headers}');
      print('Request data: {page: $page}');
      final response = await _dio.post(
        endpoint,
        data: {'page': page},
      );
      print('Response status code: ${response.statusCode}');
      print('Response data: ${response.data}');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => fromJson(json)).toList();
      } else {
        throw Exception('Failed to load items from $endpoint: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching items from $endpoint: $e');
      rethrow;
    }
  }

  Future<List<T>> _fetchCommonItems<T>(String endpoint, T Function(Map<String, dynamic>) fromJson, String budId, {int page = 1}) async {
    try {
      print('Fetching common items from $endpoint'); // Debug print
      print('Current token: $_token'); // Debug print
      print('Current headers: ${_dio.options.headers}'); // Debug print

      if (_token == null) {
        throw Exception('Authentication token is not set');
      }

      final response = await _dio.post(
        endpoint,
        queryParameters: {'page': page},
        data: {'bud_id': budId},
      );

      print('Response status code: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        if (responseData.containsKey('data') && responseData['data'] is List) {
          final List<dynamic> data = responseData['data'];
          return data.map((json) {
            try {
              return fromJson(json);
            } catch (e) {
              print('Error parsing item: $e');
              return null;
            }
          }).whereType<T>().toList();
        } else {
          return [];
        }
      } else if (response.statusCode == 404 && response.data['error'] == 'No common items found.') {
        return [];
      } else {
        throw Exception('Failed to load common items from $endpoint: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching common items from $endpoint: $e');
      return [];
    }
  }

  // Profile page methods
  Future<UserProfile> getUserProfile() async {
    final response = await _dio.post('/me/profile', data: {'service': 'spotify'});
    return UserProfile.fromJson(response.data);
  }

  Future<List<CommonTrack>> getTopTracks({int page = 1}) async {
    return _fetchItems('/bud/top/tracks', CommonTrack.fromJson, page: page);
  }

  Future<List<CommonArtist>> getTopArtists({int page = 1}) async {
    return _fetchItems('/bud/top/artists', CommonArtist.fromJson, page: page);
  }

  Future<List<CommonGenre>> getTopGenres({int page = 1}) {
    return _fetchItems('/bud/top/genres', CommonGenre.fromJson, page: page);
  }

  Future<List<CommonAlbum>> getLikedAlbums({int page = 1}) {
    return _fetchItems('/bud/liked/albums', CommonAlbum.fromJson, page: page);
  }

  Future<List<CommonTrack>> getPlayedTracks({int page = 1}) {
    return _fetchItems('/bud/played/tracks', CommonTrack.fromJson, page: page);
  }

  Future<List<Anime>> getTopAnime({int page = 1}) {
    return _fetchItems('/bud/top/anime', Anime.fromJson, page: page);
  }

  Future<List<Manga>> getTopManga({int page = 1}) {
    return _fetchItems('/bud/top/manga', Manga.fromJson, page: page);
  }

  // Buds page methods
  Future<List<BudMatch>> getTopArtistsBuds({int page = 1}) async {
    return _fetchBuds('/bud/top/artists', page: page);
  }

  Future<List<BudMatch>> getTopTracksBuds({int page = 1}) async {
    return _fetchBuds('/bud/top/tracks', page: page);
  }

  Future<List<BudMatch>> getTopGenresBuds({int page = 1}) async {
    return _fetchBuds('/bud/top/genres', page: page);
  }

  Future<List<BudMatch>> getLikedArtistsBuds({int page = 1}) async {
    return _fetchBuds('/bud/liked/artists', page: page);
  }

  Future<List<BudMatch>> getLikedTracksBuds({int page = 1}) async {
    return _fetchBuds('/bud/liked/tracks', page: page);
  }

  Future<List<BudMatch>> getLikedAlbumsBuds({int page = 1}) async {
    return _fetchBuds('/bud/liked/albums', page: page);
  }

  Future<List<BudMatch>> getLikedGenresBuds({int page = 1}) async {
    return _fetchBuds('/bud/liked/genres', page: page);
  }

  Future<List<BudMatch>> getPlayedTracksBuds({int page = 1}) async {
    return _fetchBuds('/bud/played/tracks', page: page);
  }

  // Common items page methods
  Future<List<CommonArtist>> getCommonTopArtists(String budId) {
    return _fetchCommonItems('/bud/common/top/artists', CommonArtist.fromJson, budId);
  }

  Future<List<CommonTrack>> getCommonTopTracks(String budId) {
    return _fetchCommonItems('/bud/common/top/tracks', CommonTrack.fromJson, budId);
  }

  Future<List<CommonGenre>> getCommonTopGenres(String budId) {
    return _fetchCommonItems('/bud/common/top/genres', CommonGenre.fromJson, budId);
  }

  Future<List<CommonArtist>> getCommonLikedArtists(String budId) {
    return _fetchCommonItems('/bud/common/liked/artists', CommonArtist.fromJson, budId);
  }

  Future<List<CommonTrack>> getCommonLikedTracks(String budId) {
    return _fetchCommonItems('/bud/common/liked/tracks', CommonTrack.fromJson, budId);
  }

  Future<List<CommonGenre>> getCommonLikedGenres(String budId) {
    return _fetchCommonItems('/bud/common/liked/genres', CommonGenre.fromJson, budId);
  }

  Future<List<CommonAlbum>> getCommonLikedAlbums(String budId) {
    return _fetchCommonItems('/bud/common/liked/albums', CommonAlbum.fromJson, budId);
  }

  Future<List<CommonTrack>> getCommonPlayedTracks(String budId) {
    return _fetchCommonItems('/bud/common/played/tracks', CommonTrack.fromJson, budId);
  }

  Future<List<Bud>> getBuds(String endpoint) async {
    try {
      final response = await _dio.post(endpoint, data: {'page': 1});
      print('Response status code: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => Bud.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load buds: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching buds: $e');
      return []; // Return an empty list instead of rethrowing the error
    }
  }

  Future<List<BudMatch>> _fetchBuds(String endpoint, {int page = 1}) async {
    try {
      final response = await _dio.post(endpoint, data: {'page': page});
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => BudMatch.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load buds from $endpoint: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching items from $endpoint: $e');
      rethrow;
    }
  }

  Future<List<Bud>> getTopBuds() async {
    try {
      final response = await _dio.post('/bud/top/artists', data: {'page': 1});
      print('Response status code: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => Bud.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load top buds: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching top buds: $e');
      rethrow;
    }
  }

  Future<List<CommonItem>> getCommonItems(String budId, String endpoint) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: {'bud_id': budId},
      );
      print('Response status code: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => CommonItem.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load common items: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching common items: $e');
      rethrow;
    }
  }

  Future<List<CategorizedCommonItems>> getAllCommonItems(String budId) async {
    final categories = [
      'Top Tracks',
      'Top Artists',
      'Top Genres',
      'Liked Albums',
      'Liked Tracks',
      'Liked Artists',
      'Liked Genres',
      'Played Tracks',
    ];

    List<CategorizedCommonItems> result = [];

    for (var category in categories) {
      String endpoint = _getCategoryEndpoint(category);
      try {
        final response = await _dio.post(
          endpoint,
          data: {'bud_id': budId},
        );

        if (response.statusCode == 200) {
          final List<dynamic> data = response.data['data'];
          final items = data.map((json) => CommonItem.fromJson(json)).toList();
          if (items.isNotEmpty) {
            result.add(CategorizedCommonItems(category: category, items: items));
          }
        }
      } catch (e) {
        print('Error fetching common items for $category: $e');
      }
    }

    return result;
  }

  String _getCategoryEndpoint(String category) {
    switch (category) {
      case 'Top Tracks':
        return '/bud/common/top/tracks';
      case 'Top Artists':
        return '/bud/common/top/artists';
      case 'Top Genres':
        return '/bud/common/top/genres';
      case 'Liked Albums':
        return '/bud/common/liked/albums';
      case 'Liked Tracks':
        return '/bud/common/liked/tracks';
      case 'Liked Artists':
        return '/bud/common/liked/artists';
      case 'Liked Genres':
        return '/bud/common/liked/genres';
      case 'Played Tracks':
        return '/bud/common/played/tracks';
      default:
        throw Exception('Unknown category: $category');
    }
  }
}

