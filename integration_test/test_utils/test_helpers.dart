import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:get_it/get_it.dart';

// App imports
import 'package:musicbud_flutter/core/theme/design_system.dart';

// Models
import 'package:musicbud_flutter/models/user_profile.dart';
import 'package:musicbud_flutter/models/track.dart';
import 'package:musicbud_flutter/models/artist.dart';
import 'package:musicbud_flutter/models/genre.dart';
import 'package:musicbud_flutter/models/album.dart';
import 'package:musicbud_flutter/models/bud_search_result.dart';
import 'package:musicbud_flutter/models/auth_user.dart';

// BLoCs
import 'package:musicbud_flutter/blocs/user/user_bloc.dart';
import 'package:musicbud_flutter/blocs/user/user_event.dart';
import 'package:musicbud_flutter/blocs/user/user_state.dart';
import 'package:musicbud_flutter/blocs/discover/discover_bloc.dart';
import 'package:musicbud_flutter/blocs/user/profile/profile_bloc.dart';
import 'package:musicbud_flutter/presentation/blocs/search/search_bloc.dart';
import 'package:musicbud_flutter/blocs/chat/chat_bloc.dart';
import 'package:musicbud_flutter/blocs/library/library_bloc.dart';
import 'package:musicbud_flutter/blocs/bud/bud_bloc.dart';
import 'package:musicbud_flutter/blocs/bud_matching/bud_matching_bloc.dart';
import 'package:musicbud_flutter/blocs/settings/settings_bloc.dart';
import 'package:musicbud_flutter/blocs/event/event_bloc.dart';
import 'package:musicbud_flutter/blocs/spotify/spotify_bloc.dart';
import 'package:musicbud_flutter/blocs/auth/auth_bloc.dart' as auth_bloc;
import 'package:musicbud_flutter/blocs/auth/auth_event.dart' as auth_events;
import 'package:musicbud_flutter/blocs/auth/auth_state.dart' as auth_states;
import 'package:musicbud_flutter/blocs/auth/login/login_bloc.dart';
import 'package:musicbud_flutter/blocs/auth/login/login_event.dart';
import 'package:musicbud_flutter/blocs/auth/login/login_state.dart';
import 'package:musicbud_flutter/data/providers/token_provider.dart';

// Repositories
import 'package:musicbud_flutter/domain/repositories/user_profile_repository.dart';
import 'package:musicbud_flutter/domain/repositories/search_repository.dart';
import 'package:musicbud_flutter/domain/repositories/discover_repository.dart';
import 'package:musicbud_flutter/domain/repositories/auth_repository.dart';

// Async
import 'dart:async';

// Mock classes for BLoCs
class MockUserBloc extends Mock implements UserBloc {
  final _controller = StreamController<UserState>.broadcast();
  UserState _currentState = UserInitial();

  @override
  Stream<UserState> get stream => _controller.stream;

  @override
  UserState get state => _currentState;

  void emit(UserState state) {
    _currentState = state;
    _controller.add(state);
  }

  @override
  Future<void> close() async {
    await _controller.close();
  }
}

class MockAuthBloc extends Mock implements auth_bloc.AuthBloc {
  final _controller = StreamController<auth_bloc.AuthState>.broadcast();
  auth_bloc.AuthState _currentState = auth_bloc.AuthInitial();

  @override
  Stream<auth_bloc.AuthState> get stream => _controller.stream;

  @override
  auth_bloc.AuthState get state => _currentState;

  void emit(auth_bloc.AuthState state) {
    _currentState = state;
    _controller.add(state);
  }

  @override
  Future<void> close() async {
    await _controller.close();
  }
}

class MockLoginBloc extends Mock implements LoginBloc {
  final _controller = StreamController<LoginState>.broadcast();
  LoginState _currentState = LoginInitial();

  @override
  Stream<LoginState> get stream => _controller.stream;

  @override
  LoginState get state => _currentState;

  void emit(LoginState state) {
    _currentState = state;
    _controller.add(state);
  }

  @override
  Future<void> close() async {
    await _controller.close();
  }
}

class MockDiscoverBloc extends Mock implements DiscoverBloc {}
class MockProfileBloc extends Mock implements ProfileBloc {}
class MockSearchBloc extends Mock implements SearchBloc {}
class MockChatBloc extends Mock implements ChatBloc {}
class MockLibraryBloc extends Mock implements LibraryBloc {}
class MockBudBloc extends Mock implements BudBloc {}
class MockBudMatchingBloc extends Mock implements BudMatchingBloc {
  final _controller = StreamController<BudMatchingState>.broadcast();
  BudMatchingState _currentState = BudMatchingInitial();

  @override
  Stream<BudMatchingState> get stream => _controller.stream;

  @override
  BudMatchingState get state => _currentState;

  void emit(BudMatchingState state) {
    _currentState = state;
    _controller.add(state);
  }

  @override
  Future<void> close() async {
    await _controller.close();
  }
}
class MockSettingsBloc extends Mock implements SettingsBloc {}
class MockEventBloc extends Mock implements EventBloc {}
class MockSpotifyBloc extends Mock implements SpotifyBloc {}

// Mock repositories
class MockUserProfileRepository extends Mock implements UserProfileRepository {}
class MockSearchRepository extends Mock implements SearchRepository {}
class MockDiscoverRepository extends Mock implements DiscoverRepository {}
class MockAuthRepository extends Mock implements AuthRepository {}

// Mock providers
class MockTokenProvider extends Mock implements TokenProvider {
  String? _token;
  String? _refreshToken;

  @override
  String? get token => _token;

  @override
  String? get accessToken => _token;

  @override
  String? get refreshToken => _refreshToken;

  @override
  Future<void> initialize() async {
    // Mock implementation
  }

  @override
  Future<void> updateTokens(String accessToken, String refreshToken) async {
    _token = accessToken;
    _refreshToken = refreshToken;
  }

  @override
  Future<void> updateAccessToken(String newToken) async {
    _token = newToken;
  }

  @override
  Future<void> clearTokens() async {
    _token = null;
    _refreshToken = null;
  }
}

// Test data models
class TestData {
  static const testUserProfile = UserProfile(
    id: 'test_user_123',
    username: 'testuser',
    email: 'test@example.com',
    displayName: 'Test User',
    bio: 'Music lover and anime fan',
    avatarUrl: 'https://example.com/avatar.jpg',
    location: 'Test City',
    followersCount: 150,
    followingCount: 75,
    isActive: true,
    isAuthenticated: true,
    isAdmin: false,
  );

  static final testAuthUser = AuthUser(
    id: 'test_user_123',
    email: 'test@example.com',
    displayName: 'Test User',
    photoUrl: 'https://example.com/avatar.jpg',
    roles: ['user'],
    createdAt: DateTime(2023, 1, 1),
    lastLogin: DateTime(2024, 1, 1),
  );

  static final List<Track> testTracks = [
    Track(
      uid: 'track_1',
      title: 'Bohemian Rhapsody',
      artistName: 'Queen',
      albumName: 'A Night at the Opera',
      imageUrl: 'https://example.com/track1.jpg',
    ),
    Track(
      uid: 'track_2',
      title: 'Stairway to Heaven',
      artistName: 'Led Zeppelin',
      albumName: 'Led Zeppelin IV',
      imageUrl: 'https://example.com/track2.jpg',
    ),
  ];

  static final List<Artist> testArtists = [
    Artist(
      id: 'artist_1',
      name: 'Queen',
      imageUrls: ['https://example.com/queen.jpg'],
      genres: ['rock', 'classic rock'],
      popularity: 85,
    ),
    Artist(
      id: 'artist_2',
      name: 'Led Zeppelin',
      imageUrls: ['https://example.com/ledzep.jpg'],
      genres: ['rock', 'hard rock'],
      popularity: 82,
    ),
  ];

  static final List<Genre> testGenres = [
    Genre(id: 'genre_1', name: 'Pop', popularity: 150),
    Genre(id: 'genre_2', name: 'Rock', popularity: 120),
    Genre(id: 'genre_3', name: 'Hip Hop', popularity: 100),
  ];

  static final BudSearchResult testBudSearchResult = BudSearchResult(
    message: 'Search successful',
    code: 200,
    successful: true,
    data: BudSearchData(
      buds: [
        BudSearchItem(
          uid: 'user_1',
          displayName: 'John Doe',
          email: 'john@example.com',
          isActive: true,
          commonArtistsCount: 5,
          commonTracksCount: 10,
          commonGenresCount: 3,
        ),
        BudSearchItem(
          uid: 'user_2',
          displayName: 'Jane Smith',
          email: 'jane@example.com',
          isActive: true,
          commonArtistsCount: 3,
          commonTracksCount: 8,
          commonGenresCount: 2,
        ),
      ],
    ),
  );

  static final BudSearchResult emptyBudSearchResult = BudSearchResult(
    message: 'No results found',
    code: 200,
    successful: true,
    data: BudSearchData(buds: []),
  );
}

// Test widget wrappers
class TestAppWrapper extends StatelessWidget {
  final Widget child;
  final List<BlocProvider> providers;

  const TestAppWrapper({
    super.key,
    required this.child,
    this.providers = const [],
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: DesignSystem.darkTheme,
      home: MultiBlocProvider(
        providers: providers,
        child: child,
      ),
    );
  }
}

// Common test utilities
class IntegrationTestUtils {
  /// Pumps the widget and waits for it to settle
  static Future<void> pumpAndSettle(WidgetTester tester, Widget widget) async {
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();
  }

  /// Pumps the widget with a specific duration
  static Future<void> pumpForDuration(WidgetTester tester, Widget widget, Duration duration) async {
    await tester.pumpWidget(widget);
    await tester.pump(duration);
  }

  /// Taps on a widget and waits for settlement
  static Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  /// Enters text into a text field and waits for settlement
  static Future<void> enterTextAndSettle(WidgetTester tester, Finder finder, String text) async {
    await tester.enterText(finder, text);
    await tester.pumpAndSettle();
  }

  /// Scrolls to a specific widget
  static Future<void> scrollToAndSettle(WidgetTester tester, Finder finder) async {
    await tester.scrollUntilVisible(finder, 50.0);
    await tester.pumpAndSettle();
  }

  /// Drags from one point to another
  static Future<void> dragAndSettle(WidgetTester tester, Finder finder, Offset offset) async {
    await tester.drag(finder, offset);
    await tester.pumpAndSettle();
  }

  /// Waits for a specific condition to be true
  static Future<void> waitForCondition(
    WidgetTester tester,
    bool Function() condition, {
    Duration timeout = const Duration(seconds: 10),
    Duration pollInterval = const Duration(milliseconds: 100),
  }) async {
    final startTime = DateTime.now();
    while (!condition()) {
      if (DateTime.now().difference(startTime) > timeout) {
        throw TimeoutException('Condition not met within timeout period');
      }
      await tester.pump(pollInterval);
    }
  }

  /// Verifies that a widget is visible on screen
  static void expectWidgetVisible(Finder finder, {String? description}) {
    expect(finder, findsOneWidget, reason: description ?? 'Widget should be visible');
  }

  /// Verifies that a widget is not visible on screen
  static void expectWidgetNotVisible(Finder finder, {String? description}) {
    expect(finder, findsNothing, reason: description ?? 'Widget should not be visible');
  }

  /// Verifies that text is visible on screen
  static void expectTextVisible(String text, {String? description}) {
    expect(find.text(text), findsOneWidget, reason: description ?? 'Text "$text" should be visible');
  }

  /// Verifies that an icon is visible on screen
  static void expectIconVisible(IconData icon, {String? description}) {
    expect(find.byIcon(icon), findsOneWidget, reason: description ?? 'Icon $icon should be visible');
  }

  /// Verifies that a snackbar with specific text is shown
  static Future<void> expectSnackbarVisible(WidgetTester tester, String text) async {
    expect(find.text(text), findsOneWidget);
    // Wait for snackbar to auto-dismiss
    await tester.pump(const Duration(seconds: 4));
  }

  /// Dismisses a snackbar if visible
  static Future<void> dismissSnackbar(WidgetTester tester) async {
    final snackbarFinder = find.byType(SnackBar);
    if (snackbarFinder.evaluate().isNotEmpty) {
      await tester.tap(find.descendant(
        of: snackbarFinder,
        matching: find.byType(TextButton),
      ));
      await tester.pumpAndSettle();
    }
  }
}

// Custom matchers for better test assertions
class TestMatchers {
  /// Matches a widget that contains specific text
  static Finder containsText(String text) {
    return find.byWidgetPredicate((widget) {
      if (widget is Text) {
        return widget.data?.contains(text) ?? false;
      }
      return false;
    });
  }

  /// Matches a widget with specific color
  static Finder hasColor(Color color) {
    return find.byWidgetPredicate((widget) {
      if (widget is Container && widget.decoration is BoxDecoration) {
        final decoration = widget.decoration as BoxDecoration;
        return decoration.color == color;
      }
      return false;
    });
  }

  /// Matches a loading indicator
  static Finder get isLoading => find.byType(CircularProgressIndicator);

  /// Matches an error widget
  static Finder get isError => find.byIcon(Icons.error);
}

// Test setup utilities
class TestSetup {
  static void setupMockDependencies() {
    // Register mock dependencies with GetIt
    final sl = GetIt.instance;

    // Reset GetIt instance for testing
    sl.reset();

    // Register mock repositories
    sl.registerLazySingleton<UserProfileRepository>(() => MockUserProfileRepository());
    sl.registerLazySingleton<SearchRepository>(() => MockSearchRepository());
    sl.registerLazySingleton<DiscoverRepository>(() => MockDiscoverRepository());
    sl.registerLazySingleton<AuthRepository>(() => MockAuthRepository());

    // Register mock providers
    sl.registerLazySingleton<TokenProvider>(() => MockTokenProvider());

    // Register mock BLoCs
    sl.registerFactory(() => MockUserBloc());
    sl.registerFactory(() => MockAuthBloc());
    sl.registerFactory(() => MockLoginBloc());
    sl.registerFactory(() => MockDiscoverBloc());
    sl.registerFactory(() => MockProfileBloc());
    sl.registerFactory(() => MockSearchBloc());
    sl.registerFactory(() => MockChatBloc());
    sl.registerFactory(() => MockLibraryBloc());
    sl.registerFactory(() => MockBudBloc());
    sl.registerFactory(() => MockBudMatchingBloc());
    sl.registerFactory(() => MockSettingsBloc());
    sl.registerFactory(() => MockEventBloc());
    sl.registerFactory(() => MockSpotifyBloc());
  }

  static void teardownMockDependencies() {
    GetIt.instance.reset();
  }
}