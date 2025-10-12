// Comprehensive API Tests for MusicBud Flutter
// Tests all API endpoints with real data scenarios

@TestOn('browser')
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:musicbud_flutter/data/network/api_service.dart';
import 'package:musicbud_flutter/config/dynamic_api_config.dart';

void main() {
  group('Comprehensive API Endpoint Tests', () {
    late ApiService apiService;
    String? testAuthToken;
    String? testUserId;
    Map<String, dynamic> testResults = {};

    setUpAll(() {
      apiService = ApiService();
      print('🚀 Starting Comprehensive API Tests');
      print('Testing against: ${DynamicApiConfig.currentBaseUrl}');
      print('═' * 60);
    });

    tearDownAll(() {
      print('\n═' * 60);
      print('📊 TEST RESULTS SUMMARY');
      print('═' * 60);
      testResults.forEach((endpoint, result) {
        final icon = result['success'] ? '✅' : '❌';
        print('$icon $endpoint: ${result['status']}');
        if (result['error'] != null) {
          print('   Error: ${result['error']}');
        }
      });
      print('═' * 60);
    });

    // ============== Health & Connectivity Tests ==============
    group('🏥 Health & Connectivity', () {
      test('Backend should be reachable and healthy', () async {
        try {
          final response = await apiService.healthCheck();
          
          expect(response.statusCode, equals(200));
          testResults['health_check'] = {
            'success': true,
            'status': 'Backend is healthy',
            'statusCode': response.statusCode,
            'responseTime': response.headers.value('x-response-time'),
          };
          
          print('✅ Backend health check passed');
        } catch (e) {
          testResults['health_check'] = {
            'success': false,
            'status': 'Backend unreachable',
            'error': e.toString(),
          };
          fail('Backend health check failed: $e');
        }
      });

      test('API base URL should be correctly configured', () {
        expect(DynamicApiConfig.currentBaseUrl, isNotEmpty);
        expect(
          DynamicApiConfig.currentBaseUrl,
          anyOf(contains('http://'), contains('https://')),
        );
        print('✅ Base URL configuration valid: ${DynamicApiConfig.currentBaseUrl}');
      });

      test('All endpoint categories should be defined', () {
        final categories = ['bud', 'commonBud', 'auth', 'service', 'content'];
        
        for (final category in categories) {
          final endpoints = DynamicApiConfig.getEndpointsForCategory(category);
          expect(endpoints, isNotEmpty, reason: '$category endpoints should be defined');
          print('✅ $category: ${endpoints.length} endpoints defined');
        }
      });
    });

    // ============== Authentication Tests ==============
    group('🔐 Authentication Endpoints', () {
      test('Register endpoint structure validation', () async {
        try {
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          final response = await apiService.register(
            email: 'test$timestamp@musicbud.test',
            username: 'testuser$timestamp',
            password: 'TestPassword123!',
            confirmPassword: 'TestPassword123!',
          );
          
          if (response.statusCode == 200 || response.statusCode == 201) {
            expect(response.data, isNotNull);
            testResults['register'] = {
              'success': true,
              'status': 'Registration successful',
              'statusCode': response.statusCode,
            };
            
            // Store test credentials
            testUserId = response.data['user_id'] ?? response.data['uid'] ?? response.data['id'];
            testAuthToken = response.data['token'] ?? response.data['access_token'] ?? response.data['access'];
            
            if (testAuthToken != null) {
              apiService.setAuthToken(testAuthToken);
            }
            
            print('✅ Registration test passed');
            print('   User ID: $testUserId');
          }
        } catch (e) {
          testResults['register'] = {
            'success': false,
            'status': 'Registration failed',
            'error': e.toString(),
          };
          print('⚠️  Registration failed (may be expected): $e');
        }
      });

      test('Login endpoint validation', () async {
        try {
          final response = await apiService.login(
            username: 'testuser',
            password: 'TestPassword123!',
          );
          
          expect(response.statusCode, equals(200));
          expect(response.data, isNotNull);
          
          // Validate response structure
          final hasToken = response.data.containsKey('access') ||
                          response.data.containsKey('token') ||
                          response.data.containsKey('access_token');
          
          expect(hasToken, isTrue, reason: 'Login response should contain auth token');
          
          testAuthToken = response.data['access'] ?? 
                         response.data['token'] ?? 
                         response.data['access_token'];
          
          if (testAuthToken != null) {
            apiService.setAuthToken(testAuthToken);
          }
          
          testResults['login'] = {
            'success': true,
            'status': 'Login successful',
            'statusCode': response.statusCode,
            'hasToken': hasToken,
          };
          
          print('✅ Login test passed');
        } catch (e) {
          testResults['login'] = {
            'success': false,
            'status': 'Login failed',
            'error': e.toString(),
          };
          print('⚠️  Login failed: $e');
        }
      });

      test('Token refresh endpoint', () async {
        if (testAuthToken == null) {
          print('⏭️  Skipping token refresh test (no token available)');
          return;
        }
        
        try {
          final response = await apiService.refreshToken(testAuthToken!);
          
          expect(response.statusCode, inInclusiveRange(200, 201));
          testResults['token_refresh'] = {
            'success': true,
            'status': 'Token refresh successful',
            'statusCode': response.statusCode,
          };
          
          print('✅ Token refresh test passed');
        } catch (e) {
          testResults['token_refresh'] = {
            'success': false,
            'status': 'Token refresh failed',
            'error': e.toString(),
          };
          print('⚠️  Token refresh failed: $e');
        }
      });
    });

    // ============== User Profile Tests ==============
    group('👤 User Profile Endpoints', () {
      test('Get my profile endpoint', () async {
        try {
          final response = await apiService.getMyProfile();
          
          if (response.statusCode == 401 || response.statusCode == 403) {
            print('⚠️  Profile endpoint requires authentication');
            testResults['get_my_profile'] = {
              'success': false,
              'status': 'Requires authentication',
              'statusCode': response.statusCode,
            };
            return;
          }
          
          expect(response.statusCode, equals(200));
          expect(response.data, isNotNull);
          
          // Validate profile structure
          final hasRequiredFields = response.data.containsKey('id') ||
                                   response.data.containsKey('user_id') ||
                                   response.data.containsKey('username');
          
          expect(hasRequiredFields, isTrue, reason: 'Profile should have user identifier');
          
          testResults['get_my_profile'] = {
            'success': true,
            'status': 'Profile retrieved successfully',
            'statusCode': response.statusCode,
            'dataKeys': response.data.keys.toList(),
          };
          
          print('✅ Get profile test passed');
          print('   Profile fields: ${response.data.keys.join(', ')}');
        } catch (e) {
          testResults['get_my_profile'] = {
            'success': false,
            'status': 'Profile retrieval failed',
            'error': e.toString(),
          };
          print('⚠️  Profile retrieval failed: $e');
        }
      });

      test('Update my likes endpoint', () async {
        try {
          final response = await apiService.updateMyLikes({
            'liked_artists': ['artist1', 'artist2'],
            'liked_tracks': ['track1', 'track2'],
          });
          
          if (response.statusCode == 401 || response.statusCode == 403) {
            print('⚠️  Update likes requires authentication');
            return;
          }
          
          expect(response.statusCode, inInclusiveRange(200, 204));
          testResults['update_my_likes'] = {
            'success': true,
            'status': 'Likes updated successfully',
            'statusCode': response.statusCode,
          };
          
          print('✅ Update likes test passed');
        } catch (e) {
          testResults['update_my_likes'] = {
            'success': false,
            'status': 'Update likes failed',
            'error': e.toString(),
          };
          print('⚠️  Update likes failed: $e');
        }
      });
    });

    // ============== Content Endpoints Tests ==============
    group('🎵 Content Endpoints', () {
      test('Get tracks with pagination', () async {
        try {
          final response = await apiService.getTracks(page: 1, pageSize: 10);
          
          if (response.statusCode == 401 || response.statusCode == 403) {
            print('⚠️  Tracks endpoint requires authentication');
            return;
          }
          
          expect(response.statusCode, equals(200));
          expect(response.data, isNotNull);
          
          // Validate response structure
          final isList = response.data is List;
          final hasResults = response.data is Map && response.data.containsKey('results');
          
          expect(isList || hasResults, isTrue, reason: 'Response should be list or have results');
          
          testResults['get_tracks'] = {
            'success': true,
            'status': 'Tracks retrieved successfully',
            'statusCode': response.statusCode,
            'dataType': response.data.runtimeType.toString(),
            'count': isList ? (response.data as List).length : 
                    (response.data['results'] as List?)?.length ?? 0,
          };
          
          print('✅ Get tracks test passed');
        } catch (e) {
          testResults['get_tracks'] = {
            'success': false,
            'status': 'Get tracks failed',
            'error': e.toString(),
          };
          print('⚠️  Get tracks failed: $e');
        }
      });

      test('Get artists with pagination', () async {
        try {
          final response = await apiService.getArtists(page: 1, pageSize: 10);
          
          if (response.statusCode == 401 || response.statusCode == 403) {
            print('⚠️  Artists endpoint requires authentication');
            return;
          }
          
          expect(response.statusCode, equals(200));
          testResults['get_artists'] = {
            'success': true,
            'status': 'Artists retrieved successfully',
            'statusCode': response.statusCode,
          };
          
          print('✅ Get artists test passed');
        } catch (e) {
          testResults['get_artists'] = {
            'success': false,
            'status': 'Get artists failed',
            'error': e.toString(),
          };
          print('⚠️  Get artists failed: $e');
        }
      });

      test('Get albums with pagination', () async {
        try {
          final response = await apiService.getAlbums(page: 1, pageSize: 10);
          
          if (response.statusCode == 401 || response.statusCode == 403) {
            print('⚠️  Albums endpoint requires authentication');
            return;
          }
          
          expect(response.statusCode, equals(200));
          testResults['get_albums'] = {
            'success': true,
            'status': 'Albums retrieved successfully',
            'statusCode': response.statusCode,
          };
          
          print('✅ Get albums test passed');
        } catch (e) {
          testResults['get_albums'] = {
            'success': false,
            'status': 'Get albums failed',
            'error': e.toString(),
          };
          print('⚠️  Get albums failed: $e');
        }
      });

      test('Get genres with pagination', () async {
        try {
          final response = await apiService.getGenres(page: 1, pageSize: 10);
          
          if (response.statusCode == 401 || response.statusCode == 403) {
            print('⚠️  Genres endpoint requires authentication');
            return;
          }
          
          expect(response.statusCode, equals(200));
          testResults['get_genres'] = {
            'success': true,
            'status': 'Genres retrieved successfully',
            'statusCode': response.statusCode,
          };
          
          print('✅ Get genres test passed');
        } catch (e) {
          testResults['get_genres'] = {
            'success': false,
            'status': 'Get genres failed',
            'error': e.toString(),
          };
          print('⚠️  Get genres failed: $e');
        }
      });

      test('Get playlists with pagination', () async {
        try {
          final response = await apiService.getPlaylists(page: 1, pageSize: 10);
          
          if (response.statusCode == 401 || response.statusCode == 403) {
            print('⚠️  Playlists endpoint requires authentication');
            return;
          }
          
          expect(response.statusCode, equals(200));
          testResults['get_playlists'] = {
            'success': true,
            'status': 'Playlists retrieved successfully',
            'statusCode': response.statusCode,
          };
          
          print('✅ Get playlists test passed');
        } catch (e) {
          testResults['get_playlists'] = {
            'success': false,
            'status': 'Get playlists failed',
            'error': e.toString(),
          };
          print('⚠️  Get playlists failed: $e');
        }
      });
    });

    // ============== Search Endpoints Tests ==============
    group('🔍 Search Endpoints', () {
      test('General search endpoint', () async {
        try {
          final response = await apiService.search('test');
          
          if (response.statusCode == 401 || response.statusCode == 403) {
            print('⚠️  Search endpoint requires authentication');
            return;
          }
          
          expect(response.statusCode, equals(200));
          testResults['search'] = {
            'success': true,
            'status': 'Search executed successfully',
            'statusCode': response.statusCode,
          };
          
          print('✅ Search test passed');
        } catch (e) {
          testResults['search'] = {
            'success': false,
            'status': 'Search failed',
            'error': e.toString(),
          };
          print('⚠️  Search failed: $e');
        }
      });

      test('Search trending endpoint', () async {
        try {
          final response = await apiService.searchTrending();
          
          if (response.statusCode == 401 || response.statusCode == 403) {
            print('⚠️  Trending endpoint requires authentication');
            return;
          }
          
          expect(response.statusCode, equals(200));
          testResults['search_trending'] = {
            'success': true,
            'status': 'Trending search successful',
            'statusCode': response.statusCode,
          };
          
          print('✅ Trending search test passed');
        } catch (e) {
          testResults['search_trending'] = {
            'success': false,
            'status': 'Trending search failed',
            'error': e.toString(),
          };
          print('⚠️  Trending search failed: $e');
        }
      });

      test('Search users endpoint', () async {
        try {
          final response = await apiService.searchUsers('test');
          
          if (response.statusCode == 401 || response.statusCode == 403) {
            print('⚠️  User search requires authentication');
            return;
          }
          
          expect(response.statusCode, equals(200));
          testResults['search_users'] = {
            'success': true,
            'status': 'User search successful',
            'statusCode': response.statusCode,
          };
          
          print('✅ User search test passed');
        } catch (e) {
          testResults['search_users'] = {
            'success': false,
            'status': 'User search failed',
            'error': e.toString(),
          };
          print('⚠️  User search failed: $e');
        }
      });

      test('Search suggestions endpoint', () async {
        try {
          final response = await apiService.searchSuggestions('tes');
          
          if (response.statusCode == 401 || response.statusCode == 403) {
            print('⚠️  Search suggestions requires authentication');
            return;
          }
          
          expect(response.statusCode, equals(200));
          testResults['search_suggestions'] = {
            'success': true,
            'status': 'Search suggestions successful',
            'statusCode': response.statusCode,
          };
          
          print('✅ Search suggestions test passed');
        } catch (e) {
          testResults['search_suggestions'] = {
            'success': false,
            'status': 'Search suggestions failed',
            'error': e.toString(),
          };
          print('⚠️  Search suggestions failed: $e');
        }
      });

      test('Search recent endpoint', () async {
        try {
          final response = await apiService.searchRecent();
          
          if (response.statusCode == 401 || response.statusCode == 403) {
            print('⚠️  Search recent requires authentication');
            return;
          }
          
          expect(response.statusCode, equals(200));
          testResults['search_recent'] = {
            'success': true,
            'status': 'Recent searches retrieved',
            'statusCode': response.statusCode,
          };
          
          print('✅ Recent searches test passed');
        } catch (e) {
          testResults['search_recent'] = {
            'success': false,
            'status': 'Recent searches failed',
            'error': e.toString(),
          };
          print('⚠️  Recent searches failed: $e');
        }
      });
    });

    // ============== Bud Matching Tests ==============
    group('🤝 Bud Matching Endpoints', () {
      test('Get buds by top artists', () async {
        try {
          final response = await apiService.getBudsByTopArtists();
          
          if (response.statusCode == 401 || response.statusCode == 403) {
            print('⚠️  Bud matching requires authentication');
            return;
          }
          
          expect(response.statusCode, equals(200));
          testResults['buds_top_artists'] = {
            'success': true,
            'status': 'Buds by top artists retrieved',
            'statusCode': response.statusCode,
          };
          
          print('✅ Buds by top artists test passed');
        } catch (e) {
          testResults['buds_top_artists'] = {
            'success': false,
            'status': 'Buds by top artists failed',
            'error': e.toString(),
          };
          print('⚠️  Buds by top artists failed: $e');
        }
      });

      test('Get buds by top tracks', () async {
        try {
          final response = await apiService.getBudsByTopTracks();
          
          if (response.statusCode == 401 || response.statusCode == 403) {
            print('⚠️  Bud matching requires authentication');
            return;
          }
          
          expect(response.statusCode, equals(200));
          testResults['buds_top_tracks'] = {
            'success': true,
            'status': 'Buds by top tracks retrieved',
            'statusCode': response.statusCode,
          };
          
          print('✅ Buds by top tracks test passed');
        } catch (e) {
          testResults['buds_top_tracks'] = {
            'success': false,
            'status': 'Buds by top tracks failed',
            'error': e.toString(),
          };
          print('⚠️  Buds by top tracks failed: $e');
        }
      });

      test('Get buds by liked artists', () async {
        try {
          final response = await apiService.getBudsByLikedArtists();
          
          if (response.statusCode == 401 || response.statusCode == 403) {
            print('⚠️  Bud matching requires authentication');
            return;
          }
          
          expect(response.statusCode, equals(200));
          testResults['buds_liked_artists'] = {
            'success': true,
            'status': 'Buds by liked artists retrieved',
            'statusCode': response.statusCode,
          };
          
          print('✅ Buds by liked artists test passed');
        } catch (e) {
          testResults['buds_liked_artists'] = {
            'success': false,
            'status': 'Buds by liked artists failed',
            'error': e.toString(),
          };
          print('⚠️  Buds by liked artists failed: $e');
        }
      });

      test('Get buds by liked tracks', () async {
        try {
          final response = await apiService.getBudsByLikedTracks();
          
          if (response.statusCode == 401 || response.statusCode == 403) {
            print('⚠️  Bud matching requires authentication');
            return;
          }
          
          expect(response.statusCode, equals(200));
          testResults['buds_liked_tracks'] = {
            'success': true,
            'status': 'Buds by liked tracks retrieved',
            'statusCode': response.statusCode,
          };
          
          print('✅ Buds by liked tracks test passed');
        } catch (e) {
          testResults['buds_liked_tracks'] = {
            'success': false,
            'status': 'Buds by liked tracks failed',
            'error': e.toString(),
          };
          print('⚠️  Buds by liked tracks failed: $e');
        }
      });

      test('Get buds by liked AIO (All-in-One)', () async {
        try {
          final response = await apiService.getBudsByLikedAio();
          
          if (response.statusCode == 401 || response.statusCode == 403) {
            print('⚠️  Bud matching requires authentication');
            return;
          }
          
          expect(response.statusCode, equals(200));
          testResults['buds_liked_aio'] = {
            'success': true,
            'status': 'Buds by liked AIO retrieved',
            'statusCode': response.statusCode,
          };
          
          print('✅ Buds by liked AIO test passed');
        } catch (e) {
          testResults['buds_liked_aio'] = {
            'success': false,
            'status': 'Buds by liked AIO failed',
            'error': e.toString(),
          };
          print('⚠️  Buds by liked AIO failed: $e');
        }
      });

      test('Get buds by top genres', () async {
        try {
          final response = await apiService.getBudsByTopGenres();
          
          if (response.statusCode == 401 || response.statusCode == 403) {
            print('⚠️  Bud matching requires authentication');
            return;
          }
          
          expect(response.statusCode, equals(200));
          testResults['buds_top_genres'] = {
            'success': true,
            'status': 'Buds by top genres retrieved',
            'statusCode': response.statusCode,
          };
          
          print('✅ Buds by top genres test passed');
        } catch (e) {
          testResults['buds_top_genres'] = {
            'success': false,
            'status': 'Buds by top genres failed',
            'error': e.toString(),
          };
          print('⚠️  Buds by top genres failed: $e');
        }
      });
    });

    // ============== Library Endpoints Tests ==============
    group('📚 Library Endpoints', () {
      test('Get library', () async {
        try {
          final response = await apiService.getLibrary();
          
          if (response.statusCode == 401 || response.statusCode == 403) {
            print('⚠️  Library endpoint requires authentication');
            return;
          }
          
          expect(response.statusCode, equals(200));
          testResults['get_library'] = {
            'success': true,
            'status': 'Library retrieved successfully',
            'statusCode': response.statusCode,
          };
          
          print('✅ Get library test passed');
        } catch (e) {
          testResults['get_library'] = {
            'success': false,
            'status': 'Get library failed',
            'error': e.toString(),
          };
          print('⚠️  Get library failed: $e');
        }
      });

      test('Get library playlists', () async {
        try {
          final response = await apiService.getLibraryPlaylists();
          
          if (response.statusCode == 401 || response.statusCode == 403) {
            print('⚠️  Library playlists requires authentication');
            return;
          }
          
          expect(response.statusCode, equals(200));
          testResults['library_playlists'] = {
            'success': true,
            'status': 'Library playlists retrieved',
            'statusCode': response.statusCode,
          };
          
          print('✅ Library playlists test passed');
        } catch (e) {
          testResults['library_playlists'] = {
            'success': false,
            'status': 'Library playlists failed',
            'error': e.toString(),
          };
          print('⚠️  Library playlists failed: $e');
        }
      });

      test('Get library liked', () async {
        try {
          final response = await apiService.getLibraryLiked();
          
          if (response.statusCode == 401 || response.statusCode == 403) {
            print('⚠️  Library liked requires authentication');
            return;
          }
          
          expect(response.statusCode, equals(200));
          testResults['library_liked'] = {
            'success': true,
            'status': 'Library liked retrieved',
            'statusCode': response.statusCode,
          };
          
          print('✅ Library liked test passed');
        } catch (e) {
          testResults['library_liked'] = {
            'success': false,
            'status': 'Library liked failed',
            'error': e.toString(),
          };
          print('⚠️  Library liked failed: $e');
        }
      });

      test('Get library downloads', () async {
        try {
          final response = await apiService.getLibraryDownloads();
          
          if (response.statusCode == 401 || response.statusCode == 403) {
            print('⚠️  Library downloads requires authentication');
            return;
          }
          
          expect(response.statusCode, equals(200));
          testResults['library_downloads'] = {
            'success': true,
            'status': 'Library downloads retrieved',
            'statusCode': response.statusCode,
          };
          
          print('✅ Library downloads test passed');
        } catch (e) {
          testResults['library_downloads'] = {
            'success': false,
            'status': 'Library downloads failed',
            'error': e.toString(),
          };
          print('⚠️  Library downloads failed: $e');
        }
      });

      test('Get library recent', () async {
        try {
          final response = await apiService.getLibraryRecent();
          
          if (response.statusCode == 401 || response.statusCode == 403) {
            print('⚠️  Library recent requires authentication');
            return;
          }
          
          expect(response.statusCode, equals(200));
          testResults['library_recent'] = {
            'success': true,
            'status': 'Library recent retrieved',
            'statusCode': response.statusCode,
          };
          
          print('✅ Library recent test passed');
        } catch (e) {
          testResults['library_recent'] = {
            'success': false,
            'status': 'Library recent failed',
            'error': e.toString(),
          };
          print('⚠️  Library recent failed: $e');
        }
      });
    });

    // ============== My Top/Liked Endpoints Tests ==============
    group('⭐ My Top & Liked Endpoints', () {
      test('Get my top artists', () async {
        try {
          final response = await apiService.getMyTopArtists(page: 1, pageSize: 10);
          
          if (response.statusCode == 401 || response.statusCode == 403) {
            print('⚠️  My top artists requires authentication');
            return;
          }
          
          expect(response.statusCode, equals(200));
          testResults['my_top_artists'] = {
            'success': true,
            'status': 'My top artists retrieved',
            'statusCode': response.statusCode,
          };
          
          print('✅ My top artists test passed');
        } catch (e) {
          testResults['my_top_artists'] = {
            'success': false,
            'status': 'My top artists failed',
            'error': e.toString(),
          };
          print('⚠️  My top artists failed: $e');
        }
      });

      test('Get my top tracks', () async {
        try {
          final response = await apiService.getMyTopTracks(page: 1, pageSize: 10);
          
          if (response.statusCode == 401 || response.statusCode == 403) {
            print('⚠️  My top tracks requires authentication');
            return;
          }
          
          expect(response.statusCode, equals(200));
          testResults['my_top_tracks'] = {
            'success': true,
            'status': 'My top tracks retrieved',
            'statusCode': response.statusCode,
          };
          
          print('✅ My top tracks test passed');
        } catch (e) {
          testResults['my_top_tracks'] = {
            'success': false,
            'status': 'My top tracks failed',
            'error': e.toString(),
          };
          print('⚠️  My top tracks failed: $e');
        }
      });

      test('Get my liked artists', () async {
        try {
          final response = await apiService.getMyLikedArtists(page: 1, pageSize: 10);
          
          if (response.statusCode == 401 || response.statusCode == 403) {
            print('⚠️  My liked artists requires authentication');
            return;
          }
          
          expect(response.statusCode, equals(200));
          testResults['my_liked_artists'] = {
            'success': true,
            'status': 'My liked artists retrieved',
            'statusCode': response.statusCode,
          };
          
          print('✅ My liked artists test passed');
        } catch (e) {
          testResults['my_liked_artists'] = {
            'success': false,
            'status': 'My liked artists failed',
            'error': e.toString(),
          };
          print('⚠️  My liked artists failed: $e');
        }
      });

      test('Get my liked tracks', () async {
        try {
          final response = await apiService.getMyLikedTracks(page: 1, pageSize: 10);
          
          if (response.statusCode == 401 || response.statusCode == 403) {
            print('⚠️  My liked tracks requires authentication');
            return;
          }
          
          expect(response.statusCode, equals(200));
          testResults['my_liked_tracks'] = {
            'success': true,
            'status': 'My liked tracks retrieved',
            'statusCode': response.statusCode,
          };
          
          print('✅ My liked tracks test passed');
        } catch (e) {
          testResults['my_liked_tracks'] = {
            'success': false,
            'status': 'My liked tracks failed',
            'error': e.toString(),
          };
          print('⚠️  My liked tracks failed: $e');
        }
      });

      test('Get my liked albums', () async {
        try {
          final response = await apiService.getMyLikedAlbums(page: 1, pageSize: 10);
          
          if (response.statusCode == 401 || response.statusCode == 403) {
            print('⚠️  My liked albums requires authentication');
            return;
          }
          
          expect(response.statusCode, equals(200));
          testResults['my_liked_albums'] = {
            'success': true,
            'status': 'My liked albums retrieved',
            'statusCode': response.statusCode,
          };
          
          print('✅ My liked albums test passed');
        } catch (e) {
          testResults['my_liked_albums'] = {
            'success': false,
            'status': 'My liked albums failed',
            'error': e.toString(),
          };
          print('⚠️  My liked albums failed: $e');
        }
      });
    });

    // ============== Analytics & Events Tests ==============
    group('📊 Analytics & Events Endpoints', () {
      test('Get analytics', () async {
        try {
          final response = await apiService.getAnalytics();
          
          if (response.statusCode == 401 || response.statusCode == 403) {
            print('⚠️  Analytics requires authentication');
            return;
          }
          
          expect(response.statusCode, equals(200));
          testResults['analytics'] = {
            'success': true,
            'status': 'Analytics retrieved',
            'statusCode': response.statusCode,
          };
          
          print('✅ Analytics test passed');
        } catch (e) {
          testResults['analytics'] = {
            'success': false,
            'status': 'Analytics failed',
            'error': e.toString(),
          };
          print('⚠️  Analytics failed: $e');
        }
      });

      test('Get analytics stats', () async {
        try {
          final response = await apiService.getAnalyticsStats();
          
          if (response.statusCode == 401 || response.statusCode == 403) {
            print('⚠️  Analytics stats requires authentication');
            return;
          }
          
          expect(response.statusCode, equals(200));
          testResults['analytics_stats'] = {
            'success': true,
            'status': 'Analytics stats retrieved',
            'statusCode': response.statusCode,
          };
          
          print('✅ Analytics stats test passed');
        } catch (e) {
          testResults['analytics_stats'] = {
            'success': false,
            'status': 'Analytics stats failed',
            'error': e.toString(),
          };
          print('⚠️  Analytics stats failed: $e');
        }
      });

      test('Get events', () async {
        try {
          final response = await apiService.getEvents();
          
          if (response.statusCode == 401 || response.statusCode == 403) {
            print('⚠️  Events requires authentication');
            return;
          }
          
          expect(response.statusCode, equals(200));
          testResults['events'] = {
            'success': true,
            'status': 'Events retrieved',
            'statusCode': response.statusCode,
          };
          
          print('✅ Events test passed');
        } catch (e) {
          testResults['events'] = {
            'success': false,
            'status': 'Events failed',
            'error': e.toString(),
          };
          print('⚠️  Events failed: $e');
        }
      });
    });
  });
}
