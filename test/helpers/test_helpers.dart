/// Test Helpers and Utilities
/// 
/// Common utilities, mocks, and fixtures for testing BLoCs and widgets

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Test Data Generators
class TestData {
  static Map<String, dynamic> createMockUser({
    String id = 'user123',
    String username = 'testuser',
    String email = 'test@example.com',
  }) {
    return {
      'id': id,
      'username': username,
      'email': email,
      'created_at': DateTime.now().toIso8601String(),
      'profile_image_url': 'https://example.com/avatar.jpg',
    };
  }

  static Map<String, dynamic> createMockTrack({
    String id = 'track123',
    String title = 'Test Track',
    String artist = 'Test Artist',
  }) {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'duration': 180,
      'album': 'Test Album',
      'release_date': '2024-01-01',
    };
  }

  static Map<String, dynamic> createMockArtist({
    String id = 'artist123',
    String name = 'Test Artist',
  }) {
    return {
      'id': id,
      'name': name,
      'genres': ['Rock', 'Pop'],
      'followers': 10000,
      'image_url': 'https://example.com/artist.jpg',
    };
  }

  static Map<String, dynamic> createMockAlbum({
    String id = 'album123',
    String title = 'Test Album',
  }) {
    return {
      'id': id,
      'title': title,
      'artist': 'Test Artist',
      'release_date': '2024-01-01',
      'track_count': 12,
    };
  }

  static Map<String, dynamic> createMockGenre({
    String id = 'genre123',
    String name = 'Rock',
  }) {
    return {
      'id': id,
      'name': name,
      'description': 'Rock music genre',
    };
  }

  static Map<String, dynamic> createMockProfile({
    String userId = 'user123',
    String username = 'testuser',
  }) {
    return {
      'user_id': userId,
      'username': username,
      'bio': 'Test bio',
      'location': 'Test City',
      'top_artists': [createMockArtist()],
      'top_tracks': [createMockTrack()],
      'liked_genres': [createMockGenre()],
    };
  }

  static Map<String, dynamic> createMockMessage({
    String id = 'msg123',
    String content = 'Test message',
    String senderId = 'user123',
  }) {
    return {
      'id': id,
      'content': content,
      'sender_id': senderId,
      'timestamp': DateTime.now().toIso8601String(),
      'read': false,
    };
  }

  static Map<String, dynamic> createMockChannel({
    String id = 'channel123',
    String name = 'Test Channel',
  }) {
    return {
      'id': id,
      'name': name,
      'description': 'Test channel description',
      'member_count': 5,
      'created_at': DateTime.now().toIso8601String(),
    };
  }

  static List<T> createList<T>(T Function(int) generator, int count) {
    return List.generate(count, generator);
  }
}

/// Widget Testing Helpers
class WidgetTestHelpers {
  /// Pump a widget with BLoC provider
  static Future<void> pumpBlocWidget<B extends BlocBase<S>, S>(
    WidgetTester tester,
    B bloc,
    Widget child,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<B>.value(
          value: bloc,
          child: child,
        ),
      ),
    );
  }

  /// Pump a widget with multiple BLoC providers
  static Future<void> pumpMultiBlocWidget(
    WidgetTester tester,
    List<BlocProvider> providers,
    Widget child,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: providers,
          child: child,
        ),
      ),
    );
  }

  /// Wait for async operations to complete
  static Future<void> waitForAsync(WidgetTester tester, {int milliseconds = 100}) async {
    await tester.pump(Duration(milliseconds: milliseconds));
    await tester.pumpAndSettle();
  }
}

/// Verification Helpers
class VerifyHelpers {
  /// Verify state transition occurred
  static void verifyStateTransition<S>(
    List<S> states,
    List<Type> expectedTypes,
  ) {
    expect(states.length, equals(expectedTypes.length));
    for (int i = 0; i < states.length; i++) {
      expect(states[i].runtimeType, equals(expectedTypes[i]));
    }
  }

  /// Verify error contains message
  static void verifyErrorMessage(dynamic error, String message) {
    expect(error.toString(), contains(message));
  }
}

/// Mock Response Builders
class MockResponses {
  static Map<String, dynamic> success({
    dynamic data,
    String message = 'Success',
  }) {
    return {
      'success': true,
      'message': message,
      'data': data,
    };
  }

  static Map<String, dynamic> error({
    String message = 'Error occurred',
    int statusCode = 500,
  }) {
    return {
      'success': false,
      'message': message,
      'status_code': statusCode,
    };
  }

  static Map<String, dynamic> paginatedResponse({
    required List<dynamic> items,
    int page = 1,
    int pageSize = 20,
    int total = 100,
  }) {
    return {
      'items': items,
      'page': page,
      'page_size': pageSize,
      'total': total,
      'has_more': (page * pageSize) < total,
    };
  }
}

/// Test Delays
class TestDelays {
  static const short = Duration(milliseconds: 100);
  static const medium = Duration(milliseconds: 500);
  static const long = Duration(seconds: 1);
}

/// Custom Matchers
class CustomMatchers {
  /// Matcher for checking if a list contains an item with a specific property
  static Matcher containsItemWith(String property, dynamic value) {
    return predicate<List>((list) {
      return list.any((item) {
        if (item is Map) {
          return item[property] == value;
        }
        return false;
      });
    }, 'contains item with $property = $value');
  }

  /// Matcher for checking state type
  static Matcher isStateType<T>() {
    return isA<T>();
  }

  /// Matcher for checking if state has property
  static Matcher hasProperty(String property) {
    return predicate((state) {
      try {
        // Try to access property using reflection or toString
        final str = state.toString();
        return str.contains(property);
      } catch (e) {
        return false;
      }
    }, 'has property $property');
  }
}

/// Bloc Testing Utilities
class BlocTestUtils {
  /// Create a list of events for testing
  static List<E> createEvents<E>(E Function(int) generator, int count) {
    return List.generate(count, generator);
  }

  /// Wait for bloc to emit states
  static Future<List<S>> collectStates<S>(
    Stream<S> stream,
    int count, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    final states = <S>[];
    final subscription = stream.listen((state) {
      states.add(state);
    });

    final completer = Completer<List<S>>();
    
    Future.delayed(timeout, () {
      if (!completer.isCompleted) {
        completer.complete(states);
      }
    });

    // Wait for all states or timeout
    while (states.length < count && !completer.isCompleted) {
      await Future.delayed(const Duration(milliseconds: 10));
    }

    subscription.cancel();
    return states;
  }
}

/// Error Simulation
class ErrorSimulator {
  static Exception networkError() {
    return Exception('Network error: Unable to connect to server');
  }

  static Exception timeoutError() {
    return Exception('Timeout: Request took too long');
  }

  static Exception authError() {
    return Exception('Authentication failed: Invalid credentials');
  }

  static Exception notFoundError() {
    return Exception('Not found: Resource does not exist');
  }

  static Exception validationError(String field) {
    return Exception('Validation error: $field is invalid');
  }
}

/// Assertion Helpers
class AssertHelpers {
  /// Assert state is loading
  static void assertIsLoading(dynamic state) {
    expect(state.toString().toLowerCase(), contains('loading'));
  }

  /// Assert state is error
  static void assertIsError(dynamic state) {
    expect(state.toString().toLowerCase(), contains('error'));
  }

  /// Assert state contains data
  static void assertHasData(dynamic state) {
    expect(state.toString().toLowerCase(), anyOf([
      contains('loaded'),
      contains('success'),
    ]));
  }
}
