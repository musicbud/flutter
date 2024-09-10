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

class ApiService {
  static final ApiService _instance = ApiService._internal();
  late Dio _dio;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  factory ApiService() => _instance;

  ApiService._internal();

  void init(String baseUrl) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add the logging interceptor
    _dio.interceptors.add(LoggingInterceptor());

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Get the access token from secure storage
          final accessToken = await _secureStorage.read(key: 'access_token');
          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          return handler.next(options);
        },
        onError: (DioError e, handler) async {
          if (e.response?.statusCode == 401) {
            // Token might be expired, try to refresh it
            if (await refreshToken()) {
              // Retry the original request
              return handler.resolve(await _retry(e.requestOptions));
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;

  Future<bool> refreshToken() async {
    try {
      final refreshToken = await _secureStorage.read(key: 'refresh_token');
      if (refreshToken == null) {
        return false;
      }

      final response = await _dio.post(
        '/auth/token/refresh/',
        data: {'refresh': refreshToken},
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['access'];
        await _secureStorage.write(key: 'access_token', value: newAccessToken);
        return true;
      }
    } catch (e) {
      print('Error refreshing token: $e');
    }
    return false;
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return _dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: 'access_token');
  }

  void setAuthToken(String accessToken, String refreshToken) {
    _secureStorage.write(key: 'access_token', value: accessToken);
    _secureStorage.write(key: 'refresh_token', value: refreshToken);
  }

  Future<void> setLoggedIn(bool value) async {
    await _secureStorage.write(key: 'isLoggedIn', value: value.toString());
    print('isLoggedIn set to: $value');
  }

  Future<bool> isLoggedIn() async {
    final value = await _secureStorage.read(key: 'isLoggedIn');
    final isLoggedIn = value == 'true';
    print('isLoggedIn checked: $isLoggedIn');
    return isLoggedIn;
  }

  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout');
      await setLoggedIn(false);
    } catch (e) {
      print('Error during logout: $e');
      rethrow;
    }
  }

  Future<UserProfile> getUserProfile() async {
    try {
      final response = await _dio.post('/me/profile');
      if (response.statusCode == 200) {
        return UserProfile.fromJson(response.data);
      } else {
        throw Exception('Failed to load user profile');
      }
    } catch (e) {
      print('Error getting user profile: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getUserProfileWithCsrf() async {
    try {
      final csrfToken = await _getCsrfToken();
      final cookies = await _getCookies();

      final response = await _dio.post(
        '/me/profile',
        options: Options(
          headers: {
            'X-CSRFToken': csrfToken ?? '',
            'Cookie': cookies ?? '',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load user profile: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user profile: $e');
      rethrow;
    }
  }

  Future<String?> _getCsrfToken() async {
    return await _secureStorage.read(key: 'csrf_token');
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
        final List<dynamic> data = response.data['data'];
        return data.map((json) => CommonTrack.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load played tracks: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching played tracks: $e');
      rethrow;
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

  Future<Map<String, dynamic>> register(String username, String password) async {
    final url = Uri.parse('${_dio.options.baseUrl}/register');

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
      final response = await _dio.post(
        '/chat/login/',
        data: {
          'username': username,
          'password': password,
        },
        options: Options(
          validateStatus: (status) => status! < 500,
        ),
      );

      print('Login response status code: ${response.statusCode}');
      print('Login response data: ${response.data}');

      if (response.statusCode == 200) {
        try {
          final responseData = response.data as Map<String, dynamic>;
          final tokens = responseData['tokens'] as Map<String, dynamic>?;
          if (tokens != null) {
            final accessToken = tokens['access'] as String?;
            final refreshToken = tokens['refresh'] as String?;
            if (accessToken != null && refreshToken != null) {
              setAuthToken(accessToken, refreshToken);
            }
          }
          return {
            'success': true,
            'user': responseData['user'] ?? {},
            'message': 'Login successful'
          };
        } catch (e) {
          print('Error parsing response: $e');
          return {
            'success': false,
            'message': 'Error parsing server response'
          };
        }
      } else {
        return {
          'success': false,
          'message': response.data is Map ? response.data['detail'] ?? 'Login failed' : 'Login failed'
        };
      }
    } on DioError catch (e) {
      print('DioError during login: $e');
      return {
        'success': false,
        'message': 'Network error occurred'
      };
    } catch (e) {
      print('Unexpected error during login: $e');
      return {
        'success': false,
        'message': 'An unexpected error occurred'
      };
    }
  }

  Future<String?> _getCookies() async {
    return await _secureStorage.read(key: 'cookies');
  }
}