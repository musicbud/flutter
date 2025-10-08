import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:musicbud_flutter/domain/repositories/auth_repository.dart';
import 'package:musicbud_flutter/domain/repositories/user_repository.dart';
import 'package:musicbud_flutter/domain/repositories/profile_repository.dart';
import 'package:musicbud_flutter/domain/repositories/content_repository.dart';
import 'package:musicbud_flutter/domain/repositories/bud_repository.dart';
import 'package:musicbud_flutter/domain/repositories/chat_repository.dart';
import 'package:musicbud_flutter/domain/repositories/user_profile_repository.dart';
import 'package:musicbud_flutter/domain/repositories/settings_repository.dart';
import 'package:musicbud_flutter/domain/repositories/event_repository.dart';
import 'package:musicbud_flutter/domain/repositories/analytics_repository.dart';
import 'package:musicbud_flutter/domain/repositories/admin_repository.dart';
import 'package:musicbud_flutter/domain/repositories/channel_repository.dart';
import 'package:musicbud_flutter/domain/repositories/search_repository.dart';
import 'package:musicbud_flutter/domain/repositories/services_repository.dart';
import 'package:musicbud_flutter/domain/repositories/library_repository.dart';
import 'package:musicbud_flutter/domain/repositories/common_items_repository.dart';
import 'package:musicbud_flutter/domain/repositories/spotify_repository.dart';
import 'package:musicbud_flutter/data/providers/token_provider.dart';
import 'package:musicbud_flutter/injection_container.dart';

// Mock classes for repositories
class MockAuthRepository extends Mock implements AuthRepository {}
class MockUserRepository extends Mock implements UserRepository {}
class MockProfileRepository extends Mock implements ProfileRepository {}
class MockContentRepository extends Mock implements ContentRepository {}
class MockBudRepository extends Mock implements BudRepository {}
class MockChatRepository extends Mock implements ChatRepository {}
class MockUserProfileRepository extends Mock implements UserProfileRepository {}
class MockSettingsRepository extends Mock implements SettingsRepository {}
class MockEventRepository extends Mock implements EventRepository {}
class MockAnalyticsRepository extends Mock implements AnalyticsRepository {}
class MockAdminRepository extends Mock implements AdminRepository {}
class MockChannelRepository extends Mock implements ChannelRepository {}
class MockSearchRepository extends Mock implements SearchRepository {}
class MockServicesRepository extends Mock implements ServicesRepository {}
class MockLibraryRepository extends Mock implements LibraryRepository {}
class MockCommonItemsRepository extends Mock implements CommonItemsRepository {}
class MockSpotifyRepository extends Mock implements SpotifyRepository {}

// Mock classes for providers and services
class MockTokenProvider extends Mock implements TokenProvider {}

/// Test setup utilities
class TestSetup {
  static MockAuthRepository? _mockAuthRepository;
  static MockUserRepository? _mockUserRepository;
  static MockProfileRepository? _mockProfileRepository;
  static MockContentRepository? _mockContentRepository;
  static MockBudRepository? _mockBudRepository;
  static MockChatRepository? _mockChatRepository;
  static MockUserProfileRepository? _mockUserProfileRepository;
  static MockSettingsRepository? _mockSettingsRepository;
  static MockEventRepository? _mockEventRepository;
  static MockAnalyticsRepository? _mockAnalyticsRepository;
  static MockAdminRepository? _mockAdminRepository;
  static MockChannelRepository? _mockChannelRepository;
  static MockSearchRepository? _mockSearchRepository;
  static MockServicesRepository? _mockServicesRepository;
  static MockLibraryRepository? _mockLibraryRepository;
  static MockCommonItemsRepository? _mockCommonItemsRepository;
  static MockSpotifyRepository? _mockSpotifyRepository;
  static MockTokenProvider? _mockTokenProvider;

  /// Initializes the dependency injection container with mock implementations
  static Future<void> initMockDependencies() async {
    // Reset GetIt first
    sl.reset();

    // Create and store mock instances
    _mockAuthRepository = MockAuthRepository();
    _mockUserRepository = MockUserRepository();
    _mockProfileRepository = MockProfileRepository();
    _mockContentRepository = MockContentRepository();
    _mockBudRepository = MockBudRepository();
    _mockChatRepository = MockChatRepository();
    _mockUserProfileRepository = MockUserProfileRepository();
    _mockSettingsRepository = MockSettingsRepository();
    _mockEventRepository = MockEventRepository();
    _mockAnalyticsRepository = MockAnalyticsRepository();
    _mockAdminRepository = MockAdminRepository();
    _mockChannelRepository = MockChannelRepository();
    _mockSearchRepository = MockSearchRepository();
    _mockServicesRepository = MockServicesRepository();
    _mockLibraryRepository = MockLibraryRepository();
    _mockCommonItemsRepository = MockCommonItemsRepository();
    _mockSpotifyRepository = MockSpotifyRepository();
    _mockTokenProvider = MockTokenProvider();

    // Note: Not registering mocks with GetIt since tests use them directly

    // Default stubs removed - tests should set up their own stubs
  }


  /// Resets the dependency injection container
  static void resetDependencies() {
    sl.reset();
    _mockAuthRepository = null;
    _mockUserRepository = null;
    _mockProfileRepository = null;
    _mockContentRepository = null;
    _mockBudRepository = null;
    _mockChatRepository = null;
    _mockUserProfileRepository = null;
    _mockSettingsRepository = null;
    _mockEventRepository = null;
    _mockAnalyticsRepository = null;
    _mockAdminRepository = null;
    _mockChannelRepository = null;
    _mockSearchRepository = null;
    _mockServicesRepository = null;
    _mockLibraryRepository = null;
    _mockCommonItemsRepository = null;
    _mockSpotifyRepository = null;
    _mockTokenProvider = null;
  }

  /// Resets all mock interactions (useful between tests)
  static void resetMocks() {
    if (_mockAuthRepository != null) reset(_mockAuthRepository!);
    if (_mockUserRepository != null) reset(_mockUserRepository!);
    if (_mockProfileRepository != null) reset(_mockProfileRepository!);
    if (_mockContentRepository != null) reset(_mockContentRepository!);
    if (_mockBudRepository != null) reset(_mockBudRepository!);
    if (_mockChatRepository != null) reset(_mockChatRepository!);
    if (_mockUserProfileRepository != null) reset(_mockUserProfileRepository!);
    if (_mockSettingsRepository != null) reset(_mockSettingsRepository!);
    if (_mockEventRepository != null) reset(_mockEventRepository!);
    if (_mockAnalyticsRepository != null) reset(_mockAnalyticsRepository!);
    if (_mockAdminRepository != null) reset(_mockAdminRepository!);
    if (_mockChannelRepository != null) reset(_mockChannelRepository!);
    if (_mockSearchRepository != null) reset(_mockSearchRepository!);
    if (_mockServicesRepository != null) reset(_mockServicesRepository!);
    if (_mockLibraryRepository != null) reset(_mockLibraryRepository!);
    if (_mockCommonItemsRepository != null) reset(_mockCommonItemsRepository!);
    if (_mockSpotifyRepository != null) reset(_mockSpotifyRepository!);
    if (_mockTokenProvider != null) reset(_mockTokenProvider!);
  }

  /// Gets a mock repository instance
  static T getMock<T extends Object>() {
    final typeName = T.toString();
    if (T == AuthRepository || typeName == 'MockAuthRepository') {
      return (_mockAuthRepository as T);
    } else if (T == UserRepository || typeName == 'MockUserRepository') {
      return (_mockUserRepository as T);
    } else if (T == ProfileRepository || typeName == 'MockProfileRepository') {
      return (_mockProfileRepository as T);
    } else if (T == ContentRepository || typeName == 'MockContentRepository') {
      return (_mockContentRepository as T);
    } else if (T == BudRepository || typeName == 'MockBudRepository') {
      return (_mockBudRepository as T);
    } else if (T == ChatRepository || typeName == 'MockChatRepository') {
      return (_mockChatRepository as T);
    } else if (T == UserProfileRepository || typeName == 'MockUserProfileRepository') {
      return (_mockUserProfileRepository as T);
    } else if (T == SettingsRepository || typeName == 'MockSettingsRepository') {
      return (_mockSettingsRepository as T);
    } else if (T == EventRepository || typeName == 'MockEventRepository') {
      return (_mockEventRepository as T);
    } else if (T == AnalyticsRepository || typeName == 'MockAnalyticsRepository') {
      return (_mockAnalyticsRepository as T);
    } else if (T == AdminRepository || typeName == 'MockAdminRepository') {
      return (_mockAdminRepository as T);
    } else if (T == ChannelRepository || typeName == 'MockChannelRepository') {
      return (_mockChannelRepository as T);
    } else if (T == SearchRepository || typeName == 'MockSearchRepository') {
      return (_mockSearchRepository as T);
    } else if (T == ServicesRepository || typeName == 'MockServicesRepository') {
      return (_mockServicesRepository as T);
    } else if (T == LibraryRepository || typeName == 'MockLibraryRepository') {
      return (_mockLibraryRepository as T);
    } else if (T == CommonItemsRepository || typeName == 'MockCommonItemsRepository') {
      return (_mockCommonItemsRepository as T);
    } else if (T == SpotifyRepository || typeName == 'MockSpotifyRepository') {
      return (_mockSpotifyRepository as T);
    } else if (T == TokenProvider || typeName == 'MockTokenProvider') {
      return (_mockTokenProvider as T);
    } else {
      throw UnsupportedError('Mock not found for type $T');
    }
  }
}

/// Common test utilities
class TestUtils {
  /// Creates a standard setUp function for bloc tests
  static Future<void> setUpBlocTest() async {
    await TestSetup.initMockDependencies();
  }

  /// Creates a standard tearDown function for bloc tests
  static void tearDownBlocTest() {
    TestSetup.resetMocks();
    TestSetup.resetDependencies();
  }

  /// Delays execution for a specified duration (useful for async operations)
  static Future<void> delay([Duration duration = const Duration(milliseconds: 100)]) async {
    await Future.delayed(duration);
  }

  /// Pumps the widget tree multiple times to ensure all async operations complete
  static Future<void> pumpAndSettleMultiple(
    WidgetTester tester, {
    int times = 3,
    Duration duration = const Duration(milliseconds: 100),
  }) async {
    for (int i = 0; i < times; i++) {
      await tester.pump(duration);
    }
    await tester.pumpAndSettle();
  }

  /// Verifies that a bloc emits the expected states in order
  static void expectBlocEmitsInOrder<T>(
    Stream<T> stream,
    List<T> expectedStates, {
    Duration timeout = const Duration(seconds: 5),
  }) {
    expectLater(
      stream,
      emitsInOrder(expectedStates),
    ).timeout(timeout);
  }

  /// Verifies that a bloc emits any of the expected states
  static void expectBlocEmitsAny<T>(
    Stream<T> stream,
    List<T> expectedStates, {
    Duration timeout = const Duration(seconds: 5),
  }) {
    expectLater(
      stream,
      emitsAnyOf(expectedStates),
    ).timeout(timeout);
  }
}

/// Mock response utilities
class MockResponses {
  /// Creates a successful API response
  static Map<String, dynamic> successResponse({
    required Map<String, dynamic> data,
  }) {
    return {
      'success': true,
      'data': data,
      'message': 'Success',
    };
  }

  /// Creates an error API response
  static Map<String, dynamic> errorResponse({
    required String message,
    int statusCode = 400,
  }) {
    return {
      'success': false,
      'message': message,
      'status_code': statusCode,
    };
  }

  /// Creates a paginated response
  static Map<String, dynamic> paginatedResponse({
    required List<dynamic> items,
    int currentPage = 1,
    int totalPages = 1,
    int totalItems = 0,
  }) {
    return {
      'success': true,
      'data': {
        'items': items,
        'pagination': {
          'current_page': currentPage,
          'total_pages': totalPages,
          'total_items': totalItems,
        },
      },
    };
  }
}

/// Test data validation utilities
class TestValidators {
  /// Validates that a list is not empty
  static void expectListNotEmpty<T>(List<T> list, {String? message}) {
    expect(list.isNotEmpty, true, reason: message ?? 'List should not be empty');
  }

  /// Validates that a list has the expected length
  static void expectListLength<T>(List<T> list, int expectedLength, {String? message}) {
    expect(list.length, expectedLength, reason: message ?? 'List length should be $expectedLength');
  }

  /// Validates that a string is not empty
  static void expectStringNotEmpty(String value, {String? message}) {
    expect(value.isNotEmpty, true, reason: message ?? 'String should not be empty');
  }

  /// Validates that an object is not null
  static void expectNotNull<T>(T? value, {String? message}) {
    expect(value, isNotNull, reason: message ?? 'Value should not be null');
  }

  /// Validates that a boolean is true
  static void expectTrue(bool value, {String? message}) {
    expect(value, true, reason: message ?? 'Value should be true');
  }

  /// Validates that a boolean is false
  static void expectFalse(bool value, {String? message}) {
    expect(value, false, reason: message ?? 'Value should be false');
  }
}