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
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;
import 'package:musicbud_flutter/models/common_anime.dart';
import 'package:musicbud_flutter/models/common_manga.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  final Dio _dio;
  String? _accessToken;
  String? _sessionId;
  final String _baseUrl = 'http://84.235.170.234';

  ApiService._internal() : _dio = Dio() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = Duration(seconds: 5);
    _dio.options.receiveTimeout = Duration(seconds: 3);
    _dio.options.headers = {
      'Content-Type': 'application/json',
    };
    _dio.options.extra['withCredentials'] = true;

    _dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await getAuthToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }

  Future<void> setAuthToken(String token) async {
    _accessToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', token);
    print('Auth token set: $_accessToken'); // Debug print
  }

  Future<void> setRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('refreshToken', token);
  }

  Future<String?> getAuthToken() async {
    if (_accessToken == null) {
      final prefs = await SharedPreferences.getInstance();
      _accessToken = prefs.getString('accessToken');
    }
    return _accessToken;
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refreshToken');
  }

  Future<void> setSessionId(String sessionId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sessionId', sessionId);
    _sessionId = sessionId;
    _updateHeaders();
    print('Session ID set: $_sessionId'); // Debug print
  }

  Future<String?> getSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('sessionId');
  }

  void _updateHeaders() {
    if (_accessToken != null) {
      _dio.options.headers['Authorization'] = 'Bearer $_accessToken';
    }
    if (_sessionId != null) {
      _dio.options.headers['Cookie'] = 'musicbud_sessionid=$_sessionId';
    }
    print('Updated headers: ${_dio.options.headers}'); // Debug print
  }

  Future<List<T>> _fetchItems<T>(String endpoint, T Function(Map<String, dynamic>) fromJson, {int page = 1}) async {
    try {
      final response = await _retryWithRefresh(() => _dio.post(
        endpoint,
        data: {'page': page},
      ));

      return _parseItems<T>(response.data, fromJson);
    } catch (e, stackTrace) {
      developer.log('Error fetching items from $endpoint: $e\n$stackTrace');
      return [];
    }
  }

  List<T> _parseItems<T>(Map<String, dynamic> responseData, T Function(Map<String, dynamic>) fromJson) {
    if (responseData.containsKey('data') && responseData['data'] is List) {
      final List<dynamic> data = responseData['data'];
      return data.map((item) {
        if (item is Map<String, dynamic>) {
          try {
            return fromJson(item);
          } catch (e, stackTrace) {
            developer.log('Error parsing item: $e\n$stackTrace');
            developer.log('Problematic item: $item');
            return null;
          }
        } else {
          developer.log('Item is not a Map<String, dynamic>: $item');
          return null;
        }
      }).whereType<T>().toList();
    } else {
      developer.log('Response data does not contain a "data" list: $responseData');
      return [];
    }
  }

  Future<List<T>> _fetchCommonItems<T>(String endpoint, T Function(Map<String, dynamic>) fromJson, String budId, {int page = 1}) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: {'bud_id': budId, 'page': page},
      );

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
    try {
      final response = await _dio.post('/me/profile', data: {'service': 'spotify'});
      if (response.statusCode == 200) {
        final userData = response.data as Map<String, dynamic>;
        final userProfile = UserProfile.fromJson(userData);
        print('User profile: $userProfile'); // This will print all fields
        return userProfile;
      } else {
        throw Exception('Failed to load user profile: ${response.statusCode}');
      }
    } on DioError catch (e) {
      print('Error fetching user profile: ${e.message}');
      print('Response data: ${e.response?.data}');
      rethrow;
    }
  }

  Future<List<CommonTrack>> getTopTracks({int page = 1}) async {
    try {
      final response = await _dio.post(
        '/me/top/tracks',
        data: {'page': page},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        final List<dynamic> trackList = responseData['data'];
        return trackList.map((track) => CommonTrack.fromJson(track)).toList();
      } else {
        throw Exception('Failed to load top tracks: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading top tracks: $e');
      return []; // Return an empty list instead of throwing an exception
    }
  }

  Future<List<CommonArtist>> getTopArtists({int page = 1}) async {
    try {
      final response = await _dio.post(
        '/me/top/artists',
        data: {'page': page},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        final List<dynamic> artistList = responseData['data'];
        return artistList.map((artist) => CommonArtist.fromJson(artist)).toList();
      } else {
        throw Exception('Failed to load top artists: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading top artists: $e');
      return []; // Return an empty list instead of throwing an exception
    }
  }

  Future<List<String>> getTopGenres({int page = 1}) async {
    try {
      final response = await _dio.post(
        '/me/top/genres',
        data: {'page': page},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        final List<dynamic> genreList = responseData['data'];
        return genreList.cast<String>();
      } else {
        throw Exception('Failed to load top genres: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading top genres: $e');
      return []; // Return an empty list instead of throwing an exception
    }
  }

  Future<List<CommonAlbum>> getLikedAlbums({int page = 1}) {
    return _fetchItems('/liked/albums', CommonAlbum.fromJson, page: page);
  }

  Future<List<CommonTrack>> getPlayedTracks({int page = 1}) async {
    return _handleRequest(() async {
      final response = await _dio.post(
        '/me/played/tracks',
        data: {'page': page},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        print('Played tracks response: $responseData'); // Add this line
        final List<dynamic> trackList = responseData['data'];
        print('Played tracks list length: ${trackList.length}'); // Add this line
        return trackList.map((track) => CommonTrack.fromJson(track)).toList();
      } else {
        throw Exception('Failed to load played tracks: ${response.statusCode}');
      }
    });
  }

  Future<List<CommonAnime>> getTopAnime({int page = 1}) async {
    try {
      final response = await _dio.get('/anime/top', queryParameters: {'page': page});
      if (response.statusCode == 200) {
        final List<dynamic> animeList = response.data['data'];
        return animeList.map((anime) => CommonAnime.fromJson(anime)).toList();
      } else {
        print('Failed to load top anime: ${response.statusCode}');
        return [];
      }
    } on DioError catch (e) {
      print('DioError fetching top anime: $e');
      return [];
    } catch (e) {
      print('Error fetching top anime: $e');
      return [];
    }
  }

  Future<List<CommonManga>> getTopManga({int page = 1}) async {
    try {
      final response = await _dio.get('/manga/top', queryParameters: {'page': page});
      if (response.statusCode == 200) {
        final List<dynamic> mangaList = response.data['data'];
        return mangaList.map((manga) => CommonManga.fromJson(manga)).toList();
      } else {
        print('Failed to load top manga: ${response.statusCode}');
        return [];
      }
    } on DioError catch (e) {
      print('DioError fetching top manga: $e');
      return [];
    } catch (e) {
      print('Error fetching top manga: $e');
      return [];
    }
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

  Future<List<BudMatch>> getBuds(String endpoint, {int page = 1}) async {
    try {
      final response = await _dio.post(endpoint, data: {'page': page});
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => BudMatch.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load buds from $endpoint: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching buds from $endpoint: $e');
      rethrow;
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

  Future<List<BudMatch>> getTopBuds() async {
    try {
      final response = await _dio.post('/bud/top/artists', data: {'page': 1});
      print('Response status code: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => BudMatch.fromJson(json)).toList();
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


  Future<Map<String, dynamic>> register(String username, String password) async {
    final url = Uri.parse('$_baseUrl/register');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );

      print('Registration response status code: ${response.statusCode}');
      print('Registration response headers: ${response.headers}');
      print('Registration response body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final responseData = json.decode(response.body);
          _accessToken = responseData['access'];
          _updateHeaders();
          return responseData;
        } catch (e) {
          print('Error decoding JSON: $e');
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Registration failed: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Registration error: $e');
      rethrow;
    }
  }

  Future<bool> isAuthenticated() async {
    try {
      final response = await _dio.get('/auth/check');
      return response.statusCode == 200;
    } catch (e) {
      print('Error checking authentication: $e');
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout');
      _accessToken = null;
      _sessionId = null;
      _updateHeaders();
    } catch (e) {
      print('Error during logout: $e');
      rethrow;
    }
  }

  Future<bool> refreshToken() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null) {
        return false;
      }

      final response = await _dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        _accessToken = response.data['access_token'];
        _updateHeaders();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error refreshing token: $e');
      return false;
    }
  }

  Future<Response<dynamic>> _retryWithRefresh(Future<Response<dynamic>> Function() requestFunction) async {
    try {
      return await requestFunction();
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        final refreshed = await refreshToken();
        if (refreshed) {
          return await requestFunction();
        }
      }
      rethrow;
    }
  }

  Future<UserProfile> updateUserProfile(Map<String, dynamic> updatedData) async {
    try {
      final response = await _dio.put(
        '/me/profile',
        data: updatedData,
      );

      if (response.statusCode == 200) {
        return UserProfile.fromJson(response.data);
      } else {
        throw Exception('Failed to update user profile: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating user profile: $e');
      rethrow;
    }
  }

  Future<List<T>> fetchItems<T>(String endpoint, {int page = 1}) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: {'page': page},
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['successful'] == true) {
          final List<dynamic> data = responseData['data'] ?? [];
          return data.map((item) => item as T).toList();
        } else {
          throw Exception(responseData['message'] ?? 'Unknown error occurred');
        }
      } else {
        throw Exception('Failed to load items');
      }
    } catch (e) {
      if (e is DioError && e.response?.statusCode == 500) {
        print('Server error occurred for endpoint $endpoint: ${e.response?.data}');
        // Return an empty list of the correct type
        return <T>[];
      }
      rethrow;
    }
  }

  Future<String?> uploadProfilePhoto(String imagePath) async {
    try {
      final formData = FormData.fromMap({
        'photo': await MultipartFile.fromFile(imagePath),
      });

      final response = await _dio.post(
        '/me/upload-photo',
        data: formData,
      );

      if (response.statusCode == 200) {
        return response.data['photo_url'];
      } else {
        throw Exception('Failed to upload photo');
      }
    } catch (e) {
      print('Error uploading photo: $e');
      return null;
    }
  }

  Future<T> _handleRequest<T>(Future<T> Function() requestFunction) async {
    try {
      return await requestFunction();
    } on DioError catch (e) {
      print('DioError: ${e.message}');
      print('Response: ${e.response?.data}');
      throw Exception('Failed to complete request: ${e.message}');
    } catch (e) {
      print('Error: $e');
      throw Exception('An unexpected error occurred');
    }
  }

  Future<List<CommonTrack>> getCommonTracks(String budId) async {
    return _fetchCommonItems('/bud/common/top/tracks', CommonTrack.fromJson, budId);
  }

  Future<List<CommonArtist>> getCommonArtists(String budId) async {
    return _fetchCommonItems('/bud/common/top/artists', CommonArtist.fromJson, budId);
  }

  Future<List<CommonGenre>> getCommonGenres(String budId) async {
    return _fetchCommonItems('/bud/common/top/genres', CommonGenre.fromJson, budId);
  }

  Future<List<CommonTrack>> getCommonPlayedTracks(String budId) async {
    return _fetchCommonItems('/bud/common/played/tracks', CommonTrack.fromJson, budId);
  }

  Future<bool> login(String username, String password) async {
    try {
      print('Attempting login to $_baseUrl/login/');
      final response = await _dio.post(
        '/login/',  // Note the trailing slash
        data: {
          'username': username,
          'password': password,
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          print('Login successful: ${responseData['message']}');
          // Here you might want to handle any token or session data
          // that your server sends back, if applicable
          return true;
        } else {
          print('Login failed: ${responseData['message']}');
          return false;
        }
      } else {
        print('Login failed: ${response.statusCode} ${response.statusMessage}');
        return false;
      }
    } on DioError catch (e) {
      print('Dio error: ${e.type} - ${e.message}');
      if (e.response != null) {
        print('Response status: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
      }
      return false;
    } catch (e) {
      print('Unexpected error during login: $e');
      return false;
    }
  }
}