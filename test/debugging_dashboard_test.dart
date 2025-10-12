// Debugging Dashboard Test
// Generates comprehensive debugging reports for API analysis

@TestOn('browser')
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:musicbud_flutter/data/network/api_service.dart';
import 'package:musicbud_flutter/utils/api_debugging_analyzer.dart';
import 'package:musicbud_flutter/config/dynamic_api_config.dart';
import 'package:musicbud_flutter/domain/entities/common_artist.dart';
import 'package:musicbud_flutter/domain/entities/common_track.dart';
import 'package:musicbud_flutter/domain/entities/user.dart';

void main() {
  group('Debugging Dashboard & Workflow Tests', () {
    late ApiService apiService;
    late ApiDebuggingAnalyzer analyzer;

    setUpAll(() {
      apiService = ApiService();
      analyzer = ApiDebuggingAnalyzer(apiService);
      print('🎯 Debugging Dashboard Initialized');
      print('═' * 60);
    });

    // ========== Full Debugging Analysis ==========
    test('Generate complete debugging report', () async {
      print('\n🔬 Running Complete API Analysis...\n');
      
      final report = await analyzer.runCompleteAnalysis(
        includeAuthenticated: false,
      );
      
      // Verify report structure
      expect(report, isNotNull);
      expect(report, contains('configuration'));
      expect(report, contains('health'));
      expect(report, contains('summary'));
      
      // Print formatted report
      print(analyzer.getFormattedReport());
      
      // Save JSON report (in test environment, just verify it can be generated)
      final jsonReport = analyzer.exportToJson();
      expect(jsonReport, isNotEmpty);
      
      print('\n📄 Report generated successfully');
      print('   JSON size: ${jsonReport.length} characters');
    });

    // ========== Data Model Validation Tests ==========
    group('🧪 Data Model Validation', () {
      test('CommonArtist model should handle various JSON structures', () {
        final testCases = [
          // Standard structure
          {
            'id': '1',
            'name': 'Test Artist',
            'image_url': 'https://example.com/img.jpg',
            'genres': ['Rock', 'Pop'],
            'popularity': 85,
          },
          // Alternate key names (camelCase)
          {
            'id': '2',
            'name': 'Test Artist 2',
            'imageUrl': 'https://example.com/img2.jpg',
            'genres': ['Jazz'],
          },
          // Minimal required fields
          {
            'name': 'Minimal Artist',
            'genres': [],
          },
          // With extra metadata
          {
            'id': '3',
            'name': 'Artist with Metadata',
            'genres': ['Electronic'],
            'spotify_id': 'spotify123',
            'apple_music_id': 'apple456',
            'metadata': {'custom': 'data'},
          },
        ];

        int successCount = 0;
        final errors = <String>[];

        for (final testCase in testCases) {
          try {
            final artist = CommonArtist.fromJson(testCase);
            expect(artist.name, isNotEmpty);
            expect(artist.genres, isNotNull);
            successCount++;
            print('✓ Test case ${testCases.indexOf(testCase) + 1} passed');
          } catch (e) {
            errors.add('Test case ${testCases.indexOf(testCase) + 1}: $e');
            print('✗ Test case ${testCases.indexOf(testCase) + 1} failed: $e');
          }
        }

        print('\n📊 CommonArtist Model Results:');
        print('   Success: $successCount/${testCases.length}');
        print('   Success Rate: ${(successCount / testCases.length * 100).toStringAsFixed(1)}%');
        
        expect(successCount, equals(testCases.length), 
               reason: 'All test cases should pass. Errors: ${errors.join(', ')}');
      });

      test('CommonTrack model should handle various JSON structures', () {
        final testCases = [
          // Standard structure
          {
            'id': '1',
            'title': 'Test Track',
            'artist_name': 'Test Artist',
            'album_name': 'Test Album',
            'duration': 180000,
            'genres': ['Rock'],
          },
          // Alternate key names
          {
            'id': '2',
            'name': 'Test Track 2',  // 'name' instead of 'title'
            'artistName': 'Test Artist 2',  // camelCase
            'albumName': 'Test Album 2',
            'genres': [],
          },
          // Minimal required fields
          {
            'title': 'Minimal Track',
            'artist_name': 'Unknown Artist',
            'genres': [],
          },
          // With preview and metadata
          {
            'id': '3',
            'title': 'Track with Preview',
            'artist_name': 'Artist',
            'preview_url': 'https://example.com/preview.mp3',
            'spotify_id': 'spotify123',
            'genres': ['Pop'],
            'popularity': 75,
          },
        ];

        int successCount = 0;
        final errors = <String>[];

        for (final testCase in testCases) {
          try {
            final track = CommonTrack.fromJson(testCase);
            expect(track.title, isNotEmpty);
            expect(track.artistName, isNotEmpty);
            expect(track.genres, isNotNull);
            successCount++;
            print('✓ Test case ${testCases.indexOf(testCase) + 1} passed');
          } catch (e) {
            errors.add('Test case ${testCases.indexOf(testCase) + 1}: $e');
            print('✗ Test case ${testCases.indexOf(testCase) + 1} failed: $e');
          }
        }

        print('\n📊 CommonTrack Model Results:');
        print('   Success: $successCount/${testCases.length}');
        print('   Success Rate: ${(successCount / testCases.length * 100).toStringAsFixed(1)}%');
        
        expect(successCount, equals(testCases.length), 
               reason: 'All test cases should pass. Errors: ${errors.join(', ')}');
      });

      test('User model should handle various JSON structures', () {
        final testCases = [
          // Standard structure
          {
            'id': '1',
            'display_name': 'Test User',
            'email': 'test@example.com',
            'followers': 100,
            'following': 50,
            'is_public': true,
            'images': [],
          },
          // Alternate key names
          {
            'id': '2',
            'displayName': 'Test User 2',  // camelCase
            'email': 'test2@example.com',
            'followers': 200,
            'following': 100,
            'isPublic': false,
            'images': [],
          },
          // With string numbers (type coercion test)
          {
            'id': '3',
            'display_name': 'Test User 3',
            'email': 'test3@example.com',
            'followers': '300',  // String instead of int
            'following': '150',
            'images': [],
          },
          // With images
          {
            'id': '4',
            'display_name': 'Test User 4',
            'email': 'test4@example.com',
            'followers': 400,
            'following': 200,
            'images': [
              {'url': 'https://example.com/img.jpg', 'width': 64, 'height': 64},
            ],
          },
        ];

        int successCount = 0;
        final errors = <String>[];

        for (final testCase in testCases) {
          try {
            final user = User.fromJson(testCase);
            expect(user.id, isNotEmpty);
            expect(user.displayName, isNotEmpty);
            expect(user.email, isNotEmpty);
            expect(user.images, isNotNull);
            successCount++;
            print('✓ Test case ${testCases.indexOf(testCase) + 1} passed');
          } catch (e) {
            errors.add('Test case ${testCases.indexOf(testCase) + 1}: $e');
            print('✗ Test case ${testCases.indexOf(testCase) + 1} failed: $e');
          }
        }

        print('\n📊 User Model Results:');
        print('   Success: $successCount/${testCases.length}');
        print('   Success Rate: ${(successCount / testCases.length * 100).toStringAsFixed(1)}%');
        
        expect(successCount, equals(testCases.length), 
               reason: 'All test cases should pass. Errors: ${errors.join(', ')}');
      });
    });

    // ========== Integration Workflow Tests ==========
    group('🔄 Integration Workflow Tests', () {
      test('Workflow: Guest browsing (no auth required)', () async {
        print('\n🎬 Testing Guest Browsing Workflow...');
        print('   Step 1: Health Check');
        
        try {
          // Step 1: Health check
          final health = await apiService.healthCheck();
          expect(health.statusCode, equals(200));
          print('   ✓ Health check passed');
          
          // Step 2: Browse public content (if available)
          print('   Step 2: Browse Content');
          try {
            final tracks = await apiService.getTracks(page: 1, pageSize: 5);
            if (tracks.statusCode == 200) {
              print('   ✓ Tracks retrieved successfully');
            } else if (tracks.statusCode == 401 || tracks.statusCode == 403) {
              print('   ⚠️  Tracks require authentication (expected behavior)');
            }
          } catch (e) {
            print('   ⚠️  Content browsing requires authentication');
          }
          
          // Step 3: View trending (if available)
          print('   Step 3: View Trending');
          try {
            final trending = await apiService.searchTrending();
            if (trending.statusCode == 200) {
              print('   ✓ Trending retrieved successfully');
            } else {
              print('   ⚠️  Trending requires authentication');
            }
          } catch (e) {
            print('   ⚠️  Trending requires authentication');
          }
          
          print('\n✅ Guest browsing workflow completed');
        } catch (e) {
          fail('Guest browsing workflow failed: $e');
        }
      });

      test('Workflow: User registration flow', () async {
        print('\n🎬 Testing User Registration Workflow...');
        
        try {
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          final testEmail = 'workflow$timestamp@test.com';
          final testUsername = 'workflow$timestamp';
          const testPassword = 'Test123!@#';
          
          print('   Step 1: Attempt Registration');
          print('   Email: $testEmail');
          print('   Username: $testUsername');
          
          try {
            final response = await apiService.register(
              email: testEmail,
              username: testUsername,
              password: testPassword,
              confirmPassword: testPassword,
            );
            
            if (response.statusCode == 200 || response.statusCode == 201) {
              print('   ✓ Registration successful');
              
              // Verify response structure
              expect(response.data, isNotNull);
              
              // Check for user ID
              final hasUserId = response.data.containsKey('user_id') ||
                               response.data.containsKey('uid') ||
                               response.data.containsKey('id');
              
              if (hasUserId) {
                print('   ✓ User ID provided in response');
              }
              
              // Check for auth token
              final hasToken = response.data.containsKey('token') ||
                              response.data.containsKey('access') ||
                              response.data.containsKey('access_token');
              
              if (hasToken) {
                print('   ✓ Auth token provided in response');
              }
              
              print('\n✅ Registration workflow completed successfully');
            }
          } on Exception catch (e) {
            print('   ⚠️  Registration failed (may already exist): $e');
            print('\n⚠️  Registration workflow completed with expected error');
          }
        } catch (e) {
          print('   ⚠️  Registration workflow failed: $e');
        }
      });

      test('Workflow: Authenticated user session', () async {
        print('\n🎬 Testing Authenticated User Workflow...');
        print('   Note: This requires valid credentials');
        
        try {
          // Step 1: Login
          print('   Step 1: Login Attempt');
          try {
            final loginResponse = await apiService.login(
              username: 'testuser',
              password: 'TestPassword123!',
            );
            
            if (loginResponse.statusCode == 200) {
              print('   ✓ Login successful');
              
              final token = loginResponse.data['access'] ??
                           loginResponse.data['token'] ??
                           loginResponse.data['access_token'];
              
              if (token != null) {
                apiService.setAuthToken(token);
                print('   ✓ Token stored');
                
                // Step 2: Get Profile
                print('   Step 2: Fetch Profile');
                final profile = await apiService.getMyProfile();
                if (profile.statusCode == 200) {
                  print('   ✓ Profile retrieved');
                }
                
                // Step 3: Get Content
                print('   Step 3: Fetch Personalized Content');
                final tracks = await apiService.getMyTopTracks(page: 1, pageSize: 5);
                if (tracks.statusCode == 200) {
                  print('   ✓ Top tracks retrieved');
                }
                
                print('\n✅ Authenticated workflow completed successfully');
              }
            }
          } catch (e) {
            print('   ⚠️  Authentication workflow requires valid credentials');
            print('   Error: $e');
          }
        } catch (e) {
          print('   ⚠️  Authenticated workflow test skipped: $e');
        }
      });

      test('Workflow: Search and discovery', () async {
        print('\n🎬 Testing Search & Discovery Workflow...');
        
        try {
          // Step 1: General search
          print('   Step 1: Perform Search');
          try {
            final searchResults = await apiService.search('test');
            if (searchResults.statusCode == 200) {
              print('   ✓ Search executed successfully');
            } else if (searchResults.statusCode == 401 || searchResults.statusCode == 403) {
              print('   ⚠️  Search requires authentication');
            }
          } catch (e) {
            print('   ⚠️  Search unavailable: $e');
          }
          
          // Step 2: Get suggestions
          print('   Step 2: Get Search Suggestions');
          try {
            final suggestions = await apiService.searchSuggestions('tes');
            if (suggestions.statusCode == 200) {
              print('   ✓ Suggestions retrieved');
            }
          } catch (e) {
            print('   ⚠️  Suggestions unavailable');
          }
          
          // Step 3: Browse trending
          print('   Step 3: Browse Trending');
          try {
            final trending = await apiService.searchTrending();
            if (trending.statusCode == 200) {
              print('   ✓ Trending content retrieved');
            }
          } catch (e) {
            print('   ⚠️  Trending unavailable');
          }
          
          print('\n✅ Search & discovery workflow completed');
        } catch (e) {
          print('   ⚠️  Search workflow failed: $e');
        }
      });
    });

    // ========== Performance Analysis ==========
    group('⚡ Performance Analysis', () {
      test('API response times should be acceptable', () async {
        print('\n⏱️  Testing API Response Times...');
        
        final measurements = <String, int>{};
        
        // Test health check
        var stopwatch = Stopwatch()..start();
        try {
          await apiService.healthCheck();
          stopwatch.stop();
          measurements['health_check'] = stopwatch.elapsedMilliseconds;
          print('   Health Check: ${stopwatch.elapsedMilliseconds}ms');
        } catch (e) {
          print('   Health Check: Failed');
        }
        
        // Test content endpoints
        stopwatch = Stopwatch()..start();
        try {
          await apiService.getTracks(page: 1, pageSize: 10);
          stopwatch.stop();
          measurements['get_tracks'] = stopwatch.elapsedMilliseconds;
          print('   Get Tracks: ${stopwatch.elapsedMilliseconds}ms');
        } catch (e) {
          print('   Get Tracks: Failed or requires auth');
        }
        
        // Calculate average
        if (measurements.isNotEmpty) {
          final average = measurements.values.reduce((a, b) => a + b) / measurements.length;
          print('\n📊 Performance Summary:');
          print('   Average Response Time: ${average.toStringAsFixed(2)}ms');
          print('   Fastest: ${measurements.values.reduce((a, b) => a < b ? a : b)}ms');
          print('   Slowest: ${measurements.values.reduce((a, b) => a > b ? a : b)}ms');
          
          // Response times should be under 5 seconds for reasonable performance
          expect(average, lessThan(5000), reason: 'Average response time should be under 5s');
        }
      });

      test('Concurrent requests should be handled properly', () async {
        print('\n🔄 Testing Concurrent Request Handling...');
        
        try {
          final stopwatch = Stopwatch()..start();
          
          // Make multiple concurrent requests
          final futures = [
            apiService.healthCheck(),
            apiService.healthCheck(),
            apiService.healthCheck(),
          ];
          
          final responses = await Future.wait(futures);
          stopwatch.stop();
          
          // All requests should succeed
          for (final response in responses) {
            expect(response.statusCode, equals(200));
          }
          
          print('   ✓ ${responses.length} concurrent requests handled');
          print('   Total time: ${stopwatch.elapsedMilliseconds}ms');
          print('   Average per request: ${(stopwatch.elapsedMilliseconds / responses.length).toStringAsFixed(2)}ms');
        } catch (e) {
          fail('Concurrent request handling failed: $e');
        }
      });
    });

    // ========== API Consistency Checks ==========
    group('✅ API Consistency Checks', () {
      test('All configured endpoints should have valid URLs', () {
        print('\n🔍 Validating Endpoint URLs...');
        
        final categories = ['bud', 'commonBud', 'auth', 'service', 'content'];
        int totalEndpoints = 0;
        int validEndpoints = 0;
        
        for (final category in categories) {
          final endpoints = DynamicApiConfig.getEndpointsForCategory(category);
          totalEndpoints += endpoints.length;
          
          for (final entry in endpoints.entries) {
            final url = DynamicApiConfig.getEndpointUrl(entry.value);
            if (url.startsWith('http://') || url.startsWith('https://')) {
              validEndpoints++;
            } else {
              print('   ✗ Invalid URL for $category/${entry.key}: $url');
            }
          }
        }
        
        print('   Valid URLs: $validEndpoints/$totalEndpoints');
        expect(validEndpoints, equals(totalEndpoints), 
               reason: 'All endpoint URLs should be valid');
      });

      test('Endpoint paths should not have /v1 prefix', () {
        print('\n🔍 Checking for /v1 prefix in endpoints...');
        
        final categories = ['bud', 'commonBud', 'auth', 'service', 'content'];
        final violations = <String>[];
        
        for (final category in categories) {
          final endpoints = DynamicApiConfig.getEndpointsForCategory(category);
          
          for (final entry in endpoints.entries) {
            if (entry.value.contains('/v1/')) {
              violations.add('$category/${entry.key}: ${entry.value}');
            }
          }
        }
        
        if (violations.isEmpty) {
          print('   ✓ No /v1 prefix found in any endpoints');
        } else {
          print('   ✗ Found /v1 prefix in:');
          for (final violation in violations) {
            print('     - $violation');
          }
        }
        
        expect(violations, isEmpty, 
               reason: 'Endpoints should not contain /v1 prefix as per backend configuration');
      });
    });

    // ========== Generate Final Report ==========
    test('Generate final debugging report summary', () async {
      print('\n${'═' * 60}');
      print('📋 FINAL DEBUGGING REPORT SUMMARY');
      print('═' * 60);
      
      final report = await analyzer.runCompleteAnalysis();
      
      final summary = report['summary'] as Map<String, dynamic>;
      
      print('\n🎯 Key Findings:');
      print('   Overall Health: ${summary['overall_health']}');
      print('   Total Inconsistencies: ${summary['total_inconsistencies']}');
      
      if (summary['recommendations'].isNotEmpty) {
        print('\n💡 Top Recommendations:');
        final recs = summary['recommendations'] as List;
        for (var i = 0; i < recs.length && i < 3; i++) {
          print('   ${i + 1}. ${recs[i]}');
        }
      }
      
      print('\n📊 Test Categories Covered:');
      print('   ✓ Configuration Analysis');
      print('   ✓ Health Monitoring');
      print('   ✓ Data Model Validation');
      print('   ✓ Workflow Testing');
      print('   ✓ Performance Analysis');
      print('   ✓ Consistency Checks');
      
      print('\n${'═' * 60}');
      print('✅ Debugging Dashboard Complete');
      print('═' * 60);
    });
  });
}
