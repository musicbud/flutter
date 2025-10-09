
import 'package:dio/dio.dart';
import '../../models/common_track.dart';
import '../../models/common_artist.dart';
import '../../models/common_genre.dart';
import '../../models/common_album.dart';
import '../../models/user_profile.dart';
import '../../models/bud_match.dart';
import '../../models/common_item.dart';
import '../../models/categorized_common_items.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/src/form_data.dart' as dio_form;
import 'package:dio/src/multipart_file.dart' as dio_multipart;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../data/network/dio_client.dart';
import '../../core/network/network_info.dart';
import '../../data/providers/token_provider.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ApiService {
  late DioClient _dioClient;
  final NetworkInfo _networkInfo;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  String? _csrfToken;
  String? _accessToken;
  String? _refreshToken;
  DateTime? _expiresAt;

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  // For testing purposes
  void setDioClientForTesting(DioClient dioClient) {
    _dioClient = dioClient;
  }

  ApiService._internal() : _networkInfo = NetworkInfoImpl(InternetConnectionChecker.createInstance(), connectivity: Connectivity()) {
    _dioClient = DioClient(
      baseUrl: 'http://84.235.170.234', // Use ApiConfig.baseUrl
      dio: Dio(),
      tokenProvider: TokenProvider(),
    );
    _configureDio();
  }

  Future<void> _configureDio() async {
    // Add interceptors to the underlying Dio instance
    _dioClient.addInterceptor(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Request new CSRF token for non-GET requests
          if (options.method != 'GET') {
            try {
              await fetchCsrfToken();
            } catch (e) {
              _log('Error fetching CSRF token: $e');
            }
          }

          // Add CSRF token
          if (_csrfToken != null) {
            options.headers['X-CSRFToken'] = _csrfToken;
          }

          // Add JWT token
          if (await shouldRefreshToken()) {
            await refreshToken();
          }
          options.headers['Authorization'] = 'Bearer $_accessToken';
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
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
            // Token might be expired, try to refresh
            try {
              await refreshToken();
              // Retry the original request
              return handler.resolve(await retry(e.requestOptions));
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
    _dioClient.updateBaseUrl(baseUrl);
    _dioClient.updateHeaders({
      'X-Requested-With': 'XMLHttpRequest',
      'Origin': 'http://localhost:37879',
    });

    _csrfToken = await _loadCsrfToken();
    await fetchCsrfToken(); // Fetch initial CSRF token
  }

  void _log(String message) {
    developer.log(message);
  }

  // Getter for dio instance
  Dio get dio => _dioClient.dio;

  Future<void> fetchCsrfToken() async {
    try {
      final response = await _dioClient.get('/csrf-token');
      if (response.statusCode == 200 && response.data['csrfToken'] != null) {
        _csrfToken = response.data['csrfToken'];
        await _saveCsrfToken(_csrfToken!);
        _log('New CSRF token fetched: $_csrfToken');
      } else {
        _log('Failed to fetch CSRF token. Status: ${response.statusCode}');
      }
    } catch (e) {
      _log('Error fetching CSRF token: $e');
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
      _log('Fetching user profile...');
      final response = await _dioClient.post('/me/profile',
        data: {},
      );
      _log('User profile response status: ${response.statusCode}');
      _log('User profile response data: ${response.data}');
      if (response.statusCode == 200) {
        return UserProfile.fromJson(response.data);
      } else {
        throw Exception('Failed to get user profile: ${response.statusCode}');
      }
    } catch (e) {
      _log('Error getting user profile: $e');
      rethrow;
    }
  }

  Future<String> connectService(String service) async {
    try {
      final response = await _dioClient.get('/service/login', queryParameters: {'service': service});
      _log('Response status: ${response.statusCode}');
      _log('Response data: ${response.data}');

      if (response.statusCode == 200) {
        if (response.data['data'] != null && response.data['data']['authorization_link'] != null) {
          final authLink = response.data['data']['authorization_link'];
          _log('Authorization link received for $service: $authLink');
          return authLink;
        } else {
          _log('Response does not contain authorization_link in the expected structure. Full response: ${response.data}');
          throw Exception('Authorization link not found in response');
        }
      } else {
        throw Exception('Failed to get $service authorization URL. Status: ${response.statusCode}');
      }
    } catch (e) {
      _log('Error connecting to $service: $e');
      throw Exception('Error connecting to $service: $e');
    }
  }

  Future<List<CommonTrack>> getTopTracks({int page = 1}) async {
    try {
      _log('Fetching top tracks...');
      final response = await _dioClient.post('/me/top/tracks', data: {'page': page});
      _log('Top tracks response status: ${response.statusCode}');
      _log('Top tracks response data: ${response.data}');
      if (response.statusCode == 200) {
        final List<dynamic> trackList = response.data['data'];
        return trackList.map((track) => CommonTrack.fromJson(track)).toList();
      } else {
        throw Exception('Failed to load top tracks: ${response.statusCode}');
      }
    } catch (e) {
      _log('Error fetching top tracks: $e');
      rethrow;
    }
  }

  Future<List<CommonArtist>> getTopArtists({int page = 1}) async {
    try {
      _log('Fetching top artists...');
      final response = await _dioClient.post('/me/top/artists', data: {'page': page});
      _log('Top artists response: ${response.data}');
      if (response.statusCode == 200) {
        final List<dynamic> artistList = response.data['data'];
        return artistList.map((artist) => CommonArtist.fromJson(artist)).toList();
      } else {
        throw Exception('Failed to load top artists: ${response.statusCode}');
      }
    } catch (e) {
      _log('Error fetching top artists: $e');
      rethrow;
    }
  }

  Future<List<String>> getTopGenres({int page = 1}) async {
    try {
      _log('Fetching top genres...');
      final response = await _dioClient.post('/me/top/genres', data: {'page': page});
      _log('Top genres response status: ${response.statusCode}');
      _log('Top genres response data: ${response.data}');
      if (response.statusCode == 200) {
        final List<dynamic> genreList = response.data['data'];
        return genreList.map((genre) => genre['name'] as String).toList();
      } else {
        throw Exception('Failed to load top genres: ${response.statusCode}');
      }
    } catch (e) {
      _log('Error fetching top genres: $e');
      rethrow;
    }
  }

  Future<List<CommonAlbum>> getLikedAlbums({int page = 1}) async {
    return _fetchItems('/liked/albums', CommonAlbum.fromJson, page: page);
  }

  Future<List<CommonTrack>> getPlayedTracks({int page = 1}) async {
    try {
      final response = await _dioClient.post('/me/played/tracks', data: {'page': page});
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => CommonTrack.fromJson(json)).toList();
      } else {
        _log('Failed to load played tracks: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      _log('Error fetching played tracks: $e');
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
      final response = await _dioClient.post('/bud/$category');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => BudMatch.fromJson(json)).toList();
      } else {
        _log('Error fetching buds: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      _log('Error fetching buds from $category: $e');
      return [];
    }
  }

  Future<List<String>> getAvailableBudCategories() async {
    try {
      final response = await _dioClient.post('/bud/categories');
      if (response.statusCode == 200) {
        List<String> categories = List<String>.from(response.data['categories']);
        return categories;
      } else {
        _log('Error fetching bud categories: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      _log('Error fetching bud categories: $e');
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
      final response = await _dioClient.post('$endpoint?page=$page');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => BudMatch.fromJson(json)).toList();
      } else {
        _log('Error fetching buds from $endpoint: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      _log('Error fetching buds from $endpoint: $e');
      return [];
    }
  }

  Future<List<BudMatch>> getTopBuds() async {
    try {
      final response = await _dioClient.post('/bud/top/artists', data: {'page': 1});
      _log('Response status code: ${response.statusCode}');
      _log('Response data: ${response.data}');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => BudMatch.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load top buds: ${response.statusCode}');
      }
    } catch (e) {
      _log('Error fetching top buds: $e');
      rethrow;
    }
  }

  Future<List<CommonItem>> getCommonItems(String budId, String endpoint) async {
    try {
      final response = await _dioClient.post(
        endpoint,
        data: {'bud_id': budId},
      );
      _log('Response status code: ${response.statusCode}');
      _log('Response data: ${response.data}');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => CommonItem.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load common items: ${response.statusCode}');
      }
    } catch (e) {
      _log('Error fetching common items: $e');
      rethrow;
    }
  }

  Future<List<CategorizedCommonItems>> getAllCommonItems(String budId) async {
    // Simplified implementation - return empty list for now
    // This method needs to be adapted to the main app's CategorizedCommonItems model
    return [];
  }

  Future<Map<String, dynamic>> register(String username, String password, String email) async {
    final url = Uri.parse('${_dioClient.dio.options.baseUrl}/chat/register/');

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

      _log('Registration response status code: ${response.statusCode}');
      _log('Registration response headers: ${response.headers}');
      _log('Registration response body: ${response.body}');

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
      _log('Registration error: $e');
      rethrow;
    }
  }

  Future<bool> isAuthenticated() async {
    try {
      final response = await _dioClient.post('/auth/check');
      return response.statusCode == 200;
    } catch (e) {
      _log('Error checking authentication: $e');
      return false;
    }
  }

  bool isTokenExpired() {
    try {
      final parts = _dioClient.dio.options.headers['Authorization']?.split(' ');
      if (parts?.length != 2) return true;

      final token = parts?[1];
      final payload = json.decode(utf8.decode(base64Url.decode(base64Url.normalize(token!.split('.')[1]))));
      final exp = payload['exp'];
      if (exp == null) return true;

      return DateTime.fromMillisecondsSinceEpoch(exp * 1000).isBefore(DateTime.now());
    } catch (e) {
      _log('Error checking token expiration: $e');
      return true;
    }
  }

  Future<UserProfile> updateUserProfile(Map<String, dynamic> updatedData) async {
    try {
      final response = await _dioClient.put(
        '/me/profile',
        data: updatedData,
      );

      if (response.statusCode == 200) {
        return UserProfile.fromJson(response.data);
      } else {
        throw Exception('Failed to update user profile: ${response.statusCode}');
      }
    } catch (e) {
      _log('Error updating user profile: $e');
      rethrow;
    }
  }

  Future<List<T>> fetchItems<T>(String endpoint, {int page = 1}) async {
    try {
      final response = await _dioClient.post(
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
      if (e is DioException && e.response?.statusCode == 500) {
        _log('Server error occurred for endpoint $endpoint: ${e.response?.data}');
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

      final response = await _dioClient.post(
        '/me/upload-photo',
        data: formData,
      );

      if (response.statusCode == 200) {
        return response.data['photo_url'];
      } else {
        throw Exception('Failed to upload photo');
      }
    } catch (e) {
      _log('Error uploading photo: $e');
      return null;
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
      final response = await _dioClient.post(
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
      final response = await _dioClient.post(
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
      final response = await _dioClient.post('/');
      _log('API connection test response: ${response.statusCode}');
      _log('API connection test data: ${response.data}');
    } catch (e) {
      _log('API connection test error: $e');
    }
  }

  Future<void> createChannel(String channelName) async {
    try {
      _log('Creating channel: $channelName');
      final response = await _dioClient.post('/create_channel/', data: {'name': channelName});
      _log('Create channel response status: ${response.statusCode}');
      _log('Create channel response data: ${response.data}');
      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception('Failed to create channel: ${response.statusCode}');
      }
    } catch (e) {
      _log('Error creating channel: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      _log('Attempting to login with username: $username');
      final response = await _dioClient.post(
        '/login/',
        data: {'username': username, 'password': password},
      );

      _log('Login response status: ${response.statusCode}');
      _log('Login response data: ${response.data}');

      if (response.statusCode == 200) {
        if (response.data == null) {
          _log('Login response data is null');
          return {'status': 'error', 'message': 'Login failed: Response data is null'};
        }

        final data = response.data;
        _log('Response data type: ${data.runtimeType}');

        if (data is! Map<String, dynamic>) {
          _log('Response data is not a Map');
          return {'status': 'error', 'message': 'Login failed: Response data is not a Map'};
        }

        if (!data.containsKey('access_token') || !data.containsKey('refresh_token')) {
          _log('Response data does not contain "access_token" or "refresh_token" keys');
          return {'status': 'error', 'message': 'Login failed: Response data does not contain "access_token" or "refresh_token" keys'};
        }

        final accessToken = data['access_token'];
        final refreshToken = data['refresh_token'];

        if (accessToken == null || refreshToken == null) {
          _log('Access token or refresh token is null');
          return {'status': 'error', 'message': 'Login failed: Access token or refresh token is null'};
        }

        await setAuthToken(accessToken);
        await setRefreshToken(refreshToken);
        _log('Access token set: $accessToken');
        _log('Refresh token set: $refreshToken');

        // Verify that the token is stored
        final storedToken = await _secureStorage.read(key: 'access_token');
        _log('Stored access token: $storedToken');

        return {'status': 'success', 'message': 'Login successful'};
      } else {
        _log('Login failed: ${response.statusCode}');
        return {
          'status': 'error',
          'message': 'Login failed: ${response.data['message'] ?? 'Unknown error'}',
          'statusCode': response.statusCode
        };
      }
    } catch (e, stackTrace) {
      _log('Login error: $e');
      _log('Stack trace: $stackTrace');
      return {'status': 'error', 'message': 'An unexpected error occurred: $e'};
    }
  }

  Future<Map<String, dynamic>> checkServerConnectivity() async {
    try {
      _log('Checking server connectivity to ${_dioClient.dio.options.baseUrl}');
      _log('Dio configuration: ${_dioClient.dio.options.toString()}');

      final response = await _dioClient.get('/health-check');
      _log('Server response: ${response.statusCode}');
      return {
        'isReachable': true,
        'statusCode': response.statusCode,
        'data': response.data,
      };
    } on DioException catch (e) {
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

  String get baseUrl => _dioClient.dio.options.baseUrl;

  Future<void> saveLocation(double latitude, double longitude) async {
    try {
      final response = await _dioClient.post(
        '/me/location/save',
        data: {
          'latitude': latitude,
          'longitude': longitude,
        },
      );
      if (response.statusCode == 200) {
        _log('Location saved successfully');
      } else {
        _log('Failed to save location');
      }
    } catch (e) {
      _log('Error saving location: $e');
    }
  }

  Future<void> playTrackWithLocation(String trackUid, String trackName, double latitude, double longitude) async {
    if (trackUid.isEmpty) {
      _log('Error: trackUid is empty');
      throw Exception('Invalid track UID');
    }

    try {
      _log('Sending request to play track with location:');
      _log('track_id (UID): $trackUid');
      _log('track_name: $trackName');
      _log('latitude: $latitude');
      _log('longitude: $longitude');

      final response = await _dioClient.post(
        '/me/play-track-with-location',
        data: {
          'track_id': trackUid,  // Sending UID as track_id
          'track_name': trackName,
          'latitude': latitude,
          'longitude': longitude,
        },
      );

      if (response.statusCode != 200) {
        _log('Error response: ${response.statusCode}');
        _log('Error data: ${response.data}');
        throw Exception('Failed to play track with location: ${response.statusCode}');
      }

      _log('Successfully played track with location');
    } catch (e) {
      _log('Error playing track with location: $e');
      rethrow;
    }
  }

  Future<bool> likeItem(String itemType, String itemId) async {
    try {
      final response = await _dioClient.post(
        '/like/$itemType',
        data: {'id': itemId},
      );
      return response.statusCode == 200;
    } catch (e) {
      _log('Error liking $itemType: $e');
      return false;
    }
  }

  Future<bool> unlikeItem(String itemType, String itemId) async {
    try {
      final response = await _dioClient.post(
        '/unlike/$itemType',
        data: {'id': itemId},
      );
      return response.statusCode == 200;
    } catch (e) {
      _log('Error unliking $itemType: $e');
      return false;
    }
  }

  Future<List<CommonTrack>> getCurrentlyPlayedTracks() async {
    try {
      final response = await _dioClient.get('/me/currently-played');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => CommonTrack.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load currently played tracks');
      }
    } catch (e) {
      _log('Error fetching currently played tracks: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getSpotifyDevices() async {
    try {
      final response = await _dioClient.get('/spotify/devices');
      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['data'] is List) {
          return List<Map<String, dynamic>>.from(responseData['data']);
        } else {
          _log('Unexpected data structure for Spotify devices: ${responseData['data']}');
          return [];
        }
      } else {
        throw Exception('Failed to load Spotify devices: ${response.statusCode}');
      }
    } catch (e) {
      _log('Error fetching Spotify devices: $e');
      return [];
    }
  }

  Future<bool> playSpotifyTrack(String trackId, {String? deviceId}) async {
    try {
      final response = await _dioClient.post(
        '/spotify/play',
        data: {
          'track_id': trackId,
          if (deviceId != null) 'device_id': deviceId,
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      _log('Error playing Spotify track: $e');
      return false;
    }
  }

  Future<List<CommonTrack>> getPlayedTracksWithLocation() async {
    try {
      final response = await _dioClient.get('/spotify/played-tracks-with-location');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => CommonTrack.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load tracks with location');
      }
    } catch (e) {
      _log('Error fetching tracks with location: $e');
      rethrow;
    }
  }

  Future<bool> checkInternetConnectivity() async {
    return await _networkInfo.isConnected;
  }

  void logDioConfiguration() {
    _log('Dio base URL: ${_dioClient.dio.options.baseUrl}');
    _log('Dio connect timeout: ${_dioClient.dio.options.connectTimeout}');
    _log('Dio receive timeout: ${_dioClient.dio.options.receiveTimeout}');
    _log('Dio headers: ${_dioClient.dio.options.headers}');
  }

  Future<void> setAuthToken(String token) async {
    if (token.isNotEmpty) {
      await _secureStorage.write(key: 'access_token', value: token);
      _accessToken = token;
      _dioClient.updateHeaders({'Authorization': 'Bearer $token'});
    } else {
      _log('Attempted to set empty access token');
    }
  }

  Future<void> setRefreshToken(String token) async {
    if (token.isNotEmpty) {
      await _secureStorage.write(key: 'refresh_token', value: token);
      _refreshToken = token;
    } else {
      _log('Attempted to set empty refresh token');
    }
  }

  Future<void> refreshToken() async {
    final refreshToken = await _secureStorage.read(key: 'refresh_token');
    if (refreshToken == null) {
      throw Exception('No refresh token available');
    }

    try {
      final response = await _dioClient.dio.post('/chat/refresh-token/', data: {'refresh': refreshToken});
      if (response.statusCode == 200) {
        final newAccessToken = response.data['access'];
        await _secureStorage.write(key: 'access_token', value: newAccessToken);
        _accessToken = newAccessToken;
        _log('Token refreshed successfully');
      } else {
        throw Exception('Failed to refresh token');
      }
    } catch (e) {
      _log('Error refreshing token: $e');
      rethrow;
    }
  }

  Future<bool> shouldRefreshToken() async {
    if (_accessToken == null || _expiresAt == null) {
      await _loadTokens();
    }
    return _expiresAt != null && _expiresAt!.isBefore(DateTime.now().add(Duration(minutes: 5)));
  }

  Future<void> _loadTokens() async {
    _accessToken = await _secureStorage.read(key: 'access_token');
    _refreshToken = await _secureStorage.read(key: 'refresh_token');
    final expiresAtString = await _secureStorage.read(key: 'expires_at');
    if (expiresAtString != null) {
      _expiresAt = DateTime.fromMillisecondsSinceEpoch(int.parse(expiresAtString) * 1000);
    }
  }

  Future<Response<dynamic>> retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return _dioClient.dio.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }

  Future<void> updateTokens(Map<String, dynamic> data) async {
    _accessToken = data['access_token'];
    _refreshToken = data['refresh_token'];
    _expiresAt = DateTime.now().add(Duration(seconds: data['expires_in']));
    await _secureStorage.write(key: 'access_token', value: _accessToken);
    await _secureStorage.write(key: 'refresh_token', value: _refreshToken);
    await _secureStorage.write(key: 'expires_at', value: _expiresAt!.millisecondsSinceEpoch.toString());
  }

  Future<Map<String, dynamic>> handleSpotifyToken(String spotifyToken) async {
    _log('ApiService.handleSpotifyToken called with spotifyToken: $spotifyToken');
    try {
      _log('Sending GET request to /spotify/connect');
      final response = await _dioClient.post('/spotify/connect', data: {'spotify_token': spotifyToken});
      _log('Received response from /spotify/connect: ${response.statusCode}');

      if (response.statusCode == 200) {
        _log('Successfully processed callback');
        // Process the response data
        return {
          'success': true,
          'message': 'Spotify connected successfully',
          // Add other relevant data from the response
        };
      } else {
        _log('Failed to process callback. Status: ${response.statusCode}, Data: ${response.data}');
        throw Exception('Failed to process Spotify callback');
      }
    } catch (e) {
      _log('Error in handleSpotifyToken: $e');
      return {
        'success': false,
        'message': 'Failed to process Spotify callback: $e',
      };
    }
  }

  Future<Map<String, dynamic>> handleYtMusicToken(String token) async {
    _log('ApiService.handleYtMusicToken called with token: ${token.substring(0, 10)}...');
    try {
      final response = await _dioClient.post('/ytmusic/connect', data: {'ytmusic_token': token});
      if (response.statusCode == 200) {
        final userData = response.data;
        return {
          'success': true,
          'message': 'YouTube Music connected successfully',
          'user_id': userData['user_id'],
          'display_name': userData['display_name'],
        };
      } else {
        _log('Failed to process YouTube Music token. Status: ${response.statusCode}');
        throw Exception('Failed to process YouTube Music token');
      }
    } catch (e) {
      _log('Error in handleYtMusicToken: $e');
      return {
        'success': false,
        'message': 'Failed to process YouTube Music token: $e',
      };
    }
  }

  Future<Map<String, dynamic>> handleLastFmToken(String token) async {
    _log('ApiService.handleLastFmToken called with token: ${token.substring(0, 10)}...');
    try {
      final response = await _dioClient.post('/lastfm/connect', data: {'lastfm_token': token});
      if (response.statusCode == 200) {
        final userData = response.data;
        return {
          'success': true,
          'message': 'Last.fm connected successfully',
          'user_id': userData['user_id'],
          'display_name': userData['display_name'],
        };
      } else {
        _log('Failed to process Last.fm token. Status: ${response.statusCode}');
        throw Exception('Failed to process Last.fm token');
      }
    } catch (e) {
      _log('Error in handleLastFmToken: $e');
      return {
        'success': false,
        'message': 'Failed to process Last.fm token: $e',
      };
    }
  }

  Future<Map<String, dynamic>> handleMalToken(String token) async {
    _log('ApiService.handleMalToken called with token: ${token.substring(0, 10)}...');
    try {
      final response = await _dioClient.post('/mal/connect', data: {'mal_token': token});
      if (response.statusCode == 200) {
        final userData = response.data;
        return {
          'success': true,
          'message': 'MyAnimeList connected successfully',
          'user_id': userData['user_id'],
          'display_name': userData['display_name'],
        };
      } else {
        _log('Failed to process MyAnimeList token. Status: ${response.statusCode}');
        throw Exception('Failed to process MyAnimeList token');
      }
    } catch (e) {
      _log('Error in handleMalToken: $e');
      return {
        'success': false,
        'message': 'Failed to process MyAnimeList token: $e',
      };
    }
  }

  Future<Map<String, dynamic>> updateLikes(String serviceName) async {
    try {
      final response = await _dioClient.post('/me/likes/update', data: {'service': serviceName});
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Likes updated successfully for $serviceName',
          'data': response.data,
        };
      } else {
        _log('Failed to update likes for $serviceName. Status: ${response.statusCode}');
        throw Exception('Failed to update likes for $serviceName');
      }
    } catch (e) {
      _log('Error updating likes for $serviceName: $e');
      return {
        'success': false,
        'message': 'Failed to update likes for $serviceName: $e',
      };
    }
  }

  Future<List<dynamic>> getBudsByTrack(String trackId) async {
    try {
      _log('Sending request to get buds for track: $trackId');
      final response = await _dioClient.post('/bud/track', data: {'track_id': trackId});
      _log('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        if (response.data['buds'] != null) {
          return response.data['buds'] as List<dynamic>;
        } else {
          _log('Buds data is null');
          return [];
        }
      } else {
        throw Exception('Failed to get buds for track');
      }
    } catch (e) {
      _log('Error getting buds for track: $e');
      throw Exception('Error getting buds for track: $e');
    }
  }

  Future<List<dynamic>> getBudsByArtist(String artistId) async {
    try {
      _log('Sending request to get buds for artist: $artistId');
      final response = await _dioClient.post('/bud/artist', data: {'artist_id': artistId});
      _log('Response status: ${response.statusCode}');
      _log('Response data: ${response.data}');
      if (response.statusCode == 200 && response.data['buds'] != null) {
        return response.data['buds'] as List<dynamic>;
      } else {
        _log('Buds data is null or status is not 200');
        return [];
      }
    } catch (e) {
      _log('Error getting buds for artist: $e');
      throw Exception('Error getting buds for artist: $e');
    }
  }

  Future<List<dynamic>> getBudsByGenre(String genreId) async {
    try {
      _log('Sending request to get buds for genre: $genreId');
      final response = await _dioClient.post('/bud/genre', data: {'genre_id': genreId});
      _log('Response status: ${response.statusCode}');
      _log('Response data: ${response.data}');
      if (response.statusCode == 200 && response.data['buds'] != null) {
        return response.data['buds'] as List<dynamic>;
      } else {
        _log('Buds data is null or status is not 200');
        return [];
      }
    } catch (e) {
      _log('Error getting buds for genre: $e');
      throw Exception('Error getting buds for genre: $e');
    }
  }

  Future<void> playTrack(String trackIdentifier, {String? service}) async {
    try {
      final response = await _dioClient.post('/play', data: {
        'track_id': trackIdentifier,
        if (service != null) 'service': service,
      });
      if (response.statusCode != 200) {
        throw Exception('Failed to play track');
      }
    } catch (e) {
      _log('Error playing track: $e');
      throw Exception('Failed to play track: $e');
    }
  }

}
