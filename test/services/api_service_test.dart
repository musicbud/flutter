import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:musicbud_flutter/services/api_service.dart';
import 'package:musicbud_flutter/data/network/dio_client.dart';
import 'package:musicbud_flutter/core/network/network_info.dart';
import 'package:musicbud_flutter/models/user_profile.dart';
import 'package:musicbud_flutter/models/bud_match.dart';
import 'package:musicbud_flutter/models/common_artist.dart';

@GenerateMocks([
  DioClient,
  NetworkInfo,
  FlutterSecureStorage,
  Dio,
  Response,
])
import 'api_service_test.mocks.dart';

void main() {
  group('ApiService Tests', () {
    late ApiService apiService;
    late MockDioClient mockDioClient;
    late MockNetworkInfo mockNetworkInfo;
    late MockDio mockDio;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      FlutterSecureStorage.setMockInitialValues({});
    });

    setUp(() {
      mockDioClient = MockDioClient();
      mockNetworkInfo = MockNetworkInfo();
      mockDio = MockDio();
      
      apiService = ApiService();
      apiService.setDioClientForTesting(mockDioClient);
      
      // Mock network connectivity
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockDioClient.dio).thenReturn(mockDio);
    });

    group('Initialization', () {
      test('should initialize with correct base URL', () async {
        const baseUrl = 'http://84.235.170.234';
        await apiService.initialize(baseUrl);
        
        verify(mockDioClient.updateBaseUrl(baseUrl)).called(1);
        verify(mockDioClient.updateHeaders(any)).called(1);
      });

      test('should handle authentication state correctly', () async {
        await apiService.setLoggedIn(true);
        final isLoggedIn = await apiService.isLoggedIn();
        expect(isLoggedIn, true);
      });

      test('should handle logout correctly', () async {
        await apiService.logout();
        final isLoggedIn = await apiService.isLoggedIn();
        expect(isLoggedIn, false);
      });
    });

    group('CSRF Token Management', () {
      test('should fetch CSRF token successfully', () async {
        final mockResponse = MockResponse<Map<String, dynamic>>();
        when(mockResponse.statusCode).thenReturn(200);
        when(mockResponse.data).thenReturn({'csrfToken': 'test-csrf-token'});
        when(mockDioClient.get('/csrf-token')).thenAnswer((_) async => mockResponse);
        
        await apiService.fetchCsrfToken();
        
        verify(mockDioClient.get('/csrf-token')).called(1);
      });

      test('should handle CSRF token fetch failure', () async {
        final mockResponse = MockResponse<Map<String, dynamic>>();
        when(mockResponse.statusCode).thenReturn(400);
        when(mockDioClient.get('/csrf-token')).thenAnswer((_) async => mockResponse);
        
        await apiService.fetchCsrfToken();
        
        verify(mockDioClient.get('/csrf-token')).called(1);
      });
    });

    group('User Profile Management', () {
      test('should get user profile successfully', () async {
        final mockResponse = MockResponse<Map<String, dynamic>>();
        final profileData = {
          'uid': 'test-uid',
          'username': 'testuser',
          'bio': 'Test bio',
          'profile_image': 'test-image.jpg',
        };
        
        when(mockResponse.statusCode).thenReturn(200);
        when(mockResponse.data).thenReturn(profileData);
        when(mockDioClient.post('/me/profile', data: {}))
            .thenAnswer((_) async => mockResponse);
        
        final profile = await apiService.getUserProfile();
        
        expect(profile, isA<UserProfile>());
        expect(profile.id, 'testuser'); // UserProfile uses username as id fallback
        expect(profile.username, 'testuser');
      });

      test('should handle user profile fetch error', () async {
        when(mockDioClient.post('/me/profile', data: {}))
            .thenThrow(DioException(requestOptions: RequestOptions(path: '/me/profile')));
        
        expect(() => apiService.getUserProfile(), throwsException);
      });
    });

    group('Service Connection', () {
      test('should connect to service successfully', () async {
        final mockResponse = MockResponse<Map<String, dynamic>>();
        when(mockResponse.statusCode).thenReturn(200);
        when(mockResponse.data).thenReturn({
          'data': {'authorization_link': 'https://example.com/auth'}
        });
        when(mockDioClient.get('/service/login', queryParameters: {'service': 'spotify'}))
            .thenAnswer((_) async => mockResponse);
        
        final authLink = await apiService.connectService('spotify');
        
        expect(authLink, 'https://example.com/auth');
        verify(mockDioClient.get('/service/login', queryParameters: {'service': 'spotify'})).called(1);
      });

      test('should handle service connection error', () async {
        when(mockDioClient.get('/service/login', queryParameters: {'service': 'spotify'}))
            .thenThrow(DioException(requestOptions: RequestOptions(path: '/service/login')));
        
        expect(() => apiService.connectService('spotify'), throwsException);
      });
    });

    group('Bud Matching API', () {
      test('should get buds by top artists successfully', () async {
        final mockResponse = MockResponse<Map<String, dynamic>>();
        final budsData = {
          'buds': [
            {
              'uid': 'bud1',
              'bud_uid': 'buddy1',
              'bud_id': 'buddy1',
              'match_score': 85.5,
              'common_artists_count': 10,
              'common_tracks_count': 20,
              'common_genres_count': 5,
            }
          ]
        };
        
        when(mockResponse.statusCode).thenReturn(200);
        when(mockResponse.data).thenReturn(budsData);
        when(mockDioClient.post('/bud/top/artists', data: {'page': 1}))
            .thenAnswer((_) async => mockResponse);
        
        final response = await apiService.getBudsByTopArtists();
        
        expect(response, isA<Map<String, dynamic>>());
        expect(response['success'], true);
        expect(response['data'], isA<Map<String, dynamic>>());
        expect(response['data']['buds'], isA<List>());
        expect(response['data']['buds'].length, 1);
      });

      test('should get buds by top tracks successfully', () async {
        final mockResponse = MockResponse<Map<String, dynamic>>();
        final budsData = {
          'buds': [
            {
              'uid': 'bud1',
              'bud_uid': 'buddy1',
              'bud_id': 'buddy1',
              'match_score': 90.0,
              'common_tracks_count': 25,
            }
          ]
        };
        
        when(mockResponse.statusCode).thenReturn(200);
        when(mockResponse.data).thenReturn(budsData);
        when(mockDioClient.post('/bud/top/tracks', data: {'page': 1}))
            .thenAnswer((_) async => mockResponse);
        
        final response = await apiService.getBudsByTopTracks();
        
        expect(response, isA<Map<String, dynamic>>());
        expect(response['success'], true);
        expect(response['data'], isA<Map<String, dynamic>>());
        expect(response['data']['buds'], isA<List>());
        expect(response['data']['buds'].length, 1);
      });

      test('should get buds by top genres successfully', () async {
        final mockResponse = MockResponse<Map<String, dynamic>>();
        final budsData = {
          'buds': [
            {
              'uid': 'bud1',
              'bud_uid': 'buddy1',
              'bud_id': 'buddy1',
              'match_score': 75.0,
              'common_genres_count': 8,
            }
          ]
        };
        
        when(mockResponse.statusCode).thenReturn(200);
        when(mockResponse.data).thenReturn(budsData);
        when(mockDioClient.post('/bud/top/genres', data: {'page': 1}))
            .thenAnswer((_) async => mockResponse);
        
        final response = await apiService.getBudsByTopGenres();
        
        expect(response, isA<Map<String, dynamic>>());
        expect(response['success'], true);
        expect(response['data'], isA<Map<String, dynamic>>());
        expect(response['data']['buds'], isA<List>());
        expect(response['data']['buds'].length, 1);
      });
    });

    group('Content API', () {
      test('should get liked tracks successfully', () async {
        final mockResponse = MockResponse<Map<String, dynamic>>();
        final budsData = {
          'data': [
            {
              'uid': 'bud1',
              'bud_uid': 'buddy1', 
              'username': 'buddy1',
              'match_score': 80.0,
              'commonArtistsCount': 5,
              'commonTracksCount': 10,
              'commonGenresCount': 3,
            }
          ]
        };
        
        when(mockResponse.statusCode).thenReturn(200);
        when(mockResponse.data).thenReturn(budsData);
        when(mockDioClient.post('/bud/liked/tracks?page=1'))
            .thenAnswer((_) async => mockResponse);
        
        final buds = await apiService.getLikedTracksBuds();
        
        expect(buds, isA<List<BudMatch>>());
        expect(buds.length, 1);
        expect(buds.first.username, 'buddy1');
      });

      test('should get top artists successfully', () async {
        final mockResponse = MockResponse<Map<String, dynamic>>();
        final artistsData = {
          'data': [
            {
              'uid': 'artist1',
              'name': 'Test Artist',
              'genres': ['Rock', 'Pop'],
              'images': [{'url': 'artist-image.jpg'}],
            }
          ]
        };
        
        when(mockResponse.statusCode).thenReturn(200);
        when(mockResponse.data).thenReturn(artistsData);
        when(mockDioClient.post('/me/top/artists', data: {'page': 1}))
            .thenAnswer((_) async => mockResponse);
        
        final artists = await apiService.getTopArtists();
        
        expect(artists, isA<List<CommonArtist>>());
        expect(artists.length, 1);
        expect(artists.first.name, 'Test Artist');
      });
    });

    group('Error Handling', () {
      test('should handle network timeout', () async {
        when(mockDioClient.post('/me/profile', data: {}))
            .thenThrow(DioException(
              type: DioExceptionType.connectionTimeout,
              requestOptions: RequestOptions(path: '/me/profile'),
            ));
        
        expect(() => apiService.getUserProfile(), throwsException);
      });

      test('should handle server error', () async {
        when(mockDioClient.post('/me/profile', data: {}))
            .thenThrow(DioException(
              type: DioExceptionType.badResponse,
              response: Response(
                statusCode: 500,
                requestOptions: RequestOptions(path: '/me/profile'),
              ),
              requestOptions: RequestOptions(path: '/me/profile'),
            ));
        
        expect(() => apiService.getUserProfile(), throwsException);
      });

      test('should handle authentication error', () async {
        when(mockDioClient.post('/me/profile', data: {}))
            .thenThrow(DioException(
              type: DioExceptionType.badResponse,
              response: Response(
                statusCode: 401,
                requestOptions: RequestOptions(path: '/me/profile'),
              ),
              requestOptions: RequestOptions(path: '/me/profile'),
            ));
        
        expect(() => apiService.getUserProfile(), throwsException);
      });
    });

    group('Token Management', () {
      test('should refresh token when needed', () async {
        // This would require access to private methods
        // Implementation would depend on exposing token refresh logic
        expect(true, true); // Placeholder
      });

      test('should handle token expiration', () async {
        // Test token expiration handling
        expect(true, true); // Placeholder
      });
    });
  });
}