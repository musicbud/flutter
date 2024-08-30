import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/track.dart';
import '../models/artist.dart';
import '../models/album.dart';
import '../models/anime.dart';
import '../models/manga.dart';
import '../models/user_profile.dart';
import '../models/genre.dart';

class ApiService {
  final Dio _dio;
  final String _baseUrl;
  String token;
  String _sessionId = '';

  ApiService()
      : _dio = Dio(),
        _baseUrl = 'http://84.235.170.234',
        token = '' {
    _initializeInterceptors();
  }

  void _initializeInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final storedToken = prefs.getString('auth_token');
        final sessionId = prefs.getString('session_id');
        
        print('Stored token: $storedToken');
        print('Stored session ID: $sessionId');

        if (storedToken != null) {
          options.headers['Authorization'] = 'Bearer $storedToken';
          token = storedToken;
        }
        if (sessionId != null) {
          options.headers['Cookie'] = 'musicbud_sessionid=$sessionId';
        }
        
        print('Request Headers: ${options.headers}');
        return handler.next(options);
      },
      onError: (DioError error, handler) {
        print('DioError: ${error.message}');
        print('DioError Response: ${error.response}');
        return handler.next(error);
      },
    ));
  }

  Future<void> setAuthToken(String newToken) async {
    token = newToken;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', newToken);
  }

  Future<void> setSessionId(String sessionId) async {
    _sessionId = sessionId;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('session_id', sessionId);
  }

  Future<UserProfile> getUserProfile() async {
    try {
      final response = await _dio.post(
        '$_baseUrl/me/profile',
        data: {
          'service': 'spotify',
          'token': token,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        print('Raw API response: ${response.data}');
        return UserProfile.fromJson(response.data);
      } else {
        throw Exception('Failed to load user profile');
      }
    } catch (e) {
      print('Error fetching user profile: $e');
      rethrow;
    }
  }

  Future<List<Track>> getTopTracks({required int page}) async {
    try {
      final response = await _dio.post('$_baseUrl/me/top/tracks', queryParameters: {'page': page});
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => Track.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load top tracks');
      }
    } catch (e) {
      print('Error fetching top tracks: $e');
      return [];
    }
  }

  Future<List<Artist>> getTopArtists({required int page}) async {
    try {
      final response = await _dio.post('$_baseUrl/me/top/artists', queryParameters: {'page': page});
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => Artist.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load top artists');
      }
    } catch (e) {
      print('Error fetching top artists: $e');
      return [];
    }
  }

  Future<List<String>> getTopGenres({required int page}) async {
    try {
      final response = await _dio.post('$_baseUrl/me/top/genres', queryParameters: {'page': page});
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => json['name'].toString()).toList();
      } else {
        throw Exception('Failed to load top genres');
      }
    } catch (e) {
      print('Error fetching top genres: $e');
      return [];
    }
  }

  Future<List<Artist>> getLikedArtists({required int page}) async {
    try {
      final response = await _dio.post('$_baseUrl/me/liked/artists', queryParameters: {'page': page});
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => Artist.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load liked artists');
      }
    } catch (e) {
      print('Error fetching liked artists: $e');
      return [];
    }
  }

  Future<List<Track>> getLikedTracks({required int page}) async {
    try {
      final response = await _dio.post('$_baseUrl/me/liked/tracks', queryParameters: {'page': page});
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => Track.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load liked tracks');
      }
    } catch (e) {
      print('Error fetching liked tracks: $e');
      return [];
    }
  }

  Future<List<String>> getLikedGenres({required int page}) async {
    try {
      final response = await _dio.post('$_baseUrl/me/liked/genres', queryParameters: {'page': page});
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => json['name'].toString()).toList();
      } else {
        throw Exception('Failed to load liked genres');
      }
    } catch (e) {
      print('Error fetching liked genres: $e');
      return [];
    }
  }

  Future<List<Album>> getLikedAlbums({required int page}) async {
    try {
      final response = await _dio.post('$_baseUrl/me/liked/albums', queryParameters: {'page': page});
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => Album.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load liked albums');
      }
    } catch (e) {
      print('Error fetching liked albums: $e');
      return [];
    }
  }

  Future<List<Track>> getPlayedTracks({required int page}) async {
    try {
      final response = await _dio.post('$_baseUrl/me/played/tracks', queryParameters: {'page': page});
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => Track.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load played tracks');
      }
    } catch (e) {
      print('Error fetching played tracks: $e');
      return [];
    }
  }

  Future<List<Anime>> getTopAnime({required int page}) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/me/top/anime',
        queryParameters: {'page': page},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Cookie': 'musicbud_sessionid=$_sessionId',
          },
        ),
      );
      if (response.statusCode == 200) {
        print('Raw API response for top anime: ${response.data}');
        final List<dynamic> data = response.data['data'];
        return data.map((json) => Anime.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load top anime');
      }
    } catch (e) {
      print('Error fetching top anime: $e');
      return [];
    }
  }

  Future<List<Manga>> getTopManga({required int page}) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/me/top/manga',
        queryParameters: {'page': page},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Cookie': 'musicbud_sessionid=$_sessionId',
          },
        ),
      );
      if (response.statusCode == 200) {
        print('Raw API response for top manga: ${response.data}');
        final List<dynamic> data = response.data['data'];
        return data.map((json) => Manga.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load top manga');
      }
    } catch (e) {
      print('Error fetching top manga: $e');
      return [];
    }
  }
}
