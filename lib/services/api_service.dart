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
import 'package:dio/src/form_data.dart' as dio_form;
import 'package:dio/src/multipart_file.dart' as dio_multipart;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:io'; // Import this for File operations
import 'package:musicbud_flutter/services/logging_interceptor.dart';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ApiService {
  late Dio _dio;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  String? _csrfToken;
  bool _isFetchingToken = false;

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  ApiService._internal() {
    _dio = Dio();
    _configureDio();
  }

  Future<void> _configureDio() async {
    _dio.options.validateStatus = (status) {
      return status! < 500;
    };
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add CSRF token
          if (_csrfToken != null) {
            options.headers['X-CSRFToken'] = _csrfToken;
          }
          
          // Add JWT token
          final token = await _secureStorage.read(key: 'access_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          
          options.headers['X-Requested-With'] = 'XMLHttpRequest';
          return handler.next(options);
        },
        onResponse: (response, handler) async {
          if (response.headers.map.containsKey('set-cookie')) {
            final cookies = response.headers.map['set-cookie'];
            final newCsrfToken = cookies?.firstWhere(
              (cookie) => cookie.startsWith('csrftoken='),
              orElse: () => '',
            );
            if (newCsrfToken != null && newCsrfToken.isNotEmpty) {
              _csrfToken = newCsrfToken.split(';').first.split('=').last;
              await _saveCsrfToken(_csrfToken!);
            }
          }
          return handler.next(response);
        },
        onError: (DioError e, handler) async {
          if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
            // Token might be expired, try to refresh
            try {
              await refreshToken();
              // Retry the original request
              return handler.resolve(await _retry(e.requestOptions));
            } catch (_) {
              // If refresh fails, proceed with the error
              return handler.next(e);
            }
          }
          return handler.next(e);
        },
      ),
    );
    _csrfToken = await _loadCsrfToken();
  }

  Future<void> _saveCsrfToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('csrfToken', token);
  }

  Future<String?> _loadCsrfToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('csrfToken');
  }

  Future<void> initialize(String baseUrl) async {
    _log('Initializing ApiService with base URL: $baseUrl');
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = Duration(seconds: 5);
    _dio.options.receiveTimeout = Duration(seconds: 3);
    _dio.options.headers = {
      'X-Requested-With': 'XMLHttpRequest',
      // 'Origin': 'http://localhost:36451',
    };

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        _log('Interceptor: onRequest called for ${options.path}');
        try {
          final token = await _secureStorage.read(key: 'access_token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          
          if (options.method != 'GET') {
            await _ensureCsrfToken();
            if (_csrfToken != null) {
              options.headers['X-CSRFToken'] = _csrfToken;
            } else {
              _log('Warning: CSRF token is still null after attempting to fetch it');
            }
          }

          _log('Interceptor: Request Headers:');
          options.headers.forEach((key, value) {
            _log('$key: $value');
          });
          return handler.next(options);
        } catch (e) {
          _log('Interceptor: Error in onRequest: $e');
          // If fetching CSRF token fails, continue with the request without it
          return handler.next(options);
        }
      },
      onResponse: (response, handler) {
        _log('Interceptor: onResponse called for ${response.requestOptions.path}');
        _log('Response status: ${response.statusCode}');
        return handler.next(response);
      },
      onError: (DioError error, handler) {
        _log('Interceptor: onError called for ${error.requestOptions.path}');
        _log('Error: ${error.message}');
        _log('Error response: ${error.response}');
        return handler.next(error);
      },
    ));
    _log('ApiService initialization complete');
    await fetchCsrfToken(); // Fetch initial CSRF token
  }
  void _log(String message) {
    developer.log(message);
    print(message); // This will output to the terminal
  }
  // Getter for dio instance
  Dio get dio => _dio;

  Future<void> _ensureCsrfToken() async {
    if (_csrfToken != null) return;

    try {
      final response = await _dio.get('/csrf-token');
      if (response.statusCode == 200 && response.data['csrfToken'] != null) {
        _csrfToken = response.data['csrfToken'];
        print('CSRF token fetched: $_csrfToken');
      } else {
        throw Exception('Failed to fetch CSRF token');
      }
    } catch (e) {
      print('Error fetching CSRF token: $e');
      rethrow;
    }
  }

  Future<void> fetchCsrfToken() async {
    try {
      final response = await _dio.get('/csrf-token');
      if (response.statusCode == 200 && response.data['csrfToken'] != null) {
        _csrfToken = response.data['csrfToken'];
        await _saveCsrfToken(_csrfToken!);
        print('New CSRF token fetched: $_csrfToken');
      } else {
        print('Failed to fetch CSRF token. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching CSRF token: $e');
    }
  }
  

  Future<void> _fetchCsrfToken() async {
    try {
      developer.log('Fetching CSRF token from ${_dio.options.baseUrl}/csrf-token');
      final response = await _dio.get(
        '/csrf-token',
        options: Options(
          headers: {'X-Requested-With': 'XMLHttpRequest'},
          sendTimeout: Duration(seconds: 10),
          receiveTimeout: Duration(seconds: 10),
        ),
      );
      
      developer.log('CSRF token response status: ${response.statusCode}');
      developer.log('CSRF token response data: ${response.data}');
      
      if (response.statusCode == 200 && response.data != null && response.data['csrfToken'] != null) {
        _csrfToken = response.data['csrfToken'];
        developer.log('CSRF Token fetched: $_csrfToken');
      } else {
        throw Exception('Failed to load CSRF token: ${response.statusCode}');
      }
    } on DioError catch (e) {
      developer.log('DioException while fetching CSRF token: ${e.type}');
      developer.log('DioException message: ${e.message}');
      developer.log('DioException response: ${e.response}');
      if (e.type == DioErrorType.connectionTimeout) {
        throw Exception('Connection timeout while fetching CSRF token');
      } else if (e.type == DioErrorType.receiveTimeout) {
        throw Exception('Receive timeout while fetching CSRF token');
      } else {
        throw Exception('Failed to fetch CSRF token: ${e.message}');
      }
    } catch (e) {
      developer.log('Unexpected error fetching CSRF token: $e');
      rethrow;
    }
  }

  
  Future<void> setLoggedIn(bool value) async {
    await _secureStorage.write(key: 'is_logged_in', value: value.toString());
  }

  Future<bool> isLoggedIn() async {
    final value = await _secureStorage.read(key: 'is_logged_in');
    return value == 'true';
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'access_token');
    await _secureStorage.delete(key: 'refresh_token');
    await _secureStorage.delete(key: 'is_logged_in');
  }

  Future<UserProfile> getUserProfile() async {
    try {
      await fetchCsrfToken(); // Fetch the latest CSRF token
      print('Fetching user profile...');
      final response = await _dio.post('/me/profile',
        options: Options(
          headers: {
            'X-CSRFToken': _csrfToken,
          },
        ),
      );
      print('User profile response status: ${response.statusCode}');
      print('User profile response data: ${response.data}');
      if (response.statusCode == 200) {
        return UserProfile.fromJson(response.data);
      } else {
        throw Exception('Failed to get user profile: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting user profile: $e');
      rethrow;
    }
  }

  Future<String> connectSpotify() async {
    try {
      final response = await _dio.get('/service/login');
      print('Spotify connect response: ${response.data}');  // Debug print
      
      if (response.statusCode == 200 && 
          response.data['data'] != null &&
          response.data['data']['authorization_link'] != null) {
        return response.data['data']['authorization_link'];
      } else {
        throw Exception('Failed to get Spotify authorization URL. Status: ${response.statusCode}, Data: ${response.data}');
      }
    } catch (e) {
      throw Exception('Error connecting to Spotify: $e');
    }
  }

  Future<Map<String, dynamic>> handleSpotifyCallback(String code) async {
    try {
      final response = await _dio.post('/spotify/callback', data: {'code': code});
      
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to connect Spotify account: ${response.statusCode}');
      }
    } catch (e) {
      print('Error handling Spotify callback: $e');
      return {
        'code': 500,
        'message': 'Failed to connect Spotify account: $e',
        'status': 'error',
      };
    }
  }

  Future<List<CommonTrack>> getTopTracks({int page = 1}) async {
    try {
      print('Fetching top tracks...');
      final response = await _dio.post('/me/top/tracks', data: {'page': page});
      print('Top tracks response status: ${response.statusCode}');
      print('Top tracks response data: ${response.data}');
      if (response.statusCode == 200) {
        final List<dynamic> trackList = response.data['data'];
        return trackList.map((track) => CommonTrack.fromJson(track)).toList();
      } else {
        throw Exception('Failed to load top tracks: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching top tracks: $e');
      rethrow;
    }
  }

  Future<List<CommonArtist>> getTopArtists({int page = 1}) async {
    try {
      print('Fetching top artists...');
      final response = await _dio.post('/me/top/artists', data: {'page': page});
      print('Top artists response: ${response.data}');
      if (response.statusCode == 200) {
        final List<dynamic> artistList = response.data['data'];
        return artistList.map((artist) => CommonArtist.fromJson(artist)).toList();
      } else {
        throw Exception('Failed to load top artists: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching top artists: $e');
      rethrow;
    }
  }

  Future<List<String>> getTopGenres({int page = 1}) async {
    try {
      print('Fetching top genres...');
      final response = await _dio.post('/me/top/genres', data: {'page': page});
      print('Top genres response status: ${response.statusCode}');
      print('Top genres response data: ${response.data}');
      if (response.statusCode == 200) {
        final List<dynamic> genreList = response.data['data'];
        return genreList.map((genre) => genre['name'] as String).toList();
      } else {
        throw Exception('Failed to load top genres: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching top genres: $e');
      rethrow;
    }
  }

  Future<List<CommonAlbum>> getLikedAlbums({int page = 1}) async {
    return _fetchItems('/liked/albums', CommonAlbum.fromJson, page: page);
  }

  Future<List<CommonTrack>> getPlayedTracks({int page = 1}) async {
    try {
      final response = await _dio.post('/me/played/tracks', data: {'page': page});
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => CommonTrack.fromJson(json)).toList();
      } else {
        print('Failed to load played tracks: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching played tracks: $e');
      return [];
    }
  }

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

  Future<List<CommonArtist>> getCommonTopArtists(String budId) async {
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

  Future<List<BudMatch>> getBuds(String category) async {
    try {
      final response = await _dio.post('/bud/$category');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => BudMatch.fromJson(json)).toList();
      } else {
        print('Error fetching buds: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching buds from $category: $e');
      return [];
    }
  }

  Future<List<String>> getAvailableBudCategories() async {
    try {
      final response = await _dio.post('/bud/categories');
      if (response.statusCode == 200) {
        List<String> categories = List<String>.from(response.data['categories']);
        return categories;
      } else {
        print('Error fetching bud categories: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching bud categories: $e');
      return [
        'liked/artists',
        'liked/tracks',
        'liked/genres',
        'top/artists',
        'top/tracks',
        'top/genres',
        'liked/aio',
        'played/tracks'
      ];
    }
  }

  Future<List<BudMatch>> _fetchBuds(String endpoint, {int page = 1}) async {
    try {
      final response = await _dio.post('$endpoint?page=$page');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => BudMatch.fromJson(json)).toList();
      } else {
        print('Error fetching buds from $endpoint: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching buds from $endpoint: $e');
      return [];
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

  Future<Map<String, dynamic>> register(String username, String password, String email) async {
    final url = Uri.parse('${_dio.options.baseUrl}/chat/register/');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'username': username,
          'email': email,
          'password1': password,
          'password2': password,
        }),
      );

      print('Registration response status code: ${response.statusCode}');
      print('Registration response headers: ${response.headers}');
      print('Registration response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success' && responseData['tokens'] != null) {
          // Store the tokens
          await setAuthToken(
            responseData['tokens']['access'],
          );
          await setLoggedIn(true);
        }
        return responseData;
      } else {
        throw Exception('Registration failed: ${response.statusCode} ${response.reasonPhrase}\n${response.body}');
      }
    } catch (e) {
      print('Registration error: $e');
      rethrow;
    }
  }

  Future<bool> isAuthenticated() async {
    try {
      final response = await _dio.post('/auth/check');
      return response.statusCode == 200;
    } catch (e) {
      print('Error checking authentication: $e');
      return false;
    }
  }

  bool isTokenExpired() {
    try {
      final parts = _dio.options.headers['Authorization']?.split(' ');
      if (parts?.length != 2) return true;
      
      final token = parts?[1];
      final payload = json.decode(utf8.decode(base64Url.decode(base64Url.normalize(token!.split('.')[1]))));
      final exp = payload['exp'];
      if (exp == null) return true;
      
      return DateTime.fromMillisecondsSinceEpoch(exp * 1000).isBefore(DateTime.now());
    } catch (e) {
      print('Error checking token expiration: $e');
      return true;
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
        return <T>[];
      }
      rethrow;
    }
  }

  Future<String?> uploadProfilePhoto(String imagePath) async {
    try {
      final formData = dio_form.FormData.fromMap({
        'photo': await dio_multipart.MultipartFile.fromFile(imagePath),
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

  Future<List<CommonTrack>> getCommonTracks(String budUid) async {
    return _fetchCommonItems('/bud/common/top/tracks', CommonTrack.fromJson, budUid);
  }

  Future<List<CommonArtist>> getCommonArtists(String budUid) async {
    return _fetchCommonItems('/bud/common/top/artists', CommonArtist.fromJson, budUid);
  }

  Future<List<CommonGenre>> getCommonGenres(String budUid) async {
    return _fetchCommonItems('/bud/common/top/genres', CommonGenre.fromJson, budUid);
  }

  Future<List<CommonTrack>> getCommonPlayedTracks(String budUid, {int page = 1}) async {
    return _fetchCommonItems('/bud/common/played/tracks', CommonTrack.fromJson, budUid, page: page);
  }

  Future<List<T>> _fetchItems<T>(String endpoint, T Function(Map<String, dynamic>) fromJson, {int page = 1}) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: {'page': page},
      );

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

  Future<List<T>> _fetchCommonItems<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson,
    String budId,
    {int page = 1}
  ) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: {'bud_id': budId, 'page': page},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((item) => fromJson(item)).toList();
      } else {
        throw Exception('Failed to load common items: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      developer.log('Error fetching items from $endpoint: $e\n$stackTrace');
      return [];
    }
  }

  Future<void> testApiConnection() async {
    try {
      final response = await _dio.post('/');
      print('API connection test response: ${response.statusCode}');
      print('API connection test data: ${response.data}');
    } catch (e) {
      print('API connection test error: $e');
    }
  }

  Future<void> createChannel(String channelName) async {
    try {
      print('Creating channel: $channelName');
      final response = await _dio.post('/create_channel/', data: {'name': channelName});
      print('Create channel response status: ${response.statusCode}');
      print('Create channel response data: ${response.data}');
      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception('Failed to create channel: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating channel: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      print('Attempting to login with username: $username');
      final response = await _dio.post(
        '/chat/login/',
        data: {'username': username, 'password': password},
      );
      
      print('Login response status: ${response.statusCode}');
      print('Login response data: ${response.data}');
      
      if (response.statusCode == 200) {
        if (response.data == null) {
          print('Login response data is null');
          return {'status': 'error', 'message': 'Login failed: Response data is null'};
        }
        
        final data = response.data;
        print('Response data type: ${data.runtimeType}');
        
        if (data is! Map<String, dynamic>) {
          print('Response data is not a Map');
          return {'status': 'error', 'message': 'Login failed: Response data is not a Map'};
        }
        
        if (!data.containsKey('access_token') || !data.containsKey('refresh_token')) {
          print('Response data does not contain "access_token" or "refresh_token" keys');
          return {'status': 'error', 'message': 'Login failed: Response data does not contain "access_token" or "refresh_token" keys'};
        }
        
        final accessToken = data['access_token'];
        final refreshToken = data['refresh_token'];
        
        if (accessToken == null || refreshToken == null) {
          print('Access token or refresh token is null');
          return {'status': 'error', 'message': 'Login failed: Access token or refresh token is null'};
        }
        
        await setAuthToken(accessToken);
        await setRefreshToken(refreshToken);
        print('Access token set: $accessToken');
        print('Refresh token set: $refreshToken');

        // Verify that the token is stored
        final storedToken = await _secureStorage.read(key: 'access_token');
        print('Stored access token: $storedToken');

        return {'status': 'success', 'message': 'Login successful'};
      } else {
        print('Login failed: ${response.statusCode}');
        return {
          'status': 'error',
          'message': 'Login failed: ${response.data['message'] ?? 'Unknown error'}',
          'statusCode': response.statusCode
        };
      }
    } catch (e, stackTrace) {
      print('Login error: $e');
      print('Stack trace: $stackTrace');
      return {'status': 'error', 'message': 'An unexpected error occurred: $e'};
    }
  }

  Future<Map<String, dynamic>> checkServerConnectivity() async {
    try {
      _log('Checking server connectivity to ${_dio.options.baseUrl}');
      _log('Dio configuration: ${_dio.options.toString()}');
      
      final response = await _dio.get('/health-check',
        options: Options(
          sendTimeout: Duration(seconds: 10),
          receiveTimeout: Duration(seconds: 10),
        ),
      );
      _log('Server response: ${response.statusCode}');
      return {
        'isReachable': true,
        'statusCode': response.statusCode,
        'data': response.data,
      };
    } on DioError catch (e) {
      _log('DioError during server connectivity check: ${e.type}');
      _log('DioError message: ${e.message}');
      _log('DioError response: ${e.response}');
      return {
        'isReachable': false,
        'error': 'DioError',
        'type': e.type.toString(),
        'message': e.message,
      };
    } catch (e) {
      _log('Unexpected error during server connectivity check: $e');
      return {
        'isReachable': false,
        'error': 'UnexpectedException',
        'message': e.toString(),
      };
    }
  }

  String get baseUrl => _dio.options.baseUrl;

  Future<String?> _getCookies() async {
    return await _secureStorage.read(key: 'cookies');
  }

  Future<void> saveLocation(double latitude, double longitude) async {
    try {
      final response = await _dio.post(
        '/me/location/save',
        data: {
          'latitude': latitude,
          'longitude': longitude,
        },
      );
      if (response.statusCode == 200) {
        print('Location saved successfully');
      } else {
        print('Failed to save location');
      }
    } catch (e) {
      print('Error saving location: $e');
    }
  }

  Future<void> playTrackWithLocation(String trackUid, String trackName, double latitude, double longitude) async {
    if (trackUid.isEmpty) {
      print('Error: trackUid is empty');
      throw Exception('Invalid track UID');
    }

    try {
      print('Sending request to play track with location:');
      print('track_id (UID): $trackUid');
      print('track_name: $trackName');
      print('latitude: $latitude');
      print('longitude: $longitude');

      final response = await _dio.post(
        '/me/play-track-with-location',
        data: {
          'track_id': trackUid,  // Sending UID as track_id
          'track_name': trackName,
          'latitude': latitude,
          'longitude': longitude,
        },
      );

      if (response.statusCode != 200) {
        print('Error response: ${response.statusCode}');
        print('Error data: ${response.data}');
        throw Exception('Failed to play track with location: ${response.statusCode}');
      }

      print('Successfully played track with location');
    } catch (e) {
      print('Error playing track with location: $e');
      rethrow;
    }
  }

  Future<bool> likeItem(String itemType, String itemId) async {
    try {
      final response = await _dio.post(
        '/like/$itemType',
        data: {'id': itemId},
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error liking $itemType: $e');
      return false;
    }
  }

  Future<bool> unlikeItem(String itemType, String itemId) async {
    try {
      final response = await _dio.post(
        '/unlike/$itemType',
        data: {'id': itemId},
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error unliking $itemType: $e');
      return false;
    }
  }

  Future<List<CommonTrack>> getCurrentlyPlayedTracks() async {
    try {
      final response = await _dio.get('/me/currently-played');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => CommonTrack.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load currently played tracks');
      }
    } catch (e) {
      print('Error fetching currently played tracks: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getSpotifyDevices() async {
    try {
      final response = await _dio.get('/spotify/devices');
      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['data'] is List) {
          return List<Map<String, dynamic>>.from(responseData['data']);
        } else {
          print('Unexpected data structure for Spotify devices: ${responseData['data']}');
          return [];
        }
      } else {
        throw Exception('Failed to load Spotify devices: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching Spotify devices: $e');
      return [];
    }
  }

  Future<bool> playSpotifyTrack(String trackId, {String? deviceId}) async {
    try {
      final response = await _dio.post(
        '/spotify/play',
        data: {
          'track_id': trackId,
          if (deviceId != null) 'device_id': deviceId,
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error playing Spotify track: $e');
      return false;
    }
  }

  Future<List<CommonTrack>> getPlayedTracksWithLocation() async {
    try {
      final response = await _dio.get('/spotify/played-tracks-with-location');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => CommonTrack.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load tracks with location');
      }
    } catch (e) {
      print('Error fetching tracks with location: $e');
      rethrow;
    }
  }

  Future<String> getConnectUrl(String service) async {
    final response = await _dio.get('/$service/connect');
    if (response.statusCode == 200 && response.data['url'] != null) {
      return response.data['url'];
    } else {
      throw Exception('Failed to get connection URL for $service');
    }
  }

  Future<Map<String, bool>> getConnectedServices() async {
    try {
      final response = await _dio.get('/service/login');
      if (response.statusCode == 200) {
        return Map<String, bool>.from(response.data);
      } else {
        throw Exception('Failed to fetch connected services');
      }
    } catch (e) {
      print('Error fetching connected services: $e');
      rethrow;
    }
  }

  Future<String> getSpotifyAuthorizationLink() async {
    try {
      final response = await _dio.get('/service/login');
      if (response.statusCode == 200 && response.data['data']['authorization_link'] != null) {
        return response.data['data']['authorization_link'];
      } else {
        throw Exception('Failed to get Spotify authorization link');
      }
    } catch (e) {
      print('Error getting Spotify authorization link: $e');
      rethrow;
    }
  }

  Future<bool> isSpotifyConnected() async {
    final expiresAt = await _secureStorage.read(key: 'spotify_expires_at');
    if (expiresAt != null) {
      final expirationTime = DateTime.fromMillisecondsSinceEpoch(int.parse(expiresAt) * 1000);
      return expirationTime.isAfter(DateTime.now());
    }
    return false;
  }

  Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  void logDioConfiguration() {
    _log('Dio base URL: ${_dio.options.baseUrl}');
    _log('Dio connect timeout: ${_dio.options.connectTimeout}');
    _log('Dio receive timeout: ${_dio.options.receiveTimeout}');
    _log('Dio headers: ${_dio.options.headers}');
  }

  Future<void> setAuthToken(String token) async {
    if (token.isNotEmpty) {
      await _secureStorage.write(key: 'access_token', value: token);
      _dio.options.headers['Authorization'] = 'Bearer $token';
    } else {
      print('Attempted to set empty access token');
    }
  }

  Future<void> setRefreshToken(String token) async {
    if (token.isNotEmpty) {
      await _secureStorage.write(key: 'refresh_token', value: token);
    } else {
      print('Attempted to set empty refresh token');
    }
  }

  Future<void> refreshToken() async {
    final refreshToken = await _secureStorage.read(key: 'refresh_token');
    if (refreshToken == null) {
      throw Exception('No refresh token available');
    }

    try {
      final response = await _dio.post('/chat/refresh-token/', data: {'refresh': refreshToken});
      if (response.statusCode == 200) {
        final newAccessToken = response.data['access'];
        await _secureStorage.write(key: 'access_token', value: newAccessToken);
        print('Token refreshed successfully');
      } else {
        throw Exception('Failed to refresh token');
      }
    } catch (e) {
      print('Error refreshing token: $e');
      rethrow;
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return _dio.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }
}


  

