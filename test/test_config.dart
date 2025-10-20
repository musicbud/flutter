// ignore_for_file: dangling_library_doc_comments

/// Comprehensive Test Configuration
/// 
/// This file contains global test configuration, setup, and utilities
/// used across all test suites in the MusicBud Flutter app.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:musicbud_flutter/models/track.dart';
import 'package:musicbud_flutter/models/artist.dart';
import 'package:musicbud_flutter/models/genre.dart';
import 'package:musicbud_flutter/models/album.dart';
import 'package:musicbud_flutter/models/bud_profile.dart';
import 'package:musicbud_flutter/models/bud_search_result.dart';
import 'package:musicbud_flutter/models/bud_match.dart';
import 'package:musicbud_flutter/models/common_artist.dart';
import 'package:musicbud_flutter/models/common_track.dart';
import 'package:musicbud_flutter/models/common_genre.dart';

// Test GetIt instance
final GetIt testSl = GetIt.instance;

/// Global test setup
/// Call this at the beginning of test suites that need dependency injection
Future<void> setupTestDependencies() async {
  // Reset GetIt
  if (testSl.isRegistered<Dio>()) {
    await testSl.reset();
  }

  // Register test dependencies
  TestWidgetsFlutterBinding.ensureInitialized();
  
  // Mock SharedPreferences
  SharedPreferences.setMockInitialValues({});
  final sharedPreferences = await SharedPreferences.getInstance();
  testSl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Mock Dio
  final dio = Dio();
  testSl.registerLazySingleton<Dio>(() => dio);
}

/// Tear down test dependencies
Future<void> tearDownTestDependencies() async {
  await testSl.reset();
}

/// Test configuration constants
class TestConfig {
  // API Configuration
  static const String testBaseUrl = 'http://test-api.musicbud.com';
  static const String testApiVersion = 'v1';
  
  // Test User Credentials
  static const String testUsername = 'test_user';
  static const String testEmail = 'test@musicbud.com';
  static const String testPassword = 'Test@123';
  static const String testToken = 'test_jwt_token_12345';
  static const String testRefreshToken = 'test_refresh_token_67890';
  
  // Test User Data
  static const String testUserId = 'test_user_id_001';
  static const String testDisplayName = 'Test User';
  static const String testBio = 'Test bio for testing';
  
  // Test Timeouts
  static const Duration shortTimeout = Duration(seconds: 2);
  static const Duration mediumTimeout = Duration(seconds: 5);
  static const Duration longTimeout = Duration(seconds: 10);
  
  // Test Delays
  static const Duration shortDelay = Duration(milliseconds: 100);
  static const Duration mediumDelay = Duration(milliseconds: 500);
  static const Duration longDelay = Duration(seconds: 1);
  
  // Network Simulation
  static const Duration networkDelay = Duration(milliseconds: 300);
  static const Duration slowNetworkDelay = Duration(seconds: 2);
  
  // Error Messages
  static const String networkErrorMessage = 'Network error occurred';
  static const String authErrorMessage = 'Authentication failed';
  static const String serverErrorMessage = 'Server error occurred';
  static const String validationErrorMessage = 'Validation failed';
}

/// Test utilities class
class TestUtils {
  /// Pump widget with MaterialApp wrapper
  static Future<void> pumpTestWidget(
    WidgetTester tester,
    Widget widget, {
    NavigatorObserver? navigatorObserver,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: widget,
        navigatorObservers: navigatorObserver != null ? [navigatorObserver] : [],
      ),
    );
  }

  /// Pump and settle with timeout
  static Future<void> pumpAndSettleWithTimeout(
    WidgetTester tester, {
    Duration? duration,
    Duration? timeout,
  }) async {
    await tester.pump(duration);
    await tester.pumpAndSettle(timeout ?? TestConfig.mediumTimeout);
  }

  /// Wait for async operations
  static Future<void> waitForAsync({
    Duration? duration,
  }) async {
    await Future.delayed(duration ?? TestConfig.shortDelay);
  }

  /// Create mock Dio response
  static Response<T> createMockResponse<T>({
    required T data,
    int statusCode = 200,
    String? statusMessage,
    Map<String, dynamic>? headers,
  }) {
    // Convert Map<String, dynamic> to Map<String, List<String>>
    final headerMap = headers?.map((key, value) => MapEntry(key, [value.toString()])) ?? <String, List<String>>{};
    
    return Response<T>(
      data: data,
      statusCode: statusCode,
      statusMessage: statusMessage,
      requestOptions: RequestOptions(path: '/test'),
      headers: Headers.fromMap(headerMap),
    );
  }

  /// Create mock error response
  static DioException createMockError({
    required String message,
    int statusCode = 500,
    DioExceptionType type = DioExceptionType.badResponse,
  }) {
    return DioException(
      requestOptions: RequestOptions(path: '/test'),
      type: type,
      message: message,
      response: Response(
        requestOptions: RequestOptions(path: '/test'),
        statusCode: statusCode,
        data: {'error': message},
      ),
    );
  }

  /// Find widget by type and text
  static Finder findWidgetWithText(Type widgetType, String text) {
    return find.ancestor(
      of: find.text(text),
      matching: find.byType(widgetType),
    );
  }

  /// Verify snackbar is shown
  static void verifySnackbar(WidgetTester tester, String message) {
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text(message), findsOneWidget);
  }

  /// Verify loading indicator
  static void verifyLoadingIndicator() {
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  }

  /// Verify no loading indicator
  static void verifyNoLoadingIndicator() {
    expect(find.byType(CircularProgressIndicator), findsNothing);
  }

  /// Tap button and pump
  static Future<void> tapButton(
    WidgetTester tester,
    Finder finder,
  ) async {
    await tester.tap(finder);
    await tester.pump();
  }

  /// Enter text in field and pump
  static Future<void> enterText(
    WidgetTester tester,
    Finder finder,
    String text,
  ) async {
    await tester.enterText(finder, text);
    await tester.pump();
  }

  /// Scroll until visible
  static Future<void> scrollUntilVisible(
    WidgetTester tester,
    Finder finder, {
    double delta = 300,
  }) async {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
  }
}

/// Custom matchers for testing
class TestMatchers {
  /// Check if state is loading
  static Matcher isLoadingState() => _IsLoadingStateMatcher();
  
  /// Check if state is error
  static Matcher isErrorState() => _IsErrorStateMatcher();
  
  /// Check if state is success
  static Matcher isSuccessState() => _IsSuccessStateMatcher();
}

class _IsLoadingStateMatcher extends Matcher {
  @override
  bool matches(dynamic item, Map matchState) {
    return item.toString().toLowerCase().contains('loading');
  }

  @override
  Description describe(Description description) {
    return description.add('is a loading state');
  }
}

class _IsErrorStateMatcher extends Matcher {
  @override
  bool matches(dynamic item, Map matchState) {
    return item.toString().toLowerCase().contains('error');
  }

  @override
  Description describe(Description description) {
    return description.add('is an error state');
  }
}

class _IsSuccessStateMatcher extends Matcher {
  @override
  bool matches(dynamic item, Map matchState) {
    return item.toString().toLowerCase().contains('success') ||
           item.toString().toLowerCase().contains('authenticated');
  }

  @override
  Description describe(Description description) {
    return description.add('is a success state');
  }
}

/// Test data generators
class TestDataGenerator {
  static Map<String, dynamic> generateLoginResponse() {
    return {
      'access_token': TestConfig.testToken,
      'refresh_token': TestConfig.testRefreshToken,
      'user': {
        'id': TestConfig.testUserId,
        'username': TestConfig.testUsername,
        'email': TestConfig.testEmail,
      },
    };
  }

  static Map<String, dynamic> generateUserProfile() {
    return {
      'id': TestConfig.testUserId,
      'username': TestConfig.testUsername,
      'email': TestConfig.testEmail,
      'display_name': TestConfig.testDisplayName,
      'bio': TestConfig.testBio,
      'profile_image_url': 'https://test.com/avatar.jpg',
      'created_at': DateTime.now().toIso8601String(),
    };
  }

  // Legacy method for backward compatibility
  static List<Map<String, dynamic>> generateContentList(int count) {
    return List.generate(count, (index) => {
      'id': 'content_$index',
      'title': 'Test Content $index',
      'description': 'Description for content $index',
      'type': 'music',
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  // Generate Track model objects
  static List<Track> generateTracks(int count) {
    return List.generate(
      count,
      (index) => Track(
        uid: 'track_$index',
        title: 'Test Track $index',
        artistName: 'Test Artist ${index % 5}',
        albumName: 'Test Album ${index % 3}',
        imageUrl: 'https://test.com/track_$index.jpg',
        isLiked: index % 3 == 0,
        playedAt: DateTime.now().subtract(Duration(days: index)),
      ),
    );
  }

  // Generate Artist model objects
  static List<Artist> generateArtists(int count) {
    return List.generate(
      count,
      (index) => Artist(
        id: 'artist_$index',
        uid: 'artist_uid_$index',
        name: 'Test Artist $index',
        genres: ['Rock', 'Pop', 'Jazz'][index % 3] != null ? [['Rock', 'Pop', 'Jazz'][index % 3]] : null,
        imageUrls: ['https://test.com/artist_$index.jpg'],
        isLiked: index % 2 == 0,
        popularity: 50 + (index % 50),
        followers: 1000 * (index + 1),
      ),
    );
  }

  // Generate Genre model objects
  static List<Genre> generateGenres(int count) {
    final genreNames = ['Rock', 'Pop', 'Jazz', 'Classical', 'Hip-Hop', 'Electronic', 'Country', 'R&B'];
    return List.generate(
      count,
      (index) => Genre(
        id: 'genre_$index',
        uid: 'genre_uid_$index',
        name: genreNames[index % genreNames.length],
        popularity: 60 + (index % 40),
        isLiked: index % 3 == 0,
      ),
    );
  }

  // Generate Album model objects
  static List<Album> generateAlbums(int count) {
    return List.generate(
      count,
      (index) => Album(
        id: 'album_$index',
        uid: 'album_uid_$index',
        name: 'Test Album $index',
        artistName: 'Test Artist ${index % 5}',
        artistId: 'artist_${index % 5}',
        imageUrls: ['https://test.com/album_$index.jpg'],
        isLiked: index % 2 == 0,
        releaseYear: 2020 + (index % 5),
        totalTracks: 10 + (index % 10),
        genres: ['Rock', 'Pop'][index % 2] != null ? [['Rock', 'Pop'][index % 2]] : null,
      ),
    );
  }

  // Generate BudMatch model objects
  static List<BudMatch> generateBudMatches(int count) {
    return List.generate(
      count,
      (index) => BudMatch(
        id: 'bud_$index',
        userId: 'user_$index',
        username: 'bud_user_$index',
        email: 'bud$index@test.com',
        avatarUrl: 'https://test.com/bud_$index.jpg',
        displayName: 'Bud User $index',
        bio: 'Test bio for bud $index',
        profileImageUrl: 'https://test.com/bud_$index.jpg',
        matchScore: 0.75 + (index % 25) / 100.0,
        commonArtists: 5 + (index % 10),
        commonTracks: 10 + (index % 15),
        commonGenres: 3 + (index % 5),
      ),
    );
  }

  // Generate BudProfile model object
  static BudProfile generateBudProfile() {
    return BudProfile(
      message: 'Bud profile retrieved successfully',
      data: BudProfileData(
        commonArtistsData: List.generate(
          5,
          (i) => CommonArtist(
            id: 'artist_$i',
            uid: 'artist_uid_$i',
            name: 'Common Artist $i',
            isLiked: i % 2 == 0,
          ),
        ),
        commonTracksData: List.generate(
          5,
          (i) => CommonTrack(
            id: 'track_$i',
            name: 'Common Track $i',
            artistName: 'Artist $i',
            isLiked: i % 2 == 0,
          ),
        ),
        commonGenresData: List.generate(
          5,
          (i) => CommonGenre(
            id: 'genre_$i',
            uid: 'genre_uid_$i',
            name: ['Rock', 'Pop', 'Jazz', 'Classical', 'Hip-Hop'][i],
            isLiked: i % 2 == 0,
          ),
        ),
      ),
    );
  }

  // Generate BudSearchResult model object
  static BudSearchResult generateBudSearchResult(int budCount) {
    return BudSearchResult(
      message: 'Bud search completed successfully',
      code: 200,
      successful: true,
      data: BudSearchData(
        buds: List.generate(
          budCount,
          (index) => BudSearchItem(
            uid: 'bud_$index',
            email: 'bud$index@test.com',
            country: 'US',
            displayName: 'Bud User $index',
            bio: 'Test bio for bud $index',
            isActive: true,
            isAuthenticated: true,
            commonTracksCount: 10 + (index % 15),
            commonArtistsCount: 5 + (index % 10),
            commonGenresCount: 3 + (index % 5),
            commonAlbumsCount: 4 + (index % 8),
          ),
        ),
        totalCommonTracksCount: budCount * 10,
        totalCommonArtistsCount: budCount * 5,
        totalCommonGenresCount: budCount * 3,
        totalCommonAlbumsCount: budCount * 4,
      ),
    );
  }

  // Legacy methods for backward compatibility
  static List<Map<String, dynamic>> generateBudList(int count) {
    return List.generate(count, (index) => {
      'id': 'bud_$index',
      'username': 'bud_user_$index',
      'display_name': 'Bud User $index',
      'compatibility_score': 75 + (index % 25),
      'profile_image_url': 'https://test.com/bud_$index.jpg',
    });
  }

  static List<Map<String, dynamic>> generateChatMessages(int count) {
    return List.generate(count, (index) => {
      'id': 'message_$index',
      'sender_id': index % 2 == 0 ? TestConfig.testUserId : 'other_user',
      'content': 'Test message $index',
      'timestamp': DateTime.now().subtract(Duration(minutes: count - index)).toIso8601String(),
    });
  }
}

/// Test logger for debugging tests
class TestLogger {
  static bool enabled = true;

  static void log(String message, {String tag = 'TEST'}) {
    if (enabled) {
      debugPrint('[$tag] $message');
    }
  }

  static void logError(String message, {Object? error, StackTrace? stackTrace}) {
    if (enabled) {
      debugPrint('❌ [TEST ERROR] $message');
      if (error != null) debugPrint('Error: $error');
      if (stackTrace != null) debugPrint('StackTrace: $stackTrace');
    }
  }

  static void logSuccess(String message) {
    if (enabled) {
      debugPrint('✅ [TEST SUCCESS] $message');
    }
  }

  static void logWarning(String message) {
    if (enabled) {
      debugPrint('⚠️  [TEST WARNING] $message');
    }
  }
}
