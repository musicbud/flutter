import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:musicbud_flutter/models/track.dart';

class ApiService {
  final Dio _dio = Dio();
  final CookieJar _cookieJar = CookieJar();
  static const String _tokenKey = 'api_token';
  static const String _sessionIdKey = 'session_id';
  final String _baseUrl = 'http://84.235.170.234'; // Replace with your actual base URL

  ApiService() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('auth_token');
        final sessionId = prefs.getString('session_id');
        
        print('Stored token: $token');
        print('Stored session ID: $sessionId');

        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
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

  Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<void> setSessionId(String sessionId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionIdKey, sessionId);
  }

  Future<String> getToken() async {
    // Implement your logic to retrieve the token
    return 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzI1MDQ1MzU0LCJpYXQiOjE3MjQ5NTg5NTQsImp0aSI6IjVhNWQ4ZWNlMTgwZjQ2NDlhYzYyZjJmYTg5NWQ4Y2VjIiwidXNlcl9pZCI6NDI4fQ.T485hEBUcu42EUHcUmWrl6Ff0Esf9r8tLLwdxtU1nEA';
  }

  Future<String> getSessionId() async {
    // Implement your logic to retrieve the session ID
    return 'your_session_id';
  }

  Future<Response> get(String url, {Map<String, dynamic>? queryParameters}) async {
    final token = await getToken();
    final sessionId = await getSessionId();
    final headers = {
      'Authorization': 'Bearer $token',
    };
    if (!kIsWeb) {
      headers['Cookie'] = 'musicbud_sessionid=$sessionId';
    }
    return _dio.get(
      url,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );
  }

  Future<Response> post(String url, {Map<String, dynamic>? data}) async {
    final token = await getToken();
    final sessionId = await getSessionId();
    final headers = {
      'Authorization': 'Bearer $token',
    };
    if (!kIsWeb) {
      headers['Cookie'] = 'musicbud_sessionid=$sessionId';
    }
    return _dio.post(
      url,
      data: data,
      options: Options(headers: headers),
    );
  }

  Future<Response> fetchTopArtists({int page = 1}) async {
    return post('$_baseUrl/me/top/artists', data: {'page': page});
  }

  Future<Response> fetchTopTracks({int page = 1}) async {
    return post('$_baseUrl/me/top/tracks', data: {'page': page});
  }

  Future<Response> fetchTopGenres({int page = 1}) async {
    return post('$_baseUrl/me/top/genres', data: {'page': page});
  }

  Future<List<Track>> getTopTracks({required int page}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final sessionId = prefs.getString('session_id');

    if (token == null || sessionId == null) {
      throw Exception('Authentication token or session ID is missing. Please log in again.');
    }

    try {
      print('Fetching top tracks for page: $page');
      final response = await _dio.post(
        '$_baseUrl/me/top/tracks',
        data: {'page': page},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Cookie': 'musicbud_sessionid=$sessionId',
          },
        ),
      );
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        final List<dynamic> tracksJson = response.data['data'];
        return tracksJson.map((json) => Track.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load tracks: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching top tracks: $e');
      rethrow;
    }
  }

  Future<void> setAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<List<String>> getTopGenres({required int page}) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/me/top/genres',
        data: {'page': page},
      );

      if (response.statusCode == 200) {
        final List<dynamic> genresJson = response.data['data'];
        return genresJson.map((genre) => genre['name'].toString()).toList();
      } else {
        throw Exception('Failed to load genres: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching top genres: $e');
      rethrow;
    }
  }
}
